/**
 * SPDX-FileCopyrightText: 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <connectivity_plus_aurora/connectivity_plus_aurora_plugin.h>
#include <flutter/method-channel.h>

namespace Method {

constexpr auto Channel = "dev.fluttercommunity.plus/connectivity";
constexpr auto Check = "check";

} /* namespace Method */

namespace Event {

constexpr auto Channel = "dev.fluttercommunity.plus/connectivity_status";

} /* namespace Event */

namespace ConnectionType {

constexpr auto Bluetooth = "bluetooth";
constexpr auto Wifi = "wifi";
constexpr auto Ethernet = "ethernet";
constexpr auto Mobile = "mobile";
constexpr auto Vpn = "vpn";
constexpr auto Other = "other";
constexpr auto None = "none";

} /* namespace ConnectionType */

ConnectivityPlusAuroraPlugin::ConnectivityPlusAuroraPlugin()
    : m_sendEvents(false)
    , m_connectionType(ConnectionType::None)
{}

void ConnectivityPlusAuroraPlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{
    registrar.RegisterMethodChannel(Method::Channel,
                                    MethodCodecType::Standard,
                                    [this](const MethodCall &call) {
                                        this->onMethodCall(call);
                                    });

    registrar.RegisterEventChannel(Event::Channel,
                                    MethodCodecType::Standard,
                                    [this](const Encodable &) {
                                        this->onListen();
                                        return EventResponse();
                                    },
                                    [this](const Encodable &) {
                                        this->onCancel();
                                        return EventResponse();
                                    });
}

void ConnectivityPlusAuroraPlugin::onMethodCall(const MethodCall &call)
{
    if (call.GetMethod() == Method::Check) {
        onCheck(call);
        return;
    }

    unimplemented(call);
}

void ConnectivityPlusAuroraPlugin::onListen()
{
    m_onlineStateChangedConnection =
        QObject::connect(&m_manager,
                         &QNetworkConfigurationManager::onlineStateChanged,
                         this,
                         &ConnectivityPlusAuroraPlugin::sendConnectionType);

    m_configurationAddedConnection =
        QObject::connect(&m_manager,
                         &QNetworkConfigurationManager::configurationAdded,
                         this,
                         &ConnectivityPlusAuroraPlugin::sendConnectionType);

    m_configurationChangedConnection =
        QObject::connect(&m_manager,
                         &QNetworkConfigurationManager::configurationChanged,
                         this,
                         &ConnectivityPlusAuroraPlugin::sendConnectionType);

    m_configurationRemovedConnection =
        QObject::connect(&m_manager,
                         &QNetworkConfigurationManager::configurationRemoved,
                         this,
                         &ConnectivityPlusAuroraPlugin::sendConnectionType);

    m_sendEvents = true;

    sendConnectionType();
}

void ConnectivityPlusAuroraPlugin::onCancel()
{
    m_sendEvents = false;

    QObject::disconnect(m_onlineStateChangedConnection);
    QObject::disconnect(m_configurationAddedConnection);
    QObject::disconnect(m_configurationChangedConnection);
    QObject::disconnect(m_configurationRemovedConnection);
}

void ConnectivityPlusAuroraPlugin::onCheck(const MethodCall &call)
{
    auto m_connectionType = getConnectionType();

    call.SendSuccessResponse(m_connectionType);
}

void ConnectivityPlusAuroraPlugin::sendConnectionType()
{
    auto connectionType = getConnectionType();

    if (m_connectionType == connectionType) {
        return;
    }

    m_connectionType = connectionType;

    if (m_sendEvents) {
        EventChannel(Event::Channel, MethodCodecType::Standard).SendEvent(m_connectionType);
    }
}

void ConnectivityPlusAuroraPlugin::unimplemented(const MethodCall &call)
{
    call.SendSuccessResponse(nullptr);
}

std::string ConnectivityPlusAuroraPlugin::getConnectionType()
{
    if (m_manager.isOnline()) {
        const QNetworkConfiguration conf = m_manager.defaultConfiguration();

        switch (conf.bearerType()) {
        case QNetworkConfiguration::BearerEthernet:
            return ConnectionType::Ethernet;
        case QNetworkConfiguration::BearerWLAN:
        case QNetworkConfiguration::BearerWiMAX:
            return ConnectionType::Wifi;
        case QNetworkConfiguration::Bearer2G:
        case QNetworkConfiguration::Bearer3G:
        case QNetworkConfiguration::Bearer4G:
        case QNetworkConfiguration::BearerCDMA2000:
        case QNetworkConfiguration::BearerWCDMA:
        case QNetworkConfiguration::BearerHSPA:
        case QNetworkConfiguration::BearerEVDO:
        case QNetworkConfiguration::BearerLTE:
            return ConnectionType::Mobile;
        case QNetworkConfiguration::BearerBluetooth:
            return ConnectionType::Bluetooth;
        case QNetworkConfiguration::BearerUnknown:
        default:
            return ConnectionType::Other;
        }
    } else {
        return ConnectionType::None;
    }
}

#include "moc_connectivity_plus_aurora_plugin.cpp"
