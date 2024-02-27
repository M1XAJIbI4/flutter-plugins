/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <client_wrapper_demo/client_wrapper_demo_plugin.h>
#include <flutter/method-channel.h>
#include <flutter/platform-events.h>
#include <flutter/platform-methods.h>

#include <flutter/texture_registrar.h>

namespace MethodKeys {
  constexpr auto PluginKey = "client_wrapper_demo";

  constexpr auto CreateTexture = "createTexture";
} // namespace Methods


void ClientWrapperDemoPlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{
  // Get texture registrar
  m_textureRegistrar = registrar.texture_registrar();

  // Init methods
  MethodRegister(registrar);
}

void ClientWrapperDemoPlugin::MethodRegister(PluginRegistrar &registrar)
{
    auto methods = [this](const MethodCall &call) {
        const auto &method = call.GetMethod();
        if (method == MethodKeys::CreateTexture) {
            onCreateTexture(call);
            return;
        }
        MethodUnimplemented(call);
    };

    registrar.RegisterMethodChannel(MethodKeys::PluginKey,
                                    MethodCodecType::Standard,
                                    methods);
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

