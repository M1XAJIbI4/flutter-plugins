/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H
#define FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H

#include <flutter/plugin-interface.h>
#include <client_wrapper_demo/globals.h>
#include <client_wrapper_demo/helper.h>

#include <flutter/platform-methods.h>
#include <flutter/platform-events.h>
#include <flutter/platform-types.h>

#include <QImage>

typedef flutter::TextureVariant TextureVariant;
typedef flutter::TextureRegistrar TextureRegistrar;
typedef flutter::PixelBufferTexture PixelBufferTexture;
typedef flutter::BinaryMessenger BinaryMessenger;

class PLUGIN_EXPORT ClientWrapperDemoPlugin final : public PluginInterface
{
public:
    void RegisterWithRegistrar(PluginRegistrar &registrar) override;

private:
    // Common functions
    void RegisterMethods(PluginRegistrar &registrar);

    // Texure regisrter example
    TextureRegistrar* m_textureRegistrar;
    QImage m_textureImage = Helper::GetImage();
    std::vector<std::shared_ptr<TextureVariant>> m_textures;
    void onCreateTexture(const MethodCall &call);

    // Binary messenger example
    enum StateListenEvent
    {
        NOT_INIT,
        ENABLE,
        DISABLE
    };
    BinaryMessenger* m_messenger;
    StateListenEvent m_stateListenEvent = StateListenEvent::NOT_INIT;
    void RegisterBinaryMessengerHandler();
    void onBinaryMessengerListenSend(DisplayOrientation orientation);
    void onBinaryMessengerListenEnable();
    void onBinaryMessengerListenDisable();

};

#endif /* FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H */
