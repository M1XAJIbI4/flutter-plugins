/**
 * SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <flutter/platform-methods.h>
#include <flutter/logger.h>

#include <sqflite_aurora/constants.h>
#include <sqflite_aurora/sqflite_aurora_plugin.h>

#include <filesystem>
#include <fstream>

void SqfliteAuroraPlugin::RegisterWithRegistrar(PluginRegistrar* registrar)
{
    // Create MethodChannel with StandardMethodCodec
    auto methodChannel = std::make_unique<MethodChannel>(
        registrar->messenger(), Channels::Methods,
        &flutter::StandardMethodCodec::GetInstance());

    // Create plugin
    std::unique_ptr<SqfliteAuroraPlugin> plugin(new SqfliteAuroraPlugin(
        std::move(methodChannel)
    ));

    // Register plugin
    registrar->AddPlugin(std::move(plugin));
}

SqfliteAuroraPlugin::SqfliteAuroraPlugin(std::unique_ptr<MethodChannel> methodChannel)
    : m_dbID(0)
    , m_logger(Logger::Level::None, "sqflite")
    , m_methodChannel(std::move(methodChannel))
{
    // Create MethodHandler
    RegisterMethodHandler();
}

void SqfliteAuroraPlugin::RegisterMethodHandler()
{
    m_methodChannel->SetMethodCallHandler(
        [&](const MethodCall& call, std::unique_ptr<MethodResult> result) {
            auto methodResult = std::shared_ptr<MethodResult>(std::move(result));
            // Methods with return
            if (call.method_name().compare(Methods::PlatformVersion) == 0) {
                methodResult->Success(onPlatformVersionCall(call));
            }
            else if (call.method_name().compare(Methods::DatabaseExists) == 0) {
                methodResult->Success(onDatabaseExistsCall(call));
            }
            else if (call.method_name().compare(Methods::DatabasesPath) == 0) {
                methodResult->Success(onGetDatabasesPathCall(call));
            }
            else if (call.method_name().compare(Methods::Options) == 0) {
                methodResult->Success(onOptionsCall(call));
            }
            else if (call.method_name().compare(Methods::Debug) == 0) {
                methodResult->Success(onDebugCall(call));
            }
            // Methods with async
            else if (call.method_name().compare(Methods::OpenDatabase) == 0) {
                onOpenDatabaseCall(call, methodResult);
            }
            else if (call.method_name().compare(Methods::CloseDatabase) == 0) {
                onCloseDatabaseCall(call, methodResult);
            }
            else if (call.method_name().compare(Methods::DeleteDatabase) == 0) {
                onDeleteDatabaseCall(call, methodResult);
            }
            else if (call.method_name().compare(Methods::Execute) == 0) {
                onExecuteCall(call, methodResult);
            }
            else if (call.method_name().compare(Methods::Query) == 0) {
                onQueryCall(call, methodResult);
            }
            else if (call.method_name().compare(Methods::QueryCursorNext) == 0) {
                onQueryCursorNextCall(call, methodResult);
            }
            else if (call.method_name().compare(Methods::Update) == 0) {
                onUpdateCall(call, methodResult);
            }
            else if (call.method_name().compare(Methods::Insert) == 0) {
                onInsertCall(call, methodResult);
            }
            else if (call.method_name().compare(Methods::Batch) == 0) {
                onBatchCall(call, methodResult);
            }
            else {
                result->Success();
            }
        });
}

EncodableValue SqfliteAuroraPlugin::onPlatformVersionCall(const MethodCall &)
{
    std::ifstream in("/etc/os-release");
    std::string line;
    while (in.is_open() && std::getline(in, line)) {
        if (line.rfind("VERSION_ID=") != 0)
            continue;
        return "Aurora " + line.substr(11);
    }
    return "Aurora";
}

EncodableValue SqfliteAuroraPlugin::onDatabaseExistsCall(const MethodCall &call) 
{
    const auto dbPath = Val::FindString(call, Arguments::Path);
    return std::filesystem::exists(dbPath);
}

EncodableValue SqfliteAuroraPlugin::onGetDatabasesPathCall(const MethodCall &)
{
    const auto home = std::getenv("HOME");
    const auto orgname = PlatformMethods::GetOrgname();
    const auto appname = PlatformMethods::GetAppname();
    const auto directory = std::filesystem::path(home) / ".local/share" / orgname / appname;
    return directory.generic_string();
}

EncodableValue SqfliteAuroraPlugin::onOptionsCall(const MethodCall &call) 
{
    const auto level = Val::FindInt(call, Arguments::LogLevel);
    m_logger.setLogLevel(static_cast<Logger::Level>(level));
    return EncodableValue();
}

EncodableValue SqfliteAuroraPlugin::onDebugCall(const MethodCall &call) 
{
    const auto cmd = Val::FindString(call, Arguments::Command);

    std::lock_guard<std::mutex> lock(m_mutex);
    EncodableMap response;

    if (cmd == "get") {
        if (m_logger.logLevel() > Logger::Level::None)
            response.emplace(Arguments::LogLevel, EncodableValue(m_logger.logLevel()));

        if (!m_databases.empty()) {
            EncodableMap databases;

            for (const auto &[id, db] : m_databases) {
                EncodableMap info;

                info.emplace(Arguments::Path, db->path());
                info.emplace(Arguments::SingleInstance, db->isSingleInstance());

                if (db->logLevel() > Logger::Level::None)
                    info.emplace(Arguments::LogLevel, EncodableValue(db->logLevel()));

                databases.emplace(std::to_string(id), info);
            }

            response.emplace(Arguments::Databases, databases);
        }
    }
    return response;
}

void SqfliteAuroraPlugin::onOpenDatabaseCall(
    const MethodCall &call,
    std::shared_ptr<MethodResult> result
) {
    const auto dbPath = Val::FindString(call, Arguments::Path);
    const auto readOnly = Val::FindBool(call, Arguments::ReadOnly);

    const auto inMemory = dbPath.empty() || dbPath == ":memory:";
    auto isSingleInstance = Val::FindBool(call, Arguments::SingleInstance) && !inMemory;

    if (isSingleInstance) {
        const auto db = databaseByPath(dbPath);

        if (db) {
            if (db->isOpen()) {
                m_logger.verb() << "re-opened single instance database"
                                << (db->isInTransaction() ? "(in transaction) " : "") << db->id()
                                << " " << db->path() << std::endl;

                result->Success(makeOpenResult(db->id(), true, db->isInTransaction()));
                return;
            }

            m_logger.verb() << "single instance database " << db->path() << " not opened"
                            << std::endl;
        }
    }

    const auto db = std::make_shared<Database>(++m_dbID, dbPath, isSingleInstance, m_logger);

    m_asyncQueue.push([this, db, readOnly, result] {
        m_logger.sql() << "open database " + db->path() + " (ID=" << db->id() << ")" << std::endl;

        const auto error = readOnly ? db->openReadOnly() : db->open();
        if (error) {
            result->Error(Errors::Sqflite, formatError(
                Errors::Open, 
                db->path(),
                error.message()
            ));
            return;
        }

        databaseAdd(db);
        result->Success(makeOpenResult(db->id(), false, false));
    });
}

void SqfliteAuroraPlugin::onCloseDatabaseCall(
    const MethodCall &call,
    std::shared_ptr<MethodResult> result
) {
    const auto dbID = Val::FindInt(call, Arguments::Id);
    const auto db = databaseByID(dbID);

    m_asyncQueue.push([this, db, dbID, result] {
        if (!db) {
            result->Error(Errors::Sqflite, formatError(
                Errors::Closed,
                "database closed",
                "ID=" + std::to_string(dbID) + ")"
            ));
            return;
        }

        m_logger.sql() << "closing database with ID=" << db->id() << std::endl;

        const auto error = db->close();
        if (error) {
            result->Error(Errors::Sqflite, formatError(
                Errors::Close, 
                db->path(),
                error.message()
            ));
            return;
        }

        databaseRemove(db);
        result->Success();
    });
}

void SqfliteAuroraPlugin::onDeleteDatabaseCall(
    const MethodCall &call,
    std::shared_ptr<MethodResult> result
) {
    const auto dbPath = Val::FindString(call, Arguments::Path);

    const auto db = databaseByPath(dbPath);

    m_asyncQueue.push([this, db, dbPath, result = std::shared_ptr<MethodResult>(std::move(result))] {
        if (db) {
            if (db->isOpen()) {
                m_logger.verb() << "close database " << db->path() << " (ID=" << db->id() << ")"
                                << std::endl;

                const auto error = db->close();
                if (error) {
                    result->Error(Errors::Sqflite, formatError(
                        Errors::Close, 
                        db->path(),
                        error.message()
                    ));
                    return;
                }
            }

            databaseRemove(db);
        }

        if (std::filesystem::exists(dbPath)) {
            m_logger.verb() << "delete not opened database " << dbPath << std::endl;
            std::filesystem::remove(dbPath);
        }

        result->Success();
    });
}

void SqfliteAuroraPlugin::onExecuteCall(
    const MethodCall &call,
    std::shared_ptr<MethodResult> result
) {
    const auto dbID = Val::FindInt(call, Arguments::Id);
    const auto sql = Val::FindString(call, Arguments::Sql);
    const auto inTransactionChange = Val::FindBool(call, Arguments::InTransaction);
    const auto sqlArgs = Val::FindList(call, Arguments::SqlArguments);
    const auto transactionID = Val::FindTransaction(call, Arguments::TransactionId);

    const auto enteringTransaction = inTransactionChange == true
                                     && transactionID == DatabaseTransaction::ID::None;

    const auto db = databaseByID(dbID);

    if (!db) {
        result->Error(Errors::Sqflite, formatError(
            Errors::Closed, 
            "database closed",
            "ID=" + std::to_string(dbID) + ")"
        ));
        return;
    }

    m_asyncQueue.push([
        this,
        db,
        sql,
        sqlArgs,
        inTransactionChange,
        enteringTransaction,
        transactionID,
        result
    ] {
        db->processSqlCommand(transactionID, [this, db, sql, sqlArgs, inTransactionChange, enteringTransaction, result] {
            if (enteringTransaction) {
                db->enterInTransaction();
            }
            const auto error = db->execute(sql, sqlArgs);
            if (error) {
                db->leaveTransaction();
                result->Error(Errors::Sqflite, formatError(
                    Errors::Internal,
                    error.message()
                ));
                return;
            }
            if (enteringTransaction) {
                result->Success(EncodableMap{
                    {Arguments::TransactionId, db->currentTransactionID()}
                });
                return;
            }
            if (inTransactionChange == false) {
                db->leaveTransaction();
            }
            result->Success();
        });
    });
}

void SqfliteAuroraPlugin::onQueryCall(
    const MethodCall &call,
    std::shared_ptr<MethodResult> result
) {
    const auto dbID = Val::FindInt(call, Arguments::Id);
    const auto sql = Val::FindString(call, Arguments::Sql);
    const auto pageSize = Val::FindInt(call, Arguments::CursorPageSize);
    const auto sqlArgs = Val::FindList(call, Arguments::SqlArguments);
    const auto transactionID = Val::FindTransaction(call, Arguments::TransactionId);

    const auto db = databaseByID(dbID);

    if (!db) {
        result->Error(Errors::Sqflite, formatError(
            Errors::Closed, 
            "database closed",
            "ID=" + std::to_string(dbID) + ")"
        ));
        return;
    }

    m_asyncQueue.push([
        this,
        db,
        sql,
        sqlArgs,
        transactionID,
        pageSize,
        result
    ] {
        db->processSqlCommand(transactionID, [this, db, sql, sqlArgs, pageSize, result] {
            EncodableMap response;
            utils::error error;
            if (pageSize <= 0) {
                error = db->query(sql, sqlArgs, response);
            }
            else {
                error = db->queryWithPageSize(sql, sqlArgs, pageSize, response);
            }
            if (error) {
                result->Error(Errors::Sqflite, formatError(
                    Errors::Internal,
                    error.message()
                ));
                return;
            }
            result->Success(response);
        });
    });
}

void SqfliteAuroraPlugin::onQueryCursorNextCall(
    const MethodCall &call,
    std::shared_ptr<MethodResult> result
) {
    const auto dbID = Val::FindInt(call, Arguments::Id);
    const auto cursorID = Val::FindInt(call, Arguments::CursorId);
    const auto closeCursor = Val::FindBool(call, Arguments::Cancel);
    const auto transactionID = Val::FindTransaction(call, Arguments::TransactionId);

    const auto db = databaseByID(dbID);

    if (!db) {
        result->Error(Errors::Sqflite, formatError(
            Errors::Closed, 
            "database closed",
            "ID=" + std::to_string(dbID) + ")"
        ));
        return;
    }

    m_asyncQueue.push([
        this,
        db,
        cursorID,
        closeCursor,
        transactionID,
        result
    ] {
        db->processSqlCommand(transactionID, [this, db, cursorID, closeCursor, result] {
            EncodableMap response;
            const auto error = db->queryCursorNext(cursorID, closeCursor, response);
            if (error) {
                result->Error(Errors::Sqflite, formatError(
                    Errors::Internal,
                    error.message()
                ));
                return;
            }
            result->Success(response);
        });
    });
}

void SqfliteAuroraPlugin::onUpdateCall(
    const MethodCall &call,
    std::shared_ptr<MethodResult> result
) {
    const auto dbID = Val::FindInt(call, Arguments::Id);
    const auto sql = Val::FindString(call, Arguments::Sql);
    const auto sqlArgs = Val::FindList(call, Arguments::SqlArguments);
    const auto transactionID = Val::FindTransaction(call, Arguments::TransactionId);

    const auto db = databaseByID(dbID);

    if (!db) {
        result->Error(Errors::Sqflite, formatError(
            Errors::Closed, 
            "database closed",
            "ID=" + std::to_string(dbID) + ")"
        ));
        return;
    }

    m_asyncQueue.push([
        this,
        db,
        sql,
        sqlArgs,
        transactionID,
        result
    ] {
        db->processSqlCommand(transactionID, [this, db, sql, sqlArgs, result] {
            int updated = 0;
            const auto error = db->update(sql, sqlArgs, updated);
            if (error) {
                result->Error(Errors::Sqflite, formatError(
                    Errors::Internal,
                    error.message()
                ));
                return;
            }
            result->Success(updated);
        });
    });
}

void SqfliteAuroraPlugin::onInsertCall(
    const MethodCall &call,
    std::shared_ptr<MethodResult> result
) {
    const auto dbID = Val::FindInt(call, Arguments::Id);
    const auto sql = Val::FindString(call, Arguments::Sql);
    const auto sqlArgs = Val::FindList(call, Arguments::SqlArguments);
    const auto transactionID = Val::FindTransaction(call, Arguments::TransactionId);

    const auto db = databaseByID(dbID);

    if (!db) {
        result->Error(Errors::Sqflite, formatError(
            Errors::Closed, 
            "database closed",
            "ID=" + std::to_string(dbID) + ")"
        ));
        return;
    }

    m_asyncQueue.push([
        this,
        db,
        sql,
        sqlArgs,
        transactionID,
        result
    ] {
        db->processSqlCommand(transactionID, [this, db, sql, sqlArgs, result] {
            int insertID = 0;
            const auto error = db->insert(sql, sqlArgs, insertID);
            if (error) {
                result->Error(Errors::Sqflite, formatError(
                    Errors::Internal,
                    error.message()
                ));
                return;
            }
            if (insertID == 0) {
                result->Success();
            }
            else {
                result->Success(insertID);
            }
        });
    });
}

void SqfliteAuroraPlugin::onBatchCall(
    const MethodCall &call,
    std::shared_ptr<MethodResult> result
) {
    const auto dbID = Val::FindInt(call, Arguments::Id);
    const auto operations = Val::FindList(call, Arguments::Operations);
    const auto noResult = Val::FindBool(call, Arguments::NoResult);
    const auto continueOnError = Val::FindBool(call, Arguments::ContinueOnError);
    const auto transactionID = Val::FindTransaction(call, Arguments::TransactionId);

    const auto db = databaseByID(dbID);

    if (!db) {
        result->Error(Errors::Sqflite, formatError(
            Errors::Closed, 
            "database closed",
            "ID=" + std::to_string(dbID) + ")"
        ));
        return;
    }

    std::vector<Database::Operation> dbOperations;

    for (const auto &operation : operations) {
        auto map = Val::GetValue<EncodableMap>(operation);
        dbOperations.emplace_back(Database::Operation{
            Val::GetString(map, Arguments::Method),
            Val::GetString(map, Arguments::Sql),
            Val::GetList(map, Arguments::SqlArguments)
        });
    }

    m_asyncQueue.push([
        this,
        db,
        dbOperations,
        transactionID,
        continueOnError,
        noResult,
        result
    ] {
        const auto command = [this, db, dbOperations, continueOnError, noResult, result] {
            EncodableList results;
            const auto error = db->batch(dbOperations, continueOnError, results);
            if (error) {
                result->Error(Errors::Sqflite, formatError(
                    Errors::Internal,
                    error.message()
                ));
                return;
            }
            if (noResult) {
                result->Success();
            }
            else {
                result->Success(results);
            }
        };
        db->processSqlCommand(transactionID, command);
    });
}

std::shared_ptr<Database> SqfliteAuroraPlugin::databaseByPath(const std::string &path)
{
    std::lock_guard<std::mutex> lock(m_mutex);
    if (!m_singleInstanceDatabases.count(path)) {
        return nullptr;
    }
    return m_singleInstanceDatabases.at(path);
}

std::shared_ptr<Database> SqfliteAuroraPlugin::databaseByID(int64_t id)
{
    std::lock_guard<std::mutex> lock(m_mutex);
    if (!m_databases.count(id)) {
        return nullptr;
    }
    return m_databases.at(id);
}

void SqfliteAuroraPlugin::databaseRemove(std::shared_ptr<Database> db)
{
    std::lock_guard<std::mutex> lock(m_mutex);
    if (db->isSingleInstance()) {
        m_singleInstanceDatabases.erase(db->path());
    }
    m_databases.erase(db->id());
}

void SqfliteAuroraPlugin::databaseAdd(std::shared_ptr<Database> db)
{
    std::lock_guard<std::mutex> lock(m_mutex);

    if (db->isSingleInstance()) {
        m_singleInstanceDatabases.emplace(db->path(), db);
    }

    m_databases.emplace(db->id(), db);
}

std::string SqfliteAuroraPlugin::formatError(
    const std::string &error,
    const std::string &message,
    const std::string &desc
) {
    return error + ": " + message + (desc.empty() ? "" : " (" + desc + ")");
}

EncodableMap SqfliteAuroraPlugin::makeOpenResult(
    int64_t dbID,
    bool recovered,
    bool recoveredInTransaction
) {
    EncodableMap result = {{Arguments::Id, dbID}};
    if (recovered) {
        result.emplace(Arguments::Recovered, true);
    }
    if (recoveredInTransaction) {
        result.emplace(Arguments::RecoveredInTransaction, true);
    }
    return result;
}
