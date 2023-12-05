// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:camera_aurora/camera_aurora.dart';
import 'package:flutter/material.dart';
import 'package:flutter_example_packages/base/di/app_di.dart';
import 'package:flutter_example_packages/base/package/package.dart';
import 'package:flutter_example_packages/packages/camera/extension/export.dart';
import 'package:flutter_example_packages/packages/camera/widgets/camera_body.dart';
import 'package:flutter_example_packages/packages/camera/widgets/camera_control_panel.dart';
import 'package:flutter_example_packages/packages/camera/widgets/cameras_loading.dart';
import 'package:flutter_example_packages/packages/camera/widgets/cameras_select.dart';
import 'package:flutter_example_packages/theme/colors.dart';
import 'package:flutter_example_packages/widgets/base/export.dart';
import 'package:flutter_example_packages/widgets/layouts/block_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'model.dart';
import 'package.dart';

class CameraPage extends AppStatefulWidget {
  CameraPage({
    super.key,
  });

  final Package package = packageCamera;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends AppState<CameraPage> {
  CameraController? _cameraController;
  File? _photo;
  bool _loading = false;
  StreamSubscription<String?>? _cameraSearchQrSubscription;

  @override
  Widget buildWide(
    BuildContext context,
    MediaQueryData media,
    AppLocalizations l10n,
  ) {
    return BlockLayout<CameraModel>(
      model: getIt<CameraModel>(),
      title: widget.package.key,
      builder: (context, child, model) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: CamerasLoading(
            package: widget.package,
            builder: (context, cameras) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 0,
                          child: CamerasSelect(
                            disable: _loading,
                            cameras: cameras,
                            onChange: (controller) => setState(() {
                              _photo = null;
                              _cameraController = controller;
                            }),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Flexible(
                          flex: 1,
                          child: CameraBody(
                            loading: _loading,
                            controller: _cameraController,
                            photo: _photo,
                          ),
                        ),
                        CameraControlPanel(
                          isStartQr: _cameraSearchQrSubscription != null,
                          disable: _loading,
                          controller: _cameraController,
                          photo: _photo,
                          // Start search qr
                          onStartQr: () {
                            if (mounted) {
                              setState(() {
                                _loading = true;
                              });
                            }
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              if (mounted) {
                                setState(() {
                                  _loading = false;
                                  _cameraSearchQrSubscription =
                                      cameraSearchQr?.listen((text) {
                                    if (mounted && text.isNotEmpty) {
                                      setState(() {
                                        _loading = true;
                                      });
                                      Future.delayed(
                                          const Duration(milliseconds: 200),
                                          () {
                                        if (mounted) {
                                          setState(() {
                                            _cameraSearchQrSubscription
                                                ?.cancel();
                                            _cameraSearchQrSubscription = null;
                                            _loading = false;

                                            showMessage("Read QR: $text",
                                                Colors.greenAccent);
                                          });
                                        }
                                      });
                                    }
                                  });
                                });
                              }
                            });
                          },
                          // Stop search qr
                          onStopQr: () {
                            if (mounted) {
                              setState(() {
                                _loading = true;
                              });
                            }
                            Future.delayed(const Duration(milliseconds: 200),
                                () {
                              if (mounted) {
                                setState(() {
                                  _cameraSearchQrSubscription?.cancel();
                                  _cameraSearchQrSubscription = null;
                                  _loading = false;
                                });
                              }
                            });
                          },
                          // Take photo and save to file (custom extension)
                          onTakePhoto: () => setState(() {
                            _loading = true;
                            _cameraController?.takeImageFile().then((photo) {
                              if (mounted) {
                                if (photo != null) {
                                  showMessage("File save to: ${photo.path}",
                                      AppColors.secondary);
                                } else {
                                  showMessage(
                                      "Error save file", Colors.redAccent);
                                }
                                setState(() {
                                  _loading = false;
                                  _photo = photo;
                                });
                              }
                            });
                          }),
                          // Clear photo
                          onClearPhoto: () {
                            if (mounted) {
                              setState(() {
                                _photo = null;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showMessage(String text, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }
}
