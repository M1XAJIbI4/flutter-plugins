// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example_packages/theme/radius.dart';
import 'package:flutter_example_packages/widgets/base/export.dart';
import 'package:flutter_example_packages/widgets/texts/export.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CameraBody extends AppStatefulWidget {
  const CameraBody({
    super.key,
    required this.loading,
    required this.controller,
    required this.photo,
  });

  final bool loading;
  final CameraController? controller;
  final File? photo;

  @override
  State<CameraBody> createState() => _CameraBodyState();
}

class _CameraBodyState extends AppState<CameraBody> {
  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }

  @override
  Widget buildWide(
    BuildContext context,
    MediaQueryData media,
    AppLocalizations l10n,
  ) {
    return ClipRRect(
      borderRadius: AppRadius.small,
      child: Container(
        color: Colors.black87,
        child: Stack(
          children: [
            if (widget.loading)
              Container(
                color: Colors.black87,
                child: const Center(
                  child: TextTitleLarge(
                    'Loading...',
                    color: Colors.white,
                  ),
                ),
              ),
            // Show info if not select camera
            if (!widget.loading &&
                widget.controller == null &&
                widget.photo == null)
              const Center(
                child: TextTitleLarge(
                  'Select camera',
                  color: Colors.white,
                ),
              ),

            // Show camera preview
            if (widget.controller != null &&
                widget.controller!.value.isInitialized &&
                widget.photo == null)
              Opacity(
                opacity: !widget.loading ? 1.0 : 0.0,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: widget.controller!.buildPreview(),
                ),
              ),

            // Show dot when recording is active
            if (!widget.loading &&
                (widget.controller?.value.isRecordingVideo ?? false) &&
                !(widget.controller?.value.isRecordingPaused ?? false))
              Padding(
                padding: const EdgeInsets.all(16),
                child: ClipOval(
                  child: Container(
                    color: Colors.red,
                    width: 16,
                    height: 16,
                  ),
                ),
              ),

            // Show take phone
            if (!widget.loading && widget.photo != null)
              Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: Image.file(
                  widget.photo!,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
