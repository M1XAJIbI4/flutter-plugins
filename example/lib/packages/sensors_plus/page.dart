// SPDX-FileCopyrightText: 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_example_packages/base/di/app_di.dart';
import 'package:flutter_example_packages/base/package/package.dart';
import 'package:flutter_example_packages/widgets/base/export.dart';
import 'package:flutter_example_packages/widgets/blocks/block_info_package.dart';
import 'package:flutter_example_packages/widgets/blocks/block_item.dart';
import 'package:flutter_example_packages/widgets/layouts/block_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sensors_plus_aurora/events/als_event.dart';
import 'package:sensors_plus_aurora/events/compass_event.dart';
import 'package:sensors_plus_aurora/events/orientation_event.dart';
import 'package:sensors_plus_aurora/events/proximity_event.dart';
import 'package:sensors_plus_aurora/events/rotation_event.dart';
import 'package:sensors_plus_aurora/events/tap_event.dart';
import 'package:sensors_plus_aurora/sensors_plus_aurora.dart';

import 'model.dart';
import 'package.dart';

class SensorsPlusPage extends AppStatefulWidget {
  SensorsPlusPage({
    super.key,
  });

  final Package package = packageSensorsPlus;

  @override
  State<SensorsPlusPage> createState() => _SensorsPlusPageState();
}

class _SensorsPlusPageState extends AppState<SensorsPlusPage> {
  Stream<OrientationEvent>? _orientationEvents;
  Stream<AccelerometerEvent>? _accelerometerEvents;
  Stream<CompassEvent>? _compassEvents;
  Stream<TapEvent>? _tapEvents;
  Stream<ALSEvent>? _alsEvents;
  Stream<ProximityEvent>? _proximityEvents;
  Stream<RotationEvent>? _rotationEvents;
  Stream<MagnetometerEvent>? _magnetometerEvents;
  Stream<GyroscopeEvent>? _gyroscopeEvents;

  @override
  void initState() {
    super.initState();

    try {
      _orientationEvents = orientationEvents;
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _accelerometerEvents = accelerometerEvents;
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _compassEvents = compassEvents;
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _tapEvents = tapEvents;
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _alsEvents = alsEvents;
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _proximityEvents = proximityEvents;
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _rotationEvents = rotationEvents;
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _magnetometerEvents = magnetometerEvents;
    } catch (e) {
      debugPrint(e.toString());
    }
    try {
      _gyroscopeEvents = gyroscopeEvents;
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget buildWide(
    BuildContext context,
    MediaQueryData media,
    AppLocalizations l10n,
  ) {
    return BlockLayout<SensorsPlusModel>(
      model: getIt<SensorsPlusModel>(),
      title: widget.package.key,
      builder: (context, child, model) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BlockInfoPackage(widget.package),
                Visibility(
                  visible: _orientationEvents != null,
                  child: BlockItem(
                    isShowProgress: false,
                    title: l10n.sensorsPlusTitleOrientation,
                    desc: l10n.sensorsPlusSubtitle('orientationsensor'),
                    stream: _orientationEvents,
                    builder: (value) => value == null
                        ? l10n.sensorsPlusNotFound
                        : value.toString(),
                  ),
                ),
                Visibility(
                  visible: _accelerometerEvents != null,
                  child: BlockItem(
                    isShowProgress: false,
                    title: l10n.sensorsPlusTitleAccelerometer,
                    desc: l10n.sensorsPlusSubtitle('accelerometersensor'),
                    stream: _accelerometerEvents,
                    builder: (value) => value == null
                        ? l10n.sensorsPlusNotFound
                        : AccelerometerEvent(
                            double.parse(value.x.toStringAsFixed(6)),
                            double.parse(value.y.toStringAsFixed(6)),
                            double.parse(value.z.toStringAsFixed(6)),
                          ).toString(),
                  ),
                ),
                Visibility(
                  visible: _compassEvents != null,
                  child: BlockItem(
                    isShowProgress: false,
                    title: l10n.sensorsPlusTitleCompass,
                    desc: l10n.sensorsPlusSubtitle('compasssensor'),
                    stream: _compassEvents,
                    builder: (value) => value == null
                        ? l10n.sensorsPlusNotFound
                        : value.toString(),
                  ),
                ),
                Visibility(
                  visible: _tapEvents != null,
                  child: BlockItem(
                    isShowProgress: false,
                    title: l10n.sensorsPlusTitleTap,
                    desc: l10n.sensorsPlusSubtitle('tapsensor'),
                    stream: _tapEvents,
                    builder: (value) => value == null
                        ? l10n.sensorsPlusNotFound
                        : value.toString(),
                  ),
                ),
                Visibility(
                  visible: _alsEvents != null,
                  child: BlockItem(
                    isShowProgress: false,
                    title: l10n.sensorsPlusTitleALS,
                    desc: l10n.sensorsPlusSubtitle('alssensor'),
                    stream: _alsEvents,
                    builder: (value) => value == null
                        ? l10n.sensorsPlusNotFound
                        : value.toString(),
                  ),
                ),
                Visibility(
                  visible: _proximityEvents != null,
                  child: BlockItem(
                    isShowProgress: false,
                    title: l10n.sensorsPlusTitleProximity,
                    desc: l10n.sensorsPlusSubtitle('proximitysensor'),
                    stream: _proximityEvents,
                    builder: (value) => value == null
                        ? l10n.sensorsPlusNotFound
                        : value.toString(),
                  ),
                ),
                Visibility(
                  visible: _rotationEvents != null,
                  child: BlockItem(
                    isShowProgress: false,
                    title: l10n.sensorsPlusTitleRotation,
                    desc: l10n.sensorsPlusSubtitle('rotationsensor'),
                    stream: _rotationEvents,
                    builder: (value) => value == null
                        ? l10n.sensorsPlusNotFound
                        : RotationEvent(
                            double.parse(value.x.toStringAsFixed(6)),
                            double.parse(value.y.toStringAsFixed(6)),
                            double.parse(value.z.toStringAsFixed(6)),
                          ).toString(),
                  ),
                ),
                Visibility(
                  visible: _magnetometerEvents != null,
                  child: BlockItem(
                    isShowProgress: false,
                    title: l10n.sensorsPlusTitleMagnetometer,
                    desc: l10n.sensorsPlusSubtitle('magnetometersensor'),
                    stream: _magnetometerEvents,
                    builder: (value) => value == null
                        ? l10n.sensorsPlusNotFound
                        : MagnetometerEvent(
                            double.parse(value.x.toStringAsFixed(6)),
                            double.parse(value.y.toStringAsFixed(6)),
                            double.parse(value.z.toStringAsFixed(6)),
                          ).toString(),
                  ),
                ),
                Visibility(
                  visible: _gyroscopeEvents != null,
                  child: BlockItem(
                    isShowProgress: false,
                    title: l10n.sensorsPlusTitleGyroscope,
                    desc: l10n.sensorsPlusSubtitle('gyroscopesensor'),
                    stream: _gyroscopeEvents,
                    builder: (value) => value == null
                        ? l10n.sensorsPlusNotFound
                        : GyroscopeEvent(
                            double.parse(value.x.toStringAsFixed(6)),
                            double.parse(value.y.toStringAsFixed(6)),
                            double.parse(value.z.toStringAsFixed(6)),
                          ).toString(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
