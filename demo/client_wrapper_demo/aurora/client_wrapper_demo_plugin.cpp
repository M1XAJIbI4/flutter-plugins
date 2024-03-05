/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <client_wrapper_demo/client_wrapper_demo_plugin.h>

constexpr auto ChannelName = "client_wrapper_demo";
constexpr auto ChannelNameBinary = "client_wrapper_demo_binary";

namespace MethodKeys {
  constexpr auto CreateTexture = "createTexture";
  constexpr auto BinaryMessengerEnable = "binaryMessengerEnable";
  constexpr auto BinaryMessengerDisable = "binaryMessengerDisable";
  constexpr auto Encodable = "encodable";
} // namespace Methods

void ClientWrapperDemoPlugin::RegisterWithRegistrar(PluginRegistrar* registrar)
{
    // Create MethodChannel for listen query, get data etc.
    auto channel = std::make_unique<MethodChannel>(
        registrar->messenger(), ChannelName,
        &flutter::StandardMethodCodec::GetInstance());

    auto* channel_pointer = channel.get();

    // Create plugin
    std::unique_ptr<ClientWrapperDemoPlugin> plugin(
        new ClientWrapperDemoPlugin(registrar, std::move(channel)));

    // Listen MethodChannel
    channel_pointer->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto& call, auto result) {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    // Create hendler raw BinaryMessenger
    plugin->RegisterBinaryMessengerHandler();

    // Register plugin
    registrar->AddPlugin(std::move(plugin));
}

ClientWrapperDemoPlugin::ClientWrapperDemoPlugin(
    PluginRegistrar* registrar,
    std::unique_ptr<MethodChannel> channel
) : m_channel(std::move(channel)),
    m_messenger(registrar->messenger()),
    m_textureRegistrar(registrar->texture_registrar())
{}

void ClientWrapperDemoPlugin::HandleMethodCall(
    const MethodCall& method_call, 
    std::unique_ptr<MethodResult> result
) {
    if (method_call.method_name().compare(MethodKeys::Encodable) == 0) {
        auto response = onEncodable(method_call);
        result->Success(response);
        return;
    }
    else if (method_call.method_name().compare(MethodKeys::CreateTexture) == 0) {
        auto response = onCreateTexture(method_call);
        result->Success(response);
        return;
    }
    result->Success();
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

// ========== binary_messenger ==========

void ClientWrapperDemoPlugin::RegisterBinaryMessengerHandler()
{
    // Client Wrapper listen headler BinaryMessenger
    m_messenger->SetMessageHandler(
        ChannelNameBinary,
        [this](const uint8_t* message, size_t message_size, flutter::BinaryReply) {
            auto data = std::string(message, message + message_size);
            // Check and run function by name
            if (data.find(MethodKeys::BinaryMessengerEnable) != std::string::npos) {
                onBinaryMessengerListenEnable();
            }
            else if (data.find(MethodKeys::BinaryMessengerDisable) != std::string::npos) {
                onBinaryMessengerListenDisable();
            }
        }
    );
}

void ClientWrapperDemoPlugin::onBinaryMessengerListenSend(DisplayOrientation orientation)
{
    // Send raw data to BinaryMessenger
    std::string value = std::to_string(static_cast<int>(orientation));
    std::string ouput = "{\"method\": \"ChangeDisplayOrientation\", \"args\": \""+value+"\"}";
    std::vector<uint8_t> message = {ouput.begin(), ouput.end()};

    m_messenger->Send(
        ChannelNameBinary,
        message.data(),
        message.size()
    );
}

void ClientWrapperDemoPlugin::onBinaryMessengerListenEnable()
{
    // Add listen if not init
    if (m_stateListenEvent == StateListenEvent::NOT_INIT) {
        PlatformEvents::SubscribeOrientationChanged(
            [this](DisplayOrientation orientation) {
                if (m_stateListenEvent == StateListenEvent::ENABLE) {
                    onBinaryMessengerListenSend(orientation);
                }
            });
    }
    // Enable listen
    m_stateListenEvent = StateListenEvent::ENABLE;
    // Send orientation after start
    onBinaryMessengerListenSend(PlatformMethods::GetOrientation());
}

void ClientWrapperDemoPlugin::onBinaryMessengerListenDisable()
{
    // Disable listen
    if (m_stateListenEvent == StateListenEvent::ENABLE) {
        m_stateListenEvent = StateListenEvent::DISABLE;
    }
}

