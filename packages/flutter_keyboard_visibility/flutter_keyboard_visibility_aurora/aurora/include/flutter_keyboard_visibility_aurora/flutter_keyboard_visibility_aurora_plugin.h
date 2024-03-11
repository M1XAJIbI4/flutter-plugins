/*
 * SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#ifndef FLUTTER_PLUGIN_FLUTTER_KEYBOARD_VISIBILITY_AURORA_PLUGIN_H
#define FLUTTER_PLUGIN_FLUTTER_KEYBOARD_VISIBILITY_AURORA_PLUGIN_H

#include <flutter_keyboard_visibility_aurora/globals.h>

#include <flutter/plugin_registrar.h>
#include <flutter/method_channel.h>
#include <flutter/event_channel.h>
#include <flutter/encodable_value.h>
#include <flutter/standard_method_codec.h>
#include <flutter/event_stream_handler_functions.h>

typedef flutter::Plugin Plugin;
typedef flutter::PluginRegistrar PluginRegistrar;
typedef flutter::EncodableValue EncodableValue;
typedef flutter::MethodChannel<EncodableValue> MethodChannel;
typedef flutter::MethodCall<EncodableValue> MethodCall;
typedef flutter::MethodResult<EncodableValue> MethodResult;
typedef flutter::EventChannel<EncodableValue> EventChannel;
typedef flutter::EventSink<EncodableValue> EventSink;

class PLUGIN_EXPORT FlutterKeyboardVisibilityAuroraPlugin final : public flutter::Plugin
{
public:
    static void RegisterWithRegistrar(PluginRegistrar* registrar);

private:
    // Creates a plugin that communicates on the given channel.
    FlutterKeyboardVisibilityAuroraPlugin(
        std::unique_ptr<MethodChannel> methodChannel,
        std::unique_ptr<EventChannel> eventChannelVisibility,
        std::unique_ptr<EventChannel> evenChannelHeight
    );

    // Methods register handlers channels
    void RegisterMethodHandler();
    void RegisterStreamHandler();

    std::unique_ptr<MethodChannel> m_methodChannel;
    std::unique_ptr<EventChannel> m_eventChannelVisibility;
    std::unique_ptr<EventChannel> m_evenChannelHeight;

    bool m_stateEventChannelVisibility = false;
    bool m_stateEventChannelHeight = false;

    std::unique_ptr<EventSink> m_sinkVisibility;
    std::unique_ptr<EventSink> m_sinkHeight;
};

#endif /* FLUTTER_PLUGIN_FLUTTER_KEYBOARD_VISIBILITY_AURORA_PLUGIN_H */
