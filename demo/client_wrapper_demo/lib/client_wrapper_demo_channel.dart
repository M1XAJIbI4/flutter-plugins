// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'client_wrapper_demo_interface.dart';

// Platform plugin keys channels
const channelEvent = "client_wrapper_demo_event";
const channelMethods = "client_wrapper_demo_methods";
const channelMessageBinary = "client_wrapper_demo_binary";

// Platform channel plugin methods
enum Methods {
  createTexture,
  eventChannelEnable,
  eventChannelDisable,
  binaryMessengerEnable,
  binaryMessengerDisable,
  encodable,
}

/// An implementation of [ClientWrapperDemoPlatform] that uses method channels.
class MethodChannelClientWrapperDemo extends ClientWrapperDemoPlatform {
  /// The methods channel used to interact with the native platform.
  final eventChannel = const EventChannel(channelEvent);
  final methodsChannel = const MethodChannel(channelMethods);
  final methodsChannelBinary = const MethodChannel(channelMessageBinary);

  /// Create texture with default image
  /// Return texture ID
  @override
  Future<int?> createTexture() async {
    return await methodsChannel.invokeMethod<int?>(Methods.createTexture.name);
  }

  /// EncodableValue to transfer data from
  /// flutter platform channels to dart
  @override
  Future<dynamic> encodable(Map<String, dynamic> values) async {
    return await methodsChannel.invokeMethod<Object?>(
        Methods.encodable.name, values);
  }

  /// Scream screen orientation angle with EventChannel
  @override
  Stream<int?> listenEventChannel() {
    return eventChannel.receiveBroadcastStream().map((event) => event as int);
  }

  /// Scream screen orientation angle with BinaryMessage
  @override
  Stream<int?> eventBinaryMessage() {
    // Init controller for enable/disable event
    final streamController = StreamController<int?>(
      onPause: () => methodsChannelBinary
          .invokeMethod<Object?>(Methods.binaryMessengerDisable.name),
      onResume: () => methodsChannelBinary
          .invokeMethod<Object?>(Methods.binaryMessengerEnable.name),
      onCancel: () => methodsChannelBinary
          .invokeMethod<Object?>(Methods.binaryMessengerDisable.name),
      onListen: () => methodsChannelBinary
          .invokeMethod<Object?>(Methods.binaryMessengerEnable.name),
    );
    // Add listen handler
    const OptionalMethodChannel(channelMessageBinary, JSONMethodCodec())
        .setMethodCallHandler((MethodCall call) {
      if (call.method == 'ChangeDisplayOrientation') {
        streamController.add(int.parse(call.arguments));
      }
      return Future<void>.value();
    });
    // Return stream
    return streamController.stream;
  }
}
