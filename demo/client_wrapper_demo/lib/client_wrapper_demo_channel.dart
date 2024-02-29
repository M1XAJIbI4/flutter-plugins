// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'client_wrapper_demo_interface.dart';

// Platform channel plugin key registration
const pluginKey = "client_wrapper_demo";

// Platform channel plugin methods
enum Methods {
  createTexture,
  binaryMessengerEnable,
  binaryMessengerDisable,
  encodable,
}

/// An implementation of [ClientWrapperDemoPlatform] that uses method channels.
class MethodChannelClientWrapperDemo extends ClientWrapperDemoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodsChannel = const MethodChannel(pluginKey);

  /// Create texture with default image
  /// Return texture ID
  @override
  Future<int?> createTexture() async {
    return await methodsChannel.invokeMethod<int?>(Methods.createTexture.name);
  }

  /// Scream screen orientation angle
  @override
  Stream<int?> eventBinaryMessage() {
    // Init controller for enable/disable event
    final streamController = StreamController<int?>(
      onPause: () => methodsChannel
          .invokeMethod<Object?>(Methods.binaryMessengerDisable.name),
      onResume: () => methodsChannel
          .invokeMethod<Object?>(Methods.binaryMessengerEnable.name),
      onCancel: () => methodsChannel
          .invokeMethod<Object?>(Methods.binaryMessengerDisable.name),
      onListen: () => methodsChannel
          .invokeMethod<Object?>(Methods.binaryMessengerEnable.name),
    );
    // Add listen handler
    const OptionalMethodChannel(pluginKey, JSONMethodCodec())
        .setMethodCallHandler((MethodCall call) {
      if (call.method == 'ChangeDisplayOrientation') {
        streamController.add(int.parse(call.arguments));
      }
      return Future<void>.value();
    });
    // Return stream
    return streamController.stream;
  }

  /// EncodableValue to transfer data from
  /// flutter platform channels to dart
  @override
  Future<dynamic> encodable() async {
    return await methodsChannel.invokeMethod<Object?>(Methods.encodable.name);
  }
}
