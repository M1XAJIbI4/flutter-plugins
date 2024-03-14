/**
 * SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_SQFLITE_H
#define FLUTTER_PLUGIN_SQFLITE_H

#include <sqflite_aurora/encodable_helper.h>
#include <sqflite_aurora/async_queue.h>
#include <sqflite_aurora/database.h>
#include <sqflite_aurora/globals.h>

#include <flutter/flutter_aurora.h>
#include <flutter/plugin_registrar.h>
#include <flutter/method_channel.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_message_codec.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <mutex>
#include <unordered_map>

typedef flutter::Plugin Plugin;
typedef flutter::PluginRegistrar PluginRegistrar;
typedef flutter::MethodChannel<EncodableValue> MethodChannel;
typedef flutter::MethodCall<EncodableValue> MethodCall;
typedef flutter::MethodResult<EncodableValue> MethodResult;

class PLUGIN_EXPORT SqfliteAuroraPlugin final : public flutter::Plugin
{
public:
    static void RegisterWithRegistrar(PluginRegistrar* registrar);

private:
    // Creates a plugin that communicates on the given channel.
    SqfliteAuroraPlugin(std::unique_ptr<MethodChannel> methodChannel);

    // Methods register handlers channels
    void RegisterMethodHandler();

    // Methods return
    EncodableValue onPlatformVersionCall(const MethodCall &call);
    EncodableValue onDatabaseExistsCall(const MethodCall &call);
    EncodableValue onGetDatabasesPathCall(const MethodCall &call);
    EncodableValue onOptionsCall(const MethodCall &calloc);
    EncodableValue onDebugCall(const MethodCall &call);

    // Methods async
    void onOpenDatabaseCall(const MethodCall &call, std::shared_ptr<MethodResult> result);
    void onCloseDatabaseCall(const MethodCall &call, std::shared_ptr<MethodResult> result);
    void onDeleteDatabaseCall(const MethodCall &call, std::shared_ptr<MethodResult> result);
    void onExecuteCall(const MethodCall &call, std::shared_ptr<MethodResult> result);
    void onQueryCall(const MethodCall &call, std::shared_ptr<MethodResult> result);
    void onQueryCursorNextCall(const MethodCall &call, std::shared_ptr<MethodResult> result);
    void onUpdateCall(const MethodCall &call, std::shared_ptr<MethodResult> result);
    void onInsertCall(const MethodCall &call, std::shared_ptr<MethodResult> result);
    void onBatchCall(const MethodCall &call, std::shared_ptr<MethodResult> result);

    std::shared_ptr<Database> databaseByPath(const std::string &path);
    std::shared_ptr<Database> databaseByID(int64_t id);

    void databaseRemove(std::shared_ptr<Database> db);
    void databaseAdd(std::shared_ptr<Database> db);

    std::string formatError(
        const std::string &error,
        const std::string &message,
        const std::string &desc = ""
    );

    EncodableMap makeOpenResult(int64_t dbID, bool recovered, bool recoveredInTransaction);

private:
    std::mutex m_mutex;
    std::unordered_map<std::string, std::shared_ptr<Database>> m_singleInstanceDatabases;
    std::unordered_map<int64_t, std::shared_ptr<Database>> m_databases;
    int64_t m_dbID = 0;
    Logger m_logger;
    bool m_queryAsMapList = false;
    AsyncQueue m_asyncQueue;
    std::unique_ptr<MethodChannel> m_methodChannel;
};

#endif /* FLUTTER_PLUGIN_SQFLITE_H */
