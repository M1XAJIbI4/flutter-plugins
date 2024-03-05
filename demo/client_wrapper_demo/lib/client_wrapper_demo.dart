// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause

import 'client_wrapper_demo_interface.dart';

class ClientWrapperDemo {
  /// Create texture with default image
  /// Return texture ID
  Future<int?> createTexture() =>
      ClientWrapperDemoPlatform.instance.createTexture();

  /// EncodableValue to transfer data from
  /// flutter platform channels to dart
  Future<dynamic> encodable(Map<String, dynamic> values) =>
      ClientWrapperDemoPlatform.instance.encodable(values);

  /// Scream screen orientation angle with EventChannel
  Stream<int?> listenEventChannel() =>
      ClientWrapperDemoPlatform.instance.listenEventChannel();

  /// Scream screen orientation angle with BinaryMessage
  Stream<int?> eventBinaryMessage() =>
      ClientWrapperDemoPlatform.instance.eventBinaryMessage();
}
