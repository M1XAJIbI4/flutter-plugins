// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/foundation.dart';
import 'package:sensors_plus_aurora/events/als_event.dart';
import 'package:sensors_plus_aurora/events/compass_event.dart';
import 'package:sensors_plus_aurora/events/orientation_event.dart';
import 'package:sensors_plus_aurora/events/proximity_event.dart';
import 'package:sensors_plus_aurora/events/rotation_event.dart';
import 'package:sensors_plus_aurora/events/tap_event.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

import 'sensors_plus_aurora_platform_interface.dart';

/// A broadcast stream of events from the Aurora OS device orientation.
Stream<OrientationEvent>? get orientationEvents {
  if (TargetPlatform.aurora == defaultTargetPlatform) {
    return SensorsPlusAurora().onChangeOrientation;
  }
  return null;
}

/// A broadcast stream of events from the Aurora OS device compass.
Stream<CompassEvent>? get compassEvents {
  if (TargetPlatform.aurora == defaultTargetPlatform) {
    return SensorsPlusAurora().onChangeCompass;
  }
  return null;
}

/// A broadcast stream of events from the Aurora OS device tap.
Stream<TapEvent>? get tapEvents {
  if (TargetPlatform.aurora == defaultTargetPlatform) {
    return SensorsPlusAurora().onChangeTap;
  }
  return null;
}

/// A broadcast stream of events from the Aurora OS device ALS.
Stream<ALSEvent>? get alsEvents {
  if (TargetPlatform.aurora == defaultTargetPlatform) {
    return SensorsPlusAurora().onChangeALS;
  }
  return null;
}

/// A broadcast stream of events from the Aurora OS device proximity.
Stream<ProximityEvent>? get proximityEvents {
  if (TargetPlatform.aurora == defaultTargetPlatform) {
    return SensorsPlusAurora().onChangeProximity;
  }
  return null;
}

/// A broadcast stream of events from the Aurora OS device rotation.
Stream<RotationEvent>? get rotationEvents {
  if (TargetPlatform.aurora == defaultTargetPlatform) {
    return SensorsPlusAurora().onChangeRotation;
  }
  return null;
}

class SensorsPlusAurora extends SensorsPlatform {
  static void registerWith() {
    SensorsPlatform.instance = SensorsPlusAurora();
  }

  Stream<OrientationEvent> get onChangeOrientation =>
      SensorsPlusAuroraPlatform.instance.onChangeOrientation();

  @override
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) => SensorsPlusAuroraPlatform.instance.onChangeAccelerometer();

  Stream<CompassEvent> get onChangeCompass =>
      SensorsPlusAuroraPlatform.instance.onChangeCompass();

  Stream<TapEvent> get onChangeTap =>
      SensorsPlusAuroraPlatform.instance.onChangeTap();

  Stream<ALSEvent> get onChangeALS =>
      SensorsPlusAuroraPlatform.instance.onChangeALS();

  Stream<ProximityEvent> get onChangeProximity =>
      SensorsPlusAuroraPlatform.instance.onChangeProximity();

  Stream<RotationEvent> get onChangeRotation =>
      SensorsPlusAuroraPlatform.instance.onChangeRotation();

  @override
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) => SensorsPlusAuroraPlatform.instance.onChangeMagnetometer();

  @override
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) => SensorsPlusAuroraPlatform.instance.onChangeGyroscope();
}
