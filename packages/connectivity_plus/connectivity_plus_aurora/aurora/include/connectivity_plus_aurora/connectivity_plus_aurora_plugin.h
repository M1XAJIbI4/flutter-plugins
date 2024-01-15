/**
 * SPDX-FileCopyrightText: 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */

#ifndef FLUTTER_PLUGIN_CONNECTIVITY_PLUS_AURORA_PLUGIN_H
#define FLUTTER_PLUGIN_CONNECTIVITY_PLUS_AURORA_PLUGIN_H

#include <flutter/plugin-interface.h>
#include <connectivity_plus_aurora/globals.h>

#include <QNetworkConfiguration>
#include <QNetworkConfigurationManager>

class PLUGIN_EXPORT ConnectivityPlusAuroraPlugin final
    : public QObject
    , public PluginInterface
{
    Q_OBJECT

public:
    ConnectivityPlusAuroraPlugin();
    void RegisterWithRegistrar(PluginRegistrar &registrar) override;

public slots:
    void sendConnectionType();

private:
    void onMethodCall(const MethodCall &call);
    void onListen();
    void onCancel();

    void onCheck(const MethodCall &call);
    void unimplemented(const MethodCall &call);

    std::string getConnectionType();

    bool m_sendEvents;
    std::string m_connectionType;
    QNetworkConfigurationManager m_manager;

    QMetaObject::Connection m_onlineStateChangedConnection;
    QMetaObject::Connection m_configurationAddedConnection;
    QMetaObject::Connection m_configurationChangedConnection;
    QMetaObject::Connection m_configurationRemovedConnection;
};

#endif /* FLUTTER_PLUGIN_CONNECTIVITY_PLUS_AURORA_PLUGIN_H */
