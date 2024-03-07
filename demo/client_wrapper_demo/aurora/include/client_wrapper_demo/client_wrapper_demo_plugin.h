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
#include <flutter/event_channel.h>
#include <flutter/encodable_value.h>
#include <flutter/texture_registrar.h>
#include <flutter/binary_messenger.h>
#include <flutter/standard_message_codec.h>
#include <flutter/standard_method_codec.h>
#include <flutter/event_stream_handler_functions.h>

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
// Flutter methods
typedef flutter::MethodChannel<EncodableValue> MethodChannel;
typedef flutter::MethodCall<EncodableValue> MethodCall;
typedef flutter::MethodResult<EncodableValue> MethodResult;
// Flutter events
typedef flutter::EventChannel<EncodableValue> EventChannel;
typedef flutter::EventSink<EncodableValue> EventSink;
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

private:
    // Creates a plugin that communicates on the given channel.
    ClientWrapperDemoPlugin(
        PluginRegistrar* registrar, 
        std::unique_ptr<MethodChannel> methodChannel,
        std::unique_ptr<EventChannel> eventChannel
    );

    // Methods register handlers channels
    void RegisterMethodHandler();
    void RegisterStreamHandler();
    void RegisterBinaryMessengerHandler();

    // Methods MethodCall
    EncodableValue onCreateTexture(const MethodCall &call);
    EncodableValue onEncodable(const MethodCall& method_call);

    // Methods EventChannel
    void onEventChannelSend(DisplayOrientation orientation);
    void onEventChannelEnable();
    void onEventChannelDisable();

    // Methods BinaryMessenger
    void onBinaryMessengerSend(DisplayOrientation orientation);
    void onBinaryMessengerEnable();
    void onBinaryMessengerDisable();

    std::unique_ptr<MethodChannel> m_methodChannel;
    std::unique_ptr<EventChannel> m_eventChannel;
    BinaryMessenger* m_messenger;
    TextureRegistrar* m_textureRegistrar;

    QImage m_textureImage = Helper::GetImage();
    std::unique_ptr<EventSink> m_sink;
    std::vector<std::shared_ptr<TextureVariant>> m_textures;
    bool m_stateEventChannel = false;
    bool m_stateBinaryMessenger = false;

};

#endif /* FLUTTER_PLUGIN_CLIENT_WRAPPER_DEMO_PLUGIN_H */
