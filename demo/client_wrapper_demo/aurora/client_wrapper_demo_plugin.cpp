/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <client_wrapper_demo/client_wrapper_demo_plugin.h>

namespace MethodKeys {
  constexpr auto PluginKey = "client_wrapper_demo";

  constexpr auto CreateTexture = "createTexture";
  constexpr auto BinaryMessengerEnable = "binaryMessengerEnable";
  constexpr auto BinaryMessengerDisable = "binaryMessengerDisable";
  constexpr auto Encodable = "encodable";
} // namespace Methods

void ClientWrapperDemoPlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{
    // Get texture registrar
    m_textureRegistrar = registrar.texture_registrar();

    // Get binary messenger
    m_messenger = registrar.messenger();

    // Init hendler demo
    RegisterBinaryMessengerHandler();

    // Init methods
    RegisterMethods(registrar);
}

void ClientWrapperDemoPlugin::RegisterMethods(PluginRegistrar &registrar)
{
    // Embedder register method
    auto methods = [this](const MethodCall &call) {
        const auto &method = call.GetMethod();
        if (method == MethodKeys::CreateTexture) {
            onCreateTexture(call);
            return;
        }
        if (method == MethodKeys::Encodable) {
            onEncodable(call);
            return;
        }
        call.SendSuccessResponse(nullptr);
    };

    registrar.RegisterMethodChannel(MethodKeys::PluginKey,
                                    MethodCodecType::Standard,
                                    methods);
}

// ========== texture_registrar ==========

void ClientWrapperDemoPlugin::onCreateTexture(const MethodCall &call)
{
    m_textures.push_back(std::make_shared<flutter::TextureVariant>(flutter::PixelBufferTexture(
        [this](size_t, size_t) -> const FlutterDesktopPixelBuffer* {
            return new FlutterDesktopPixelBuffer {
                (const uint8_t *) m_textureImage.constBits(), // Image 150x150
                (size_t) 150,
                (size_t) 150
            };
        })));

    auto id = m_textureRegistrar->RegisterTexture(m_textures.back().get());

    call.SendSuccessResponse(id);
}

// ========== binary_messenger ==========

void ClientWrapperDemoPlugin::RegisterBinaryMessengerHandler()
{
    // Client Wrapper listen headler
    m_messenger->SetMessageHandler(
        MethodKeys::PluginKey,
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
    std::string value = std::to_string(static_cast<int>(orientation));
    std::string ouput = "{\"method\": \"ChangeDisplayOrientation\", \"args\": \""+value+"\"}";
    std::vector<uint8_t> message = {ouput.begin(), ouput.end()};

    m_messenger->Send(
        MethodKeys::PluginKey,
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

// ========== encodable_value ==========

void ClientWrapperDemoPlugin::onEncodable(const MethodCall &call)
{
    EncodableValue m_monostate = EncodableValue(); // null
    EncodableValue m_bool = EncodableValue(true);
    EncodableValue m_int32_t = EncodableValue((int32_t) 32);
    EncodableValue m_int64_t = EncodableValue((int32_t) 64);
    EncodableValue m_double = EncodableValue((double) 0.0);
    EncodableValue m_string = EncodableValue(std::string("Text"));
    EncodableValue m_vector_uint8_t = EncodableValue(std::vector<uint8_t> {1,2});
    EncodableValue m_vector_int32_t = EncodableValue(std::vector<int32_t> {1,2});
    EncodableValue m_vector_int64_t = EncodableValue(std::vector<int64_t> {1,2});
    EncodableValue m_vector_float = EncodableValue(std::vector<float> {1,2});
    EncodableValue m_vector_double = EncodableValue(std::vector<double> {1,2});
    EncodableValue m_encodable_map = EncodableValue(EncodableMap {
        {EncodableValue("key"), EncodableValue("value")},
    });

    call.ResponseSuccess(EncodableList {
        m_monostate,
        m_bool,
        m_int32_t,
        m_int64_t,
        m_double,
        m_string,
        m_vector_uint8_t,
        m_vector_int32_t,
        m_vector_int64_t,
        m_vector_float,
        m_vector_double,
        m_encodable_map,
    });
}
