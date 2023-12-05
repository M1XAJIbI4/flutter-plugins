// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart' as provider;
import 'package:path_provider/path_provider.dart';

import 'uint8_list.dart';

extension ExtCameraController on CameraController {
  /// Get photo
  Future<File?> takeImageFile() async {
    if (!value.isInitialized) {
      return null;
    }
    if (value.isTakingPicture) {
      return null;
    }
    try {
      // Get image
      final picture = await takePicture();
      // Get bytes
      final bytes = await picture.readAsBytes();
      // Get path
      final directory = await provider.getExternalStorageDirectories(
          type: StorageDirectory.pictures);
      // Save to file
      final file = await bytes.writeToFile(directory![0], picture);
      // Return saved file
      return file;
    } on CameraException catch (e) {
      debugPrint(e.description);
      return null;
    }
  }
}
