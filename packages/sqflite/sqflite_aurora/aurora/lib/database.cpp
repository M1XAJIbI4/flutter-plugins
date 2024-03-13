/**
 * SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <sqflite_aurora/constants.h>
#include <sqflite_aurora/database.h>

#include <filesystem>
#include <limits>

namespace {

void addError(EncodableList &results, const utils::error &error)
{
    if (error) {
        results.emplace_back(EncodableMap{
            {"error", EncodableMap{{"message", error.message()}}},
        });
    }
}

template<typename T>
void addResult(EncodableList &results, const T &result)
{
    results.emplace_back(EncodableMap{{"result", result}});
}

} /* namespace */

Database::Database(int id, const std::string &path, bool singleInstance, const Logger &logger)
    : m_id(id)
    , m_path(path)
    , m_isSingleInstance(singleInstance)
    , m_logger(logger.logLevel(), logger.tag() + "-db-" + std::to_string(id))
    , m_transactionID(0)
    , m_currentTransactionID(DatabaseTransaction::ID::None)
    , m_cursorID(0)
    , m_db(nullptr)
{}

Database::~Database()
{
    close();
}

utils::error Database::open()
{
    const auto error = createParentDir();
    if (error)
        return error;

    int result_code = sqlite3_open_v2(m_path.c_str(),
                                      &m_db,
                                      SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE,
                                      nullptr);
    if (result_code != SQLITE_OK)
        return utils::error(currentErrorMessage());

    m_isReadOnly = false;
    return utils::error::none();
}

utils::error Database::openReadOnly()
{
    const auto error = createParentDir();
    if (error)
        return error;

    int result_code = sqlite3_open_v2(m_path.c_str(), &m_db, SQLITE_OPEN_READONLY, nullptr);
    if (result_code != SQLITE_OK)
        return utils::error(currentErrorMessage());

    m_isReadOnly = true;
    return utils::error::none();
}

utils::error Database::close()
{
    if (sqlite3_close_v2(m_db) != SQLITE_OK)
        return utils::error(currentErrorMessage());

    m_db = nullptr;
    m_pendingSqlCallbacks = {};

    return utils::error::none();
}

utils::error Database::execute(const std::string &sql, const EncodableList &args)
{
    sqlite3_stmt *stmt = nullptr;

    if (sqlite3_prepare_v2(m_db, sql.c_str(), -1, &stmt, nullptr) != SQLITE_OK)
        return utils::error(currentErrorMessage());

    const auto error = bindStmtArgs(stmt, args);

    if (error) {
        sqlite3_finalize(stmt);
        return error;
    }

    while (true) {
        int status = sqlite3_step(stmt);

        if (status == SQLITE_ROW)
            continue;

        if (status == SQLITE_DONE)
            break;

        sqlite3_finalize(stmt);
        return utils::error(currentErrorMessage());
    }

    sqlite3_finalize(stmt);
    return utils::error::none();
}

utils::error Database::query(
    const std::string &sql,
    const EncodableList &args,
    EncodableMap &result
) {
    sqlite3_stmt *stmt = nullptr;

    if (sqlite3_prepare_v2(m_db, sql.c_str(), -1, &stmt, nullptr) != SQLITE_OK)
        return utils::error(currentErrorMessage());

    const auto error = bindStmtArgs(stmt, args);

    if (error) {
        sqlite3_finalize(stmt);
        return error;
    }

    EncodableList columns;

    for (int idx = 0; idx < sqlite3_column_count(stmt); idx++)
        columns.emplace_back(sqlite3_column_name(stmt, idx));

    EncodableList rows;

    while (true) {
        int status = sqlite3_step(stmt);

        if (status == SQLITE_ROW) {
            EncodableList row;

            for (size_t idx = 0; idx < columns.size(); idx++) {
                switch (sqlite3_column_type(stmt, idx)) {
                case SQLITE_INTEGER:
                    row.emplace_back(sqlite3_column_int64(stmt, idx));
                    break;
                case SQLITE_FLOAT:
                    row.emplace_back(sqlite3_column_double(stmt, idx));
                    break;
                case SQLITE_TEXT:
                    row.emplace_back(reinterpret_cast<const char *>(sqlite3_column_text(stmt, idx)));
                    break;
                case SQLITE_BLOB: {
                    const uint8_t *blob = reinterpret_cast<const uint8_t *>(
                        sqlite3_column_blob(stmt, idx));
                    std::vector<uint8_t> v(blob, blob + sqlite3_column_bytes(stmt, idx));
                    row.emplace_back(v);
                    break;
                }
                case SQLITE_NULL: {
                    const char *columnDecltype = sqlite3_column_decltype(stmt, idx);

                    if (columnDecltype != NULL && std::string("BLOB") == columnDecltype)
                        row.emplace_back(std::vector<uint8_t>());
                    else
                        row.emplace_back(nullptr);

                    break;
                }
                default:
                    break;
                }
            }

            rows.emplace_back(row);
            continue;
        }

        if (status == SQLITE_DONE)
            break;

        sqlite3_finalize(stmt);
        return utils::error(currentErrorMessage());
    }

    result = EncodableMap{{"columns", columns}, {"rows", rows}};

    sqlite3_finalize(stmt);
    return utils::error::none();
}

