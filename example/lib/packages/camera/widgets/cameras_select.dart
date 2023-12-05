// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example_packages/packages/camera/extension/export.dart';
import 'package:flutter_example_packages/theme/colors.dart';
import 'package:flutter_example_packages/widgets/base/export.dart';
import 'package:flutter_example_packages/widgets/texts/export.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CamerasSelect extends AppStatefulWidget {
  const CamerasSelect({
    super.key,
    required this.disable,
    required this.cameras,
    required this.onChange,
  });

  final bool disable;
  final List<CameraDescription> cameras;
  final void Function(CameraController controller) onChange;

  @override
  State<CamerasSelect> createState() => _CamerasSelectState();
}

class _CamerasSelectState extends AppState<CamerasSelect> {
  CameraController? _cameraController;

  Future<void> initCamera(CameraDescription? camera) async {
    if (camera != null) {
      if (_cameraController != null) {
        // Check and stop if need image stream
        if (_cameraController!.value.isStreamingImages) {
          await _cameraController!.stopImageStream();
        }
        // Check and stop if need video recording
        if (_cameraController!.value.isRecordingVideo) {
          await _cameraController!.stopVideoRecording();
        }
        // Change camera
        await _cameraController!.setDescription(camera);
      } else {
        _cameraController = await camera.getCameraController();
      }
      // Send signal about change camera
      if (mounted) {
        widget.onChange(_cameraController!);
      }
    }
  }

  @override
  Widget buildWide(
    BuildContext context,
    MediaQueryData media,
    AppLocalizations l10n,
  ) {
    return Row(
      children: [
        const TextTitleLarge('Cameras:'),
        const SizedBox(width: 8),
        for (final CameraDescription camera in widget.cameras)
          ClipOval(
            child: Material(
              child: IconButton(
                icon: Icon(
                  camera.getIcon(),
                  color: _cameraController?.description == camera
                      ? AppColors.secondary
                      : AppColors.primary,
                ),
                onPressed:
                    _cameraController?.description == camera || widget.disable
                        ? null
                        : () => initCamera(camera),
              ),
            ),
          ),
      ],
    );
  }
}
