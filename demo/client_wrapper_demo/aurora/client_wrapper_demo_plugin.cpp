/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <client_wrapper_demo/client_wrapper_demo_plugin.h>

#include <flutter/texture_registrar.h>
#include <flutter/binary_messenger.h>

namespace MethodKeys {
  constexpr auto PluginKey = "client_wrapper_demo";

  constexpr auto CreateTexture = "createTexture";
  constexpr auto BinaryMessengerEnable = "binaryMessengerEnable";
  constexpr auto BinaryMessengerDisable = "binaryMessengerDisable";
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
        [this](const uint8_t* message, size_t message_size, flutter::BinaryReply reply) {
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
