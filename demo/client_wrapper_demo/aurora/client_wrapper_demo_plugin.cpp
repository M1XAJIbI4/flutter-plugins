/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <client_wrapper_demo/client_wrapper_demo_plugin.h>

namespace Channels {
    constexpr auto Event = "client_wrapper_demo_event";
    constexpr auto Methods = "client_wrapper_demo_methods";
    constexpr auto MessageBinary = "client_wrapper_demo_binary";
} // namespace Channels

namespace Methods {
    constexpr auto CreateTexture = "createTexture";
    constexpr auto EventChannelEnable = "eventChannelEnable";
    constexpr auto EventChannelDisable = "eventChannelDisable";
    constexpr auto BinaryMessengerEnable = "binaryMessengerEnable";
    constexpr auto BinaryMessengerDisable = "binaryMessengerDisable";
    constexpr auto Encodable = "encodable";
} // namespace Methods

void ClientWrapperDemoPlugin::RegisterWithRegistrar(PluginRegistrar* registrar)
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
    std::unique_ptr<ClientWrapperDemoPlugin> plugin(new ClientWrapperDemoPlugin(
        registrar,
        std::move(methodChannel),
        std::move(eventChannel))
    );

    // Register plugin
    registrar->AddPlugin(std::move(plugin));
}

ClientWrapperDemoPlugin::ClientWrapperDemoPlugin(
    PluginRegistrar* registrar,
    std::unique_ptr<MethodChannel> methodChannel,
    std::unique_ptr<EventChannel> eventChannel
) : m_methodChannel(std::move(methodChannel)),
    m_eventChannel(std::move(eventChannel)),
    m_messenger(registrar->messenger()),
    m_textureRegistrar(registrar->texture_registrar())
{
    // Create MethodHandler
    RegisterMethodHandler();

    // Create StreamHandler
    RegisterStreamHandler();

    // Create hendler raw BinaryMessenger
    RegisterBinaryMessengerHandler();

    // Listen change orientation
    aurora::SubscribeOrientationChanged(
        [this](aurora::DisplayOrientation orientation) {
            if (m_stateEventChannel) {
                onEventChannelSend(orientation);
            }
            if (m_stateBinaryMessenger) {
                onBinaryMessengerSend(orientation);
            }
        });
}

void ClientWrapperDemoPlugin::RegisterMethodHandler()
{
    m_methodChannel->SetMethodCallHandler(
        [this](const MethodCall& call, std::unique_ptr<MethodResult> result) {
            if (call.method_name().compare(Methods::Encodable) == 0) {
                result->Success(onEncodable(call));
            }
            else if (call.method_name().compare(Methods::CreateTexture) == 0) {
                result->Success(onCreateTexture(call));
            }
            else {
                result->Success();
            }
        });
}

void ClientWrapperDemoPlugin::RegisterStreamHandler()
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

void ClientWrapperDemoPlugin::RegisterBinaryMessengerHandler()
{
    m_messenger->SetMessageHandler(
        Channels::MessageBinary,
        [this](const uint8_t* message, size_t message_size, flutter::BinaryReply) {
            auto data = std::string(message, message + message_size);
            // Check and run function by name
            if (data.find(Methods::BinaryMessengerEnable) != std::string::npos) {
                onBinaryMessengerEnable();
            }
            else if (data.find(Methods::BinaryMessengerDisable) != std::string::npos) {
                onBinaryMessengerDisable();
            }
        }
    );
}

// ========== texture_registrar ==========

EncodableValue ClientWrapperDemoPlugin::onCreateTexture(const MethodCall &call)
{
    m_textures.push_back(std::make_shared<TextureVariant>(PixelBufferTexture(
        [this](size_t, size_t) -> const FlutterDesktopPixelBuffer* {
            return new FlutterDesktopPixelBuffer {
                (const uint8_t *) m_textureImage.constBits(), // Image 150x150
                (size_t) 150,
                (size_t) 150
            };
        })));

    return m_textureRegistrar->RegisterTexture(m_textures.back().get());
}

// ========== encodable_value ==========

EncodableValue ClientWrapperDemoPlugin::onEncodable(const MethodCall& method_call) 
{
    if (Helper::TypeIs<EncodableMap>(*method_call.arguments())) {
        // Get arguments
        const EncodableMap params = Helper::GetValue<EncodableMap>(*method_call.arguments());

        int32_t valInt = Helper::GetInt(params, "int");
        bool valBool = Helper::GetBool(params, "bool");
        std::string valString = Helper::GetString(params, "string");
        std::vector<int> valVectorInt = Helper::GetVectorInt(params, "vector_int");
        std::vector<double> valVectorDouble = Helper::GetVectorDouble(params, "vector_double");
        std::map<EncodableValue, EncodableValue> valMap = Helper::GetMap(params, "map");

        // Create send arguments
        return EncodableList {
            EncodableValue(valInt),
            EncodableValue(valBool),
            EncodableValue(valString),
            EncodableValue(valVectorInt),
            EncodableValue(valVectorDouble),
            EncodableValue(valMap),
        };
    }

    return EncodableValue();
}

// ========== event_channel ==========

void ClientWrapperDemoPlugin::onEventChannelSend(aurora::DisplayOrientation orientation)
{
    // Send data to EventChannel
    m_sink->Success(static_cast<int>(orientation));
}

void ClientWrapperDemoPlugin::onEventChannelEnable()
{
    // Enable listen
    m_stateEventChannel = true;
    // Send orientation after start
    onEventChannelSend(aurora::GetOrientation());
}

void ClientWrapperDemoPlugin::onEventChannelDisable()
{
    m_stateEventChannel = false;
}

// ========== binary_messenger ==========

void ClientWrapperDemoPlugin::onBinaryMessengerSend(aurora::DisplayOrientation orientation)
{
    // Send raw data to BinaryMessenger
    std::string value = std::to_string(static_cast<int>(orientation));
    std::string ouput = "{\"method\": \"ChangeDisplayOrientation\", \"args\": \""+value+"\"}";
    std::vector<uint8_t> message = {ouput.begin(), ouput.end()};

    m_messenger->Send(
        Channels::MessageBinary,
        message.data(),
        message.size()
    );
}

void ClientWrapperDemoPlugin::onBinaryMessengerEnable()
{
    // Enable listen
    m_stateBinaryMessenger = true;
    // Send orientation after start
    onBinaryMessengerSend(aurora::GetOrientation());
}

void ClientWrapperDemoPlugin::onBinaryMessengerDisable()
{
    m_stateBinaryMessenger = false;
}
