// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:sensors_plus_aurora/events/als_event.dart';
import 'package:sensors_plus_aurora/events/compass_event.dart';
import 'package:sensors_plus_aurora/events/orientation_event.dart';
import 'package:sensors_plus_aurora/events/proximity_event.dart';
import 'package:sensors_plus_aurora/events/rotation_event.dart';
import 'package:sensors_plus_aurora/events/tap_event.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

import 'sensors_plus_aurora_platform_interface.dart';

/// An implementation of [SensorsPlusAuroraPlatform] that uses method channels.
class MethodChannelSensorsPlusAurora extends SensorsPlusAuroraPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sensors_plus_aurora');

  List<int> _loadData(dynamic data, String key) {
    if (data == null) {
      throw "Failed to load sensor '$key'";
    }

    return (data as List<Object?>).map((e) => int.parse(e.toString())).toList();
  }

  @override
  Stream<OrientationEvent> onChangeOrientation() async* {
    await for (final data
        in const EventChannel('sensors_plus_aurora_orientationsensor')
            .receiveBroadcastStream()) {
      if (data == null) {
        throw "Failed to load sensor 'orientationsensor'";
      }
      switch (data[0]) {
        case 1:
          yield OrientationEvent.topUp;
          break;
        case 2:
          yield OrientationEvent.topDown;
          break;
        case 3:
          yield OrientationEvent.leftUp;
          break;
        case 4:
          yield OrientationEvent.rightUp;
          break;
        case 5:
          yield OrientationEvent.faceUp;
          break;
        case 6:
          yield OrientationEvent.faceDown;
          break;
        default:
          yield OrientationEvent.undefined;
      }
    }
  }

  @override
  Stream<AccelerometerEvent> onChangeAccelerometer() async* {
    await for (final data
        in const EventChannel('sensors_plus_aurora_accelerometersensor')
            .receiveBroadcastStream()) {
      if (data == null) {
        throw "Failed to load sensor 'accelerometersensor'";
      }
      yield AccelerometerEvent(
        data[0],
        data[1],
        data[2],
      );
    }
  }

  @override
  Stream<CompassEvent> onChangeCompass() async* {
    await for (final data
        in const EventChannel('sensors_plus_aurora_compasssensor')
            .receiveBroadcastStream()) {
      if (data == null) {
        throw "Failed to load sensor 'compasssensor'";
      }
      yield CompassEvent(
        data[0],
        data[1],
      );
    }
  }

  @override
  Stream<TapEvent> onChangeTap() async* {
    await for (final data in const EventChannel('sensors_plus_aurora_tapsensor')
        .receiveBroadcastStream()) {
      if (data == null) {
        throw "Failed to load sensor 'tapsensor'";
      }
      yield TapEvent(
        TapDirection.values[data[0]],
        data[1],
      );
    }
  }

  @override
  Stream<ALSEvent> onChangeALS() async* {
    await for (final data in const EventChannel('sensors_plus_aurora_alssensor')
        .receiveBroadcastStream()) {
      if (data == null) {
        throw "Failed to load sensor 'alssensor'";
      }
      yield ALSEvent(
        LightLevel.values[data[0]],
      );
    }
  }

  @override
  Stream<ProximityEvent> onChangeProximity() async* {
    await for (final data
        in const EventChannel('sensors_plus_aurora_proximitysensor')
            .receiveBroadcastStream()) {
      if (data == null) {
        throw "Failed to load sensor 'proximitysensor'";
      }
      yield ProximityEvent(
        data[0],
      );
    }
  }

  @override
  Stream<RotationEvent> onChangeRotation() async* {
    await for (final data
        in const EventChannel('sensors_plus_aurora_rotationsensor')
            .receiveBroadcastStream()) {
      if (data == null) {
        throw "Failed to load sensor 'rotationsensor'";
      }
      yield RotationEvent(
        data[0],
        data[1],
        data[2],
      );
    }
  }

  @override
  Stream<MagnetometerEvent> onChangeMagnetometer() async* {
    await for (final data
        in const EventChannel('sensors_plus_aurora_magnetometersensor')
            .receiveBroadcastStream()) {
      if (data == null) {
        throw "Failed to load sensor 'magnetometersensor'";
      }
      yield MagnetometerEvent(
        data[0],
        data[1],
        data[2],
      );
    }
  }

  @override
  Stream<GyroscopeEvent> onChangeGyroscope() async* {
    await for (final data in const EventChannel('sensors_plus_aurora_gyroscope')
        .receiveBroadcastStream()) {
      if (data == null) {
        throw "Failed to load sensor 'gyroscopesensor'";
      }
      yield GyroscopeEvent(
        data[0],
        data[1],
        data[2],
      );
    }
  }
}
