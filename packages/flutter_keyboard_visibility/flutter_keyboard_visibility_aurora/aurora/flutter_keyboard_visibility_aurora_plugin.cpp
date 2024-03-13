/*
 * SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <flutter_keyboard_visibility_aurora/flutter_keyboard_visibility_aurora_plugin.h>
#include <flutter/platform-events.h>
#include <flutter/platform-methods.h>

namespace Channels {
    constexpr auto EventVisibility = "flutter_keyboard_visibility_aurora_state";
    constexpr auto EventHeight = "flutter_keyboard_visibility_aurora_height";
    constexpr auto Methods = "flutter_keyboard_visibility_aurora";
} // namespace Channels

namespace Methods {
    constexpr auto KeyboardHeight = "getKeyboardHeight";
} // namespace Methods

void FlutterKeyboardVisibilityAuroraPlugin::RegisterWithRegistrar(PluginRegistrar* registrar)
{
    // Create plugin
    std::unique_ptr<FlutterKeyboardVisibilityAuroraPlugin> plugin(new FlutterKeyboardVisibilityAuroraPlugin(
        std::move(std::make_unique<MethodChannel>(
        registrar->messenger(), Channels::Methods,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::EventVisibility,
        &flutter::StandardMethodCodec::GetInstance())),
        std::move(std::make_unique<EventChannel>(
        registrar->messenger(), Channels::EventHeight,
        &flutter::StandardMethodCodec::GetInstance()))
    ));

    // Register plugin
    registrar->AddPlugin(std::move(plugin));
}

FlutterKeyboardVisibilityAuroraPlugin::FlutterKeyboardVisibilityAuroraPlugin(
    std::unique_ptr<MethodChannel> methodChannel,
    std::unique_ptr<EventChannel> eventChannelVisibility,
    std::unique_ptr<EventChannel> evenChannelHeight
) : m_methodChannel(std::move(methodChannel)),
    m_eventChannelVisibility(std::move(eventChannelVisibility)),
    m_evenChannelHeight(std::move(evenChannelHeight))
{
    // Create MethodHandler
    RegisterMethodHandler();

    // Create StreamHandler
    RegisterStreamHandler();

    // Listen change state keyboard
    PlatformEvents::SubscribeKeyboardVisibilityChanged([&](bool state) {
      if (m_stateEventChannelVisibility) {
        m_sinkVisibility->Success(state);
      }
      if (m_stateEventChannelHeight) {
        m_sinkHeight->Success(PlatformMethods::GetKeyboardHeight());
      }
    });
}

void FlutterKeyboardVisibilityAuroraPlugin::RegisterMethodHandler()
{
    m_methodChannel->SetMethodCallHandler(
        [&](const MethodCall& call, std::unique_ptr<MethodResult> result) {
            if (call.method_name().compare(Methods::KeyboardHeight) == 0) {
                result->Success(PlatformMethods::GetKeyboardHeight());
            }
            else {
                result->Success();
            }
        });
}

void FlutterKeyboardVisibilityAuroraPlugin::RegisterStreamHandler()
{
    // Event Visibility
    auto handlerVisibility = std::make_unique<flutter::StreamHandlerFunctions<EncodableValue>>(
        [&](const EncodableValue*,
            std::unique_ptr<flutter::EventSink<EncodableValue>>&& events
        ) -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            m_sinkVisibility = std::move(events);
            m_stateEventChannelVisibility = true;
            return nullptr;
        },
        [&](const EncodableValue*) -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            m_stateEventChannelVisibility = false;
            return nullptr;
        }
    );
    m_eventChannelVisibility->SetStreamHandler(std::move(handlerVisibility));

    // Event Height
    auto handlerHeight = std::make_unique<flutter::StreamHandlerFunctions<EncodableValue>>(
        [&](const EncodableValue*,
            std::unique_ptr<flutter::EventSink<EncodableValue>>&& events
        ) -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            m_sinkHeight = std::move(events);
            m_stateEventChannelHeight = true;
            return nullptr;
        },
        [&](const EncodableValue*) -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            m_stateEventChannelHeight = false;
            return nullptr;
        }
    );
    m_evenChannelHeight->SetStreamHandler(std::move(handlerHeight));
}
