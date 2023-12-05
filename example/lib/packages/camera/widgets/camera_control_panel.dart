// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example_packages/theme/colors.dart';
import 'package:flutter_example_packages/widgets/base/export.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CameraControlPanel extends AppStatefulWidget {
  const CameraControlPanel({
    super.key,
    required this.isStartQr,
    required this.disable,
    required this.controller,
    required this.photo,
    required this.onStartQr,
    required this.onStopQr,
    required this.onTakePhoto,
    required this.onClearPhoto,
  });

  final bool isStartQr;
  final bool disable;
  final CameraController? controller;
  final File? photo;
  final void Function() onStartQr;
  final void Function() onStopQr;
  final void Function() onTakePhoto;
  final void Function() onClearPhoto;

  @override
  State<CameraControlPanel> createState() => _CameraControlPanelState();
}

class _CameraControlPanelState extends AppState<CameraControlPanel> {
  @override
  Widget buildWide(
    BuildContext context,
    MediaQueryData media,
    AppLocalizations l10n,
  ) {
    final isPhoto = widget.photo != null;

    return Visibility(
      visible: widget.controller != null,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              ClipOval(
                child: Material(
                  child: IconButton(
                    icon: Icon(
                      widget.isStartQr
                          ? Icons.stop_circle_outlined
                          : Icons.qr_code_scanner,
                      color: AppColors.primary
                          .withOpacity(isPhoto || widget.disable ? 0.5 : 1),
                    ),
                    onPressed: isPhoto || widget.disable
                        ? null
                        : () {
                            if (widget.isStartQr) {
                              widget.onStopQr.call();
                            } else {
                              widget.onStartQr.call();
                            }
                          },
                  ),
                ),
              ),
              const Spacer(),
              ClipOval(
                child: Material(
                  child: IconButton(
                    icon: Icon(
                      isPhoto ? Icons.image_not_supported : Icons.photo_camera,
                      color: AppColors.primary.withOpacity(
                          widget.isStartQr || widget.disable ? 0.5 : 1),
                    ),
                    onPressed: widget.isStartQr || widget.disable
                        ? null
                        : () {
                            if (isPhoto) {
                              widget.onClearPhoto.call();
                            } else {
                              widget.onTakePhoto.call();
                            }
                          },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