utils::error Database::queryWithPageSize(const std::string &sql,
                                                       const EncodableList &args,
                                                       int64_t pageSize,
                                                       EncodableMap &result)
{
    sqlite3_stmt *stmt = nullptr;

    if (sqlite3_prepare_v2(m_db, sql.c_str(), -1, &stmt, nullptr) != SQLITE_OK)
        return utils::error(currentErrorMessage());

    const auto error = bindStmtArgs(stmt, args);

    if (error)
        return error;

    m_cursorID += 1;
    m_cursors[m_cursorID] = Cursor{m_cursorID, stmt, pageSize};

    return resultFromCursor(m_cursors[m_cursorID], result);
}

utils::error Database::queryCursorNext(int cursorID,
                                                     bool cancel,
                                                     EncodableMap &result)
{
    m_logger.verb() << "querying cursor next (ID=" << cursorID << "; CANCEL=" << cancel << ")"
                    << std::endl;

    if (!m_cursors.count(cursorID))
        return utils::error("cursor not found");

    const Cursor &cursor = m_cursors[cursorID];

    if (cancel) {
        closeCursor(cursor);
        return utils::error::none();
    }

    return resultFromCursor(cursor, result);
}

utils::error Database::insert(const std::string &sql,
                                            const EncodableList &args,
                                            int &insertID)
{
    if (m_isReadOnly)
        return utils::error("database is readonly");

    const auto error = execute(sql, args);

    if (error)
        return error;

    const int updated = sqlite3_changes(m_db);

    m_logger.sql() << "rows updated: " << updated << std::endl;

    if (updated == 0) {
        insertID = 0;
        return utils::error::none();
    }

    insertID = sqlite3_last_insert_rowid(m_db);
    m_logger.sql() << "last inserted row id: " << insertID << std::endl;

    return utils::error::none();
}

utils::error Database::update(const std::string &sql,
                                            const EncodableList &args,
                                            int &updated)
{
    if (m_isReadOnly)
        return utils::error("database is readonly");

    const auto error = execute(sql, args);

    if (error)
        return error;

    updated = sqlite3_changes(m_db);
    m_logger.sql() << "rows updated: " << updated << std::endl;

    return utils::error::none();
}

void Database::processSqlCommand(int transactionID, const SqlCommandCallback &callback)
{
    if (m_currentTransactionID == DatabaseTransaction::ID::None) {
        callback();
        return;
    }

    if (transactionID == m_currentTransactionID || transactionID == DatabaseTransaction::ID::Force) {
        callback();

        if (m_currentTransactionID == DatabaseTransaction::ID::None) {
            while (!m_pendingSqlCallbacks.empty() && isOpen()) {
                const auto &pendingCallback = m_pendingSqlCallbacks.front();
                pendingCallback();
                m_pendingSqlCallbacks.pop();
            }
        }

        return;
    }

    m_pendingSqlCallbacks.push(callback);
}

void Database::enterInTransaction()
{
    m_transactionID += 1;
    m_currentTransactionID = m_transactionID;
}

void Database::leaveTransaction()
{
    m_currentTransactionID = DatabaseTransaction::ID::None;
}

int Database::currentTransactionID()
{
    return m_currentTransactionID;
}

bool Database::isOpen() const
{
    return m_db != nullptr;
}

const std::string &Database::path() const
{
    return m_path;
}

bool Database::isSingleInstance() const
{
    return m_isSingleInstance;
}

bool Database::isReadOnly() const
{
    return m_isReadOnly;
}

bool Database::isInTransaction() const
{
    return m_currentTransactionID != DatabaseTransaction::ID::None;
}

