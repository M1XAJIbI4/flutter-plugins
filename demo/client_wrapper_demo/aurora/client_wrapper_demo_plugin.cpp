/*
 * SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
 * SPDX-License-Identifier: BSD-3-Clause
 */
#include <client_wrapper_demo/client_wrapper_demo_plugin.h>
#include <client_wrapper_demo/flutter_common.h>

namespace MethodKeys {
  constexpr auto ChannelName = "client_wrapper_demo";

  constexpr auto CreateTexture = "createTexture";
  constexpr auto BinaryMessengerEnable = "binaryMessengerEnable";
  constexpr auto BinaryMessengerDisable = "binaryMessengerDisable";
  constexpr auto Encodable = "encodable";
} // namespace Methods

void ClientWrapperDemoPlugin::RegisterWithRegistrar(PluginRegistrar* registrar)
{
    auto channel = std::make_unique<MethodChannel>(
        registrar->messenger(), MethodKeys::ChannelName,
        &flutter::StandardMethodCodec::GetInstance());

    auto* channel_pointer = channel.get();

    std::unique_ptr<ClientWrapperDemoPlugin> plugin(
        new ClientWrapperDemoPlugin(registrar, std::move(channel)));

    channel_pointer->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto& call, auto result) {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
}

ClientWrapperDemoPlugin::ClientWrapperDemoPlugin(
    PluginRegistrar* registrar,
    std::unique_ptr<MethodChannel> channel
) : m_channel(std::move(channel)),
    m_messenger(registrar->messenger()),
    m_textureRegistrar(registrar->texture_registrar())
{}

void ClientWrapperDemoPlugin::HandleMethodCall(
    const MethodCall& method_call, 
    std::unique_ptr<MethodResult> result
) {
    if (method_call.method_name().compare(MethodKeys::Encodable) == 0) {
        auto response = onEncodable(method_call);
        // @todo
        // result->Success(response);
    }
    else if (method_call.method_name().compare(MethodKeys::CreateTexture) == 0) {
        auto response = onCreateTexture(method_call);
        // @todo
        // result->Success(response);
    }
}

// ========== texture_registrar ==========

EncodableValue ClientWrapperDemoPlugin::onCreateTexture(const MethodCall &call)
{
    std::cout << "> Run 'onCreateTexture'" << std::endl;

    m_textures.push_back(std::make_shared<TextureVariant>(PixelBufferTexture(
        [this](size_t, size_t) -> const FlutterDesktopPixelBuffer* {
            return new FlutterDesktopPixelBuffer {
                (const uint8_t *) m_textureImage.constBits(), // Image 150x150
                (size_t) 150,
                (size_t) 150
            };
        })));

    return m_textureRegistrar->RegisterTexture(m_textures.back().get());
}

// ========== encodable_value ==========

EncodableValue ClientWrapperDemoPlugin::onEncodable(const MethodCall& method_call) 
{
    std::cout << "> Run 'onEncodable'" << std::endl;

    // Get arguments MethodCall
    if (TypeIs<EncodableMap>(*method_call.arguments())) {
        const EncodableMap params = GetValue<EncodableMap>(*method_call.arguments());

        std::cout << "> Encodable argument 'int': " << findInt(params, "int") << std::endl;
        std::cout << "> Encodable argument 'bool': " << findBool(params, "bool") << std::endl;
        std::cout << "> Encodable argument 'string': " << findString(params, "string") << std::endl;
    }

    // Send arguments MethodCall
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

    return EncodableList {
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
    };
}

// // ========== binary_messenger ==========

// void ClientWrapperDemoPlugin::RegisterBinaryMessengerHandler()
// {
//   // Client Wrapper listen headler
//   m_messenger->SetMessageHandler(
//       MethodKeys::PluginKey,
//       [this](const uint8_t* message, size_t message_size, flutter::BinaryReply) {
//           auto data = std::string(message, message + message_size);
//           // Check and run function by name
//           if (data.find(MethodKeys::BinaryMessengerEnable) != std::string::npos) {
//               onBinaryMessengerListenEnable();
//           }
//           else if (data.find(MethodKeys::BinaryMessengerDisable) != std::string::npos) {
//               onBinaryMessengerListenDisable();
//           }
//       }
//   );
// }

// void ClientWrapperDemoPlugin::onBinaryMessengerListenSend(DisplayOrientation orientation)
// {
//   std::string value = std::to_string(static_cast<int>(orientation));
//   std::string ouput = "{\"method\": \"ChangeDisplayOrientation\", \"args\": \""+value+"\"}";
//   std::vector<uint8_t> message = {ouput.begin(), ouput.end()};

//   m_messenger->Send(
//       MethodKeys::PluginKey,
//       message.data(),
//       message.size()
//   );
// }

// void ClientWrapperDemoPlugin::onBinaryMessengerListenEnable()
// {
//   // Add listen if not init
//   if (m_stateListenEvent == StateListenEvent::NOT_INIT) {
//       PlatformEvents::SubscribeOrientationChanged(
//           [this](DisplayOrientation orientation) {
//               if (m_stateListenEvent == StateListenEvent::ENABLE) {
//                   onBinaryMessengerListenSend(orientation);
//               }
//           });
//   }
//   // Enable listen
//   m_stateListenEvent = StateListenEvent::ENABLE;
//   // Send orientation after start
//   onBinaryMessengerListenSend(PlatformMethods::GetOrientation());
// }

// void ClientWrapperDemoPlugin::onBinaryMessengerListenDisable()
// {
//   // Disable listen
//   if (m_stateListenEvent == StateListenEvent::ENABLE) {
//       m_stateListenEvent = StateListenEvent::DISABLE;
//   }
// }

