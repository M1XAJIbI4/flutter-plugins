/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <client_wrapper_demo/client_wrapper_demo_plugin.h>
#include <flutter/texture_registrar.h>
#include <flutter/encodable_value.h>

namespace MethodKeys {
  constexpr auto PluginKey = "client_wrapper_demo";

  constexpr auto CreateTexture = "createTexture";
  constexpr auto BinaryMessenger = "binaryMessenger";
} // namespace Methods


void ClientWrapperDemoPlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{
    // Get texture registrar
    m_textureRegistrar = registrar.texture_registrar();

    // Get binary messenger
    m_messenger = registrar.messenger();

    // Init methods
    MethodRegister(registrar);
}

void ClientWrapperDemoPlugin::MethodRegister(PluginRegistrar &registrar)
{
    // Embedder register method
    auto methods = [this](const MethodCall &call) {
        const auto &method = call.GetMethod();
        if (method == MethodKeys::CreateTexture) {
            onCreateTexture(call);
            return;
        }
        if (method == MethodKeys::BinaryMessenger) {
            return;
        }
        MethodUnimplemented(call);
    };

    registrar.RegisterMethodChannel(MethodKeys::PluginKey,
                                    MethodCodecType::Standard,
                                    methods);

    // Client Wrapper listen headler
    m_messenger->SetMessageHandler(
        MethodKeys::PluginKey,
        [this](const uint8_t* message, size_t message_size, flutter::BinaryReply reply) {
            auto data = std::string(message, message + message_size);
            // Check and run function by name
            if (data.find(MethodKeys::BinaryMessenger) != std::string::npos) {
                onBinaryMessenger();
            }
        }
    );
}

void ClientWrapperDemoPlugin::MethodUnimplemented(const MethodCall &call)
{
    call.SendSuccessResponse(nullptr);
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

void ClientWrapperDemoPlugin::onBinaryMessenger()
{
    std::string value = "{\"method\": \"TextInput.show\", \"args\": \"MY EVENT\"}";
    std::vector<uint8_t> message = {value.begin(), value.end()};

    m_messenger->Send(
        MethodKeys::PluginKey,
        message.data(),
        message.size()
    );
}
