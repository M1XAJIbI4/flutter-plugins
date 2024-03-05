/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H
#define FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H

#include <iostream>

#include <client_wrapper_demo/globals.h>
#include <client_wrapper_demo/helper.h>

#include <flutter/plugin_registrar.h>
#include <flutter/method_channel.h>
#include <flutter/standard_message_codec.h>
#include <flutter/standard_method_codec.h>
#include <flutter/encodable_value.h>
#include <flutter/texture_registrar.h>
#include <flutter/binary_messenger.h>

#include <flutter/platform-types.h>
#include <flutter/platform-events.h>
#include <flutter/platform-methods.h>

// Flutter encodable
typedef flutter::EncodableValue EncodableValue;
typedef flutter::EncodableMap EncodableMap;
typedef flutter::EncodableList EncodableList;
// Flutter register
typedef flutter::Plugin Plugin;
typedef flutter::PluginRegistrar PluginRegistrar;
typedef flutter::MethodChannel<EncodableValue> MethodChannel;
typedef flutter::MethodCall<EncodableValue> MethodCall;
typedef flutter::MethodResult<EncodableValue> MethodResult;
// Flutter texture
typedef flutter::TextureVariant TextureVariant;
typedef flutter::TextureRegistrar TextureRegistrar;
typedef flutter::PixelBufferTexture PixelBufferTexture;
// Flutter messenger
typedef flutter::BinaryMessenger BinaryMessenger;

class PLUGIN_EXPORT ClientWrapperDemoPlugin final : public flutter::Plugin
{
public:
    static void RegisterWithRegistrar(PluginRegistrar* registrar);

    ClientWrapperDemoPlugin(
        PluginRegistrar* registrar, 
        std::unique_ptr<MethodChannel> channel
    );

    void HandleMethodCall(
        const MethodCall& method_call,
        std::unique_ptr<MethodResult> result
    );

private:
    // Raw BinaryMessenger example
    enum StateListenEvent
    {
        NOT_INIT,
        ENABLE,
        DISABLE
    };
    StateListenEvent m_stateListenEvent = StateListenEvent::NOT_INIT;
    
    void RegisterBinaryMessengerHandler();
    void onBinaryMessengerListenSend(DisplayOrientation orientation);
    void onBinaryMessengerListenEnable();
    void onBinaryMessengerListenDisable();

    // Methods
    EncodableValue onCreateTexture(const MethodCall &call);
    EncodableValue onEncodable(const MethodCall& method_call);

    std::unique_ptr<MethodChannel> m_channel;
    BinaryMessenger* m_messenger;
    TextureRegistrar* m_textureRegistrar;

    QImage m_textureImage = Helper::GetImage();
    std::vector<std::shared_ptr<TextureVariant>> m_textures;

};

#endif /* FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H */
