// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

extension ExtCameraDescription on CameraDescription {
  /// Get [CameraController]
  Future<CameraController?> getCameraController() async {
    final cameraController = CameraController(
      this,
      ResolutionPreset.medium,
      enableAudio: true,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
    try {
      await cameraController.initialize();
      return cameraController;
    } on CameraException catch (e) {
      debugPrint(e.description);
      return null;
    }
  }

  /// Get Icon by direction
  IconData getIcon() {
    switch (lensDirection) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
    }
  }
}
