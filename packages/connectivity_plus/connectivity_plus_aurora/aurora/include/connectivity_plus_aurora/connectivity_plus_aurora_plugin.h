/**
 * SPDX-FileCopyrightText: 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_CONNECTIVITY_PLUS_AURORA_PLUGIN_H
#define FLUTTER_PLUGIN_CONNECTIVITY_PLUS_AURORA_PLUGIN_H

#include <connectivity_plus_aurora/globals.h>

#include <QNetworkConfiguration>
#include <QNetworkConfigurationManager>

#include <flutter/plugin_registrar.h>
#include <flutter/method_channel.h>
#include <flutter/event_channel.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_method_codec.h>
#include <flutter/event_stream_handler_functions.h>

typedef flutter::Plugin Plugin;
typedef flutter::PluginRegistrar PluginRegistrar;
typedef flutter::EncodableValue EncodableValue;
typedef flutter::MethodChannel<EncodableValue> MethodChannel;
typedef flutter::MethodCall<EncodableValue> MethodCall;
typedef flutter::MethodResult<EncodableValue> MethodResult;
typedef flutter::EventChannel<EncodableValue> EventChannel;
typedef flutter::EventSink<EncodableValue> EventSink;

class PLUGIN_EXPORT ConnectivityPlusAuroraPlugin final
    : public QObject
    , public flutter::Plugin
{
    Q_OBJECT

public:
    static void RegisterWithRegistrar(PluginRegistrar* registrar);

public slots:
    void onEventChannelSend();

private:
    // Creates a plugin that communicates on the given channel.
    ConnectivityPlusAuroraPlugin(
        std::unique_ptr<MethodChannel> methodChannel,
        std::unique_ptr<EventChannel> eventChannel
    );

    // Methods register handlers channels
    void RegisterMethodHandler();
    void RegisterStreamHandler();

    // Other methods
    std::string getConnectionActiveName();
    void onEventChannelEnable();
    void onEventChannelDisable();

    std::unique_ptr<MethodChannel> m_methodChannel;
    std::unique_ptr<EventChannel> m_eventChannel;
    std::unique_ptr<EventSink> m_sink;

    bool m_stateEventChannel = false;
    std::string m_connectionActiveName;
    QNetworkConfigurationManager m_manager;
    QMetaObject::Connection m_onlineStateChangedConnection;
    QMetaObject::Connection m_configurationAddedConnection;
    QMetaObject::Connection m_configurationChangedConnection;
    QMetaObject::Connection m_configurationRemovedConnection;
};

#endif /* FLUTTER_PLUGIN_CONNECTIVITY_PLUS_AURORA_PLUGIN_H */
