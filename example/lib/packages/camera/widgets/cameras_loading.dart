// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example_packages/base/package/package.dart';
import 'package:flutter_example_packages/widgets/base/export.dart';
import 'package:flutter_example_packages/widgets/blocks/block_alert.dart';
import 'package:flutter_example_packages/widgets/blocks/block_info_package.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CamerasLoading extends AppStatefulWidget {
  const CamerasLoading({
    super.key,
    required this.package,
    required this.builder,
  });

  final Package package;
  final Widget Function(BuildContext context, List<CameraDescription> cameras)
      builder;

  @override
  State<CamerasLoading> createState() => _CamerasLoadingState();
}

class _CamerasLoadingState extends AppState<CamerasLoading> {
  List<CameraDescription>? _cameras;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Get list cameras
    try {
      availableCameras().then((cameras) {
        if (mounted) {
          setState(() {
            _cameras = cameras;
          });
        }
      }).catchError((e) {
        setState(() {
          _error = e.toString();
        });
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget buildWide(
    BuildContext context,
    MediaQueryData media,
    AppLocalizations l10n,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 0,
          child: Column(
            children: [
              BlockInfoPackage(
                widget.package,
              ),
            ],
          ),
        ),
        Visibility(
          visible: _cameras == null && _error == null,
          child: const Flexible(
            flex: 1,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        Visibility(
          visible: _cameras?.isEmpty ?? false || _error != null,
          child: Flexible(
            flex: 0,
            child: BlockAlert(_error ?? 'No camera found.'),
          ),
        ),
        if (_cameras?.isNotEmpty ?? false)
          Flexible(
            flex: 1,
            child: widget.builder.call(context, _cameras!),
          ),
      ],
    );
  }
}
