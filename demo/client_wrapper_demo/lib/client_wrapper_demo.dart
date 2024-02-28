// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause

import 'client_wrapper_demo_interface.dart';

class ClientWrapperDemo {
  /// Create texture with default image
  /// Return texture ID
  Future<int?> createTexture() =>
      ClientWrapperDemoPlatform.instance.createTexture();

  Future<void> sendBinaryMessage() =>
      ClientWrapperDemoPlatform.instance.sendBinaryMessage();
}