int64_t Database::id() const
{
    return m_id;
}

Logger::Level Database::logLevel() const
{
    return m_logger.logLevel();
}

bool Database::isInMemory() const
{
    return m_path.empty() || m_path == ":memory:";
}

std::string Database::currentErrorMessage()
{
    const auto message = sqlite3_errmsg(m_db);
    const auto code = sqlite3_extended_errcode(m_db);

    return std::string(message) + " (" + std::to_string(code) + ")";
}

utils::error Database::createParentDir()
{
    if (isInMemory())
        return utils::error::none();

    const auto parentDir = std::filesystem::path(m_path).parent_path();

    if (std::filesystem::exists(parentDir))
        return utils::error::none();

    if (std::filesystem::create_directories(parentDir))
        return utils::error::none();

    return utils::error("couldn't create parent directory");
}

utils::error Database::bindStmtArgs(sqlite3_stmt *stmt, const EncodableList &args)
{
    int result = SQLITE_OK;

    for (size_t i = 0; i < args.size(); i++) {
        auto idx = i + 1;
        EncodableValue arg = args[i];

        if (arg.IsNull()) {
            result = sqlite3_bind_null(stmt, idx);
        } 
        else if (Val::TypeIs<bool>(arg)) {
            result = sqlite3_bind_int(stmt, idx, static_cast<int>(Val::GetValue<bool>(arg)));
        } 
        else if (Val::TypeIs<int>(arg)) {
            const int64_t value = Val::GetValue<int>(arg);

            const int32_t i32min = std::numeric_limits<int32_t>::min();
            const int32_t i32max = std::numeric_limits<int32_t>::max();

            if (value < i32min || value > i32max)
                result = sqlite3_bind_int64(stmt, idx, Val::GetValue<int>(arg));
            else
                result = sqlite3_bind_int64(stmt, idx, static_cast<int32_t>(Val::GetValue<int>(arg)));
        } 
        else if (Val::TypeIs<double>(arg)) {
            result = sqlite3_bind_double(stmt, idx, Val::GetValue<double>(arg));
        } 
        else if (Val::TypeIs<std::string>(arg)) {
            const auto &string = Val::GetValue<std::string>(arg);
            result = sqlite3_bind_text(stmt, idx, string.c_str(), string.size(), SQLITE_TRANSIENT);
        } 
        else if (Val::TypeIs<std::vector<uint8_t>>(arg)) {
            const auto container = Val::GetVector<uint8_t>(arg);
            result = sqlite3_bind_blob(stmt,
                                       idx,
                                       container.data(),
                                       container.size(),
                                       SQLITE_TRANSIENT);
        } 
        else if (Val::TypeIs<std::vector<int32_t>>(arg)) {
            const auto container = Val::GetVector<int32_t>(arg);
            result = sqlite3_bind_blob(stmt,
                                       idx,
                                       container.data(),
                                       container.size() * sizeof(int32_t),
                                       SQLITE_TRANSIENT);
        } 
        else if (Val::TypeIs<std::vector<int64_t>>(arg)) {
            const auto container = Val::GetVector<int64_t>(arg);
            result = sqlite3_bind_blob(stmt,
                                       idx,
                                       container.data(),
                                       container.size() * sizeof(int64_t),
                                       SQLITE_TRANSIENT);
        } 
        else if (Val::TypeIs<std::vector<float>>(arg)) {
            const auto container = Val::GetVector<float>(arg);
            result = sqlite3_bind_blob(stmt,
                                       idx,
                                       container.data(),
                                       container.size() * sizeof(float),
                                       SQLITE_TRANSIENT);
        }
        else if (Val::TypeIs<std::vector<double>>(arg)) {
            const auto container = Val::GetVector<double>(arg);
            result = sqlite3_bind_blob(stmt,
                                       idx,
                                       container.data(),
                                       container.size() * sizeof(double),
                                       SQLITE_TRANSIENT);
        } 
        else if (Val::TypeIs<EncodableList>(arg)) {
            /* only bytes list is supported */
            std::vector<uint8_t> container;

            for (const auto &entry : Val::GetValue<EncodableList>(arg)) {
                if (!Val::TypeIs<int>(entry))
                    return utils::error("only list of bytes is supported for statement parameter");

                const auto value = Val::GetValue<int>(entry);

                if (value < 0 || value > 255)
                    return utils::error("only list of bytes is supported for statement parameter");

                container.push_back(static_cast<uint8_t>(value));
            }

            result = sqlite3_bind_blob(stmt,
                                       idx,
                                       container.data(),
                                       container.size(),
                                       SQLITE_TRANSIENT);
        }
        else {
            return utils::error("statement parameter has invalid type");
        }

        if (result != SQLITE_OK)
            return utils::error(currentErrorMessage());
    }

    m_logger.sql() << sqlite3_expanded_sql(stmt) << std::endl;
    return utils::error::none();
}

