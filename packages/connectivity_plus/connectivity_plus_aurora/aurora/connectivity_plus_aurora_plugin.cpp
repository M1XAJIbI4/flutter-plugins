/**
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <connectivity_plus_aurora/connectivity_plus_aurora_plugin.h>


namespace Channels {
    constexpr auto Event = "dev.fluttercommunity.plus/connectivity_status";
    constexpr auto Methods = "dev.fluttercommunity.plus/connectivity";
} // namespace Channels

namespace Methods {
    constexpr auto Check = "check";
} // namespace Methods

namespace ConnectionType {
    constexpr auto Bluetooth = "bluetooth";
    constexpr auto Wifi = "wifi";
    constexpr auto Ethernet = "ethernet";
    constexpr auto Mobile = "mobile";
    constexpr auto Vpn = "vpn";
    constexpr auto Other = "other";
    constexpr auto None = "none";
} // namespace ConnectionType

void ConnectivityPlusAuroraPlugin::RegisterWithRegistrar(PluginRegistrar* registrar)
{
    // Create MethodChannel with StandardMethodCodec
    auto methodChannel = std::make_unique<MethodChannel>(
        registrar->messenger(), Channels::Methods,
        &flutter::StandardMethodCodec::GetInstance());

    // Create EventChannel with StandardMethodCodec
    auto eventChannel = std::make_unique<EventChannel>(
        registrar->messenger(), Channels::Event,
        &flutter::StandardMethodCodec::GetInstance());

    // Create plugin
    std::unique_ptr<ConnectivityPlusAuroraPlugin> plugin(new ConnectivityPlusAuroraPlugin(
        std::move(methodChannel),
        std::move(eventChannel))
    );

    // Register plugin
    registrar->AddPlugin(std::move(plugin));
}

ConnectivityPlusAuroraPlugin::ConnectivityPlusAuroraPlugin(
    std::unique_ptr<MethodChannel> methodChannel,
    std::unique_ptr<EventChannel> eventChannel
) : m_methodChannel(std::move(methodChannel)),
    m_eventChannel(std::move(eventChannel))
{
    // Create MethodHandler
    RegisterMethodHandler();

    // Create StreamHandler
    RegisterStreamHandler();
}

void ConnectivityPlusAuroraPlugin::RegisterMethodHandler()
{
    m_methodChannel->SetMethodCallHandler(
        [&](const MethodCall& call, std::unique_ptr<MethodResult> result) {
            if (call.method_name().compare(Methods::Check) == 0) {
                result->Success(getConnectionActiveName());
            }
            else {
                result->Success();
            }
        });
}

void ConnectivityPlusAuroraPlugin::RegisterStreamHandler()
{
    auto handler = std::make_unique<flutter::StreamHandlerFunctions<EncodableValue>>(
        [&](const EncodableValue* arguments,
            std::unique_ptr<flutter::EventSink<EncodableValue>>&& events
        ) -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            m_sink = std::move(events);
            onEventChannelEnable();
            return nullptr;
        },
        [&](const EncodableValue* arguments) -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            onEventChannelDisable();
            return nullptr;
        }
    );

    m_eventChannel->SetStreamHandler(std::move(handler));
}

void ConnectivityPlusAuroraPlugin::onEventChannelSend()
{
    auto connectionActiveName = getConnectionActiveName();
    if (m_connectionActiveName != connectionActiveName && m_stateEventChannel) {
        m_connectionActiveName = connectionActiveName;
        m_sink->Success(connectionActiveName);
    }
}

void ConnectivityPlusAuroraPlugin::onEventChannelEnable()
{
    // Enable listen
    m_stateEventChannel = true;
    // Send orientation after start
    onEventChannelSend();
    // Disconnect listen connection
    m_onlineStateChangedConnection =
        QObject::connect(&m_manager,
                         &QNetworkConfigurationManager::onlineStateChanged,
                         this,
                         &ConnectivityPlusAuroraPlugin::onEventChannelSend);

    m_configurationAddedConnection =
        QObject::connect(&m_manager,
                         &QNetworkConfigurationManager::configurationAdded,
                         this,
                         &ConnectivityPlusAuroraPlugin::onEventChannelSend);

    m_configurationChangedConnection =
        QObject::connect(&m_manager,
                         &QNetworkConfigurationManager::configurationChanged,
                         this,
                         &ConnectivityPlusAuroraPlugin::onEventChannelSend);

    m_configurationRemovedConnection =
        QObject::connect(&m_manager,
                         &QNetworkConfigurationManager::configurationRemoved,
                         this,
                         &ConnectivityPlusAuroraPlugin::onEventChannelSend);
}

void ConnectivityPlusAuroraPlugin::onEventChannelDisable()
{
    // Disable liste
    m_stateEventChannel = false;
    // Disconnect listen connection
    QObject::disconnect(m_onlineStateChangedConnection);
    QObject::disconnect(m_configurationAddedConnection);
    QObject::disconnect(m_configurationChangedConnection);
    QObject::disconnect(m_configurationRemovedConnection);
}

std::string ConnectivityPlusAuroraPlugin::getConnectionActiveName()
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
