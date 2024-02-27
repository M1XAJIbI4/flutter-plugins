// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'client_wrapper_demo_interface.dart';

enum Methods {
  createTexture,
}

/// An implementation of [ClientWrapperDemoPlatform] that uses method channels.
class MethodChannelClientWrapperDemo extends ClientWrapperDemoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodsChannel = const MethodChannel('client_wrapper_demo');

  @override
  Future<int?> createTexture() async {
    return await methodsChannel.invokeMethod<int?>(Methods.createTexture.name);
  }
}