void Database::closeCursor(const Cursor &cursor)
{
    m_logger.verb() << "closing cursor (ID=" << cursor.id << ")" << std::endl;
    sqlite3_finalize(cursor.stmt);
    m_cursors.erase(cursor.id);
}

utils::error Database::resultFromCursor(const Cursor &cursor, EncodableMap &result)
{
    EncodableList columns;

    for (int idx = 0; idx < sqlite3_column_count(cursor.stmt); idx++)
        columns.emplace_back(sqlite3_column_name(cursor.stmt, idx));

    EncodableList rows;
    int status = SQLITE_ROW;

    while (static_cast<int64_t>(rows.size()) < cursor.pageSize) {
        status = sqlite3_step(cursor.stmt);

        if (status == SQLITE_ROW) {
            EncodableList row;

            for (size_t idx = 0; idx < columns.size(); idx++) {
                switch (sqlite3_column_type(cursor.stmt, idx)) {
                case SQLITE_INTEGER:
                    row.emplace_back(sqlite3_column_int64(cursor.stmt, idx));
                    break;
                case SQLITE_FLOAT:
                    row.emplace_back(sqlite3_column_double(cursor.stmt, idx));
                    break;
                case SQLITE_TEXT:
                    row.emplace_back(
                        reinterpret_cast<const char *>(sqlite3_column_text(cursor.stmt, idx)));
                    break;
                case SQLITE_BLOB: {
                    const uint8_t *blob = reinterpret_cast<const uint8_t *>(
                        sqlite3_column_blob(cursor.stmt, idx));
                    std::vector<uint8_t> v(blob, blob + sqlite3_column_bytes(cursor.stmt, idx));
                    row.emplace_back(v);
                    break;
                }
                case SQLITE_NULL: {
                    const char *columnDecltype = sqlite3_column_decltype(cursor.stmt, idx);

                    if (columnDecltype != NULL && std::string("BLOB") == columnDecltype)
                        row.emplace_back(std::vector<uint8_t>());
                    else
                        row.emplace_back(nullptr);

                    break;
                }
                default:
                    break;
                }
            }

            rows.emplace_back(row);
            continue;
        }

        if (status == SQLITE_DONE) {
            closeCursor(cursor);
            break;
        }

        closeCursor(cursor);
        return utils::error(currentErrorMessage());
    }

    result = EncodableMap{{"columns", columns}, {"rows", rows}};

    if (status != SQLITE_DONE)
        result.insert({Arguments::CursorId, cursor.id});

    return utils::error::none();
}

utils::error Database::batch(const std::vector<Operation> &operations,
                                           bool continueOnError,
                                           EncodableList &results)
{
    for (const auto &operation : operations) {
        const auto &method = operation.method;

        if (method == Methods::Insert) {
            int insertID = 0;
            const auto error = insert(operation.sql, operation.arguments, insertID);

            if (error) {
                if (!continueOnError)
                    return error;

                addError(results, error);
                continue;
            }

            if (insertID == 0)
                addResult(results, nullptr);
            else
                addResult(results, insertID);

            continue;
        }

        if (method == Methods::Execute) {
            const auto error = execute(operation.sql, operation.arguments);

            if (error) {
                if (!continueOnError)
                    return error;

                addError(results, error);
                continue;
            }

            addResult(results, nullptr);
            continue;
        }

        if (method == Methods::Query) {
            EncodableMap result;
            const auto error = query(operation.sql, operation.arguments, result);

            if (error) {
                if (!continueOnError)
                    return error;

                addError(results, error);
                continue;
            }

            addResult(results, result);
            continue;
        }

        if (method == Methods::Update) {
            int updated = 0;
            const auto error = update(operation.sql, operation.arguments, updated);

            if (error) {
                if (!continueOnError)
                    return error;

                addError(results, error);
                continue;
            }

            addResult(results, updated);
            continue;
        }
    }

    return utils::error::none();
}
