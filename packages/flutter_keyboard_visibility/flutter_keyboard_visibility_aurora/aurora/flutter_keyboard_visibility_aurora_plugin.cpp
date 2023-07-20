#include <flutter_keyboard_visibility_aurora/flutter_keyboard_visibility_aurora_plugin.h>
#include <flutter/method-channel.h>
#include <flutter/platform-events.h>
#include <flutter/platform-methods.h>
#include <thread>

FlutterKeyboardVisibilityAuroraPlugin::FlutterKeyboardVisibilityAuroraPlugin()
{
  PlatformEvents::SubscribeKeyboardVisibilityChanged(
      [this](bool state)
      {
        if (this->m_sendEventVisibility)
        {
          EventChannel("flutter_keyboard_visibility_aurora_state", MethodCodecType::Standard)
              .SendEvent(state);
        }

        if (this->m_sendEventHeight)
        {
          EventChannel("flutter_keyboard_visibility_aurora_height", MethodCodecType::Standard)
              .SendEvent(PlatformMethods::GetKeyboardHeight());
        }
      });
}

void FlutterKeyboardVisibilityAuroraPlugin::RegisterWithRegistrar(PluginRegistrar &registrar)
{
  registrar.RegisterMethodChannel("flutter_keyboard_visibility_aurora",
                                  MethodCodecType::Standard,
                                  [this](const MethodCall &call)
                                  { this->onMethodCall(call); });

  registrar.RegisterEventChannel(
      "flutter_keyboard_visibility_aurora_state",
      MethodCodecType::Standard,
      [this](const Encodable &)
      {
        this->m_sendEventVisibility = true;
        return EventResponse();
      },
      [this](const Encodable &)
      {
        this->m_sendEventVisibility = false;
        return EventResponse();
      });

  registrar.RegisterEventChannel(
      "flutter_keyboard_visibility_aurora_height",
      MethodCodecType::Standard,
      [this](const Encodable &)
      {
        this->m_sendEventHeight = true;
        return EventResponse();
      },
      [this](const Encodable &)
      {
        this->m_sendEventHeight = false;
        return EventResponse();
      });
}

void FlutterKeyboardVisibilityAuroraPlugin::onMethodCall(const MethodCall &call)
{
  const auto &method = call.GetMethod();

  if (method == "getKeyboardHeight")
  {
    onGetKeyboardHeight(call);
    return;
  }

  unimplemented(call);
}

void FlutterKeyboardVisibilityAuroraPlugin::onGetKeyboardHeight(const MethodCall &call)
{
  call.SendSuccessResponse(PlatformMethods::GetKeyboardHeight());
}

void FlutterKeyboardVisibilityAuroraPlugin::unimplemented(const MethodCall &call)
{
  call.SendSuccessResponse(nullptr);
}
