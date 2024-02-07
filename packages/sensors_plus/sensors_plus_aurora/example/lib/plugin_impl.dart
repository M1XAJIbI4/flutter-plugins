// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sensors_plus_aurora/events/als_event.dart';
import 'package:sensors_plus_aurora/events/compass_event.dart';
import 'package:sensors_plus_aurora/events/orientation_event.dart';
import 'package:sensors_plus_aurora/events/proximity_event.dart';
import 'package:sensors_plus_aurora/events/rotation_event.dart';
import 'package:sensors_plus_aurora/events/tap_event.dart';
import 'package:sensors_plus_aurora/sensors_plus_aurora.dart';

/// Main features of the plugin sensors_plus
class PluginImpl {
  /// Method returning the key of orientation
  Stream<OrientationEvent>? orientation() {
    try {
      return orientationEvents;
    } catch (e) {
      return null;
    }
  }

  /// Method returning the key of accelerometer
  Stream<AccelerometerEvent>? accelerometer() {
    try {
      return accelerometerEventStream();
    } catch (e) {
      return null;
    }
  }

  /// Method returning the key of compass
  Stream<CompassEvent>? compass() {
    try {
      return compassEvents;
    } catch (e) {
      return null;
    }
  }

  /// Method returning the key of tap
  Stream<TapEvent>? tap() {
    try {
      return tapEvents;
    } catch (e) {
      return null;
    }
  }

  /// Method returning the key of als
  Stream<ALSEvent>? als() {
    try {
      return alsEvents;
    } catch (e) {
      return null;
    }
  }

  /// Method returning the key of proximity
  Stream<ProximityEvent>? proximity() {
    try {
      return proximityEvents;
    } catch (e) {
      return null;
    }
  }

  /// Method returning the key of rotation
  Stream<RotationEvent>? rotation() {
    try {
      return rotationEvents;
    } catch (e) {
      return null;
    }
  }

  /// Method returning the key of magnetometer
  Stream<MagnetometerEvent>? magnetometer() {
    try {
      return magnetometerEventStream();
    } catch (e) {
      return null;
    }
  }

  /// Method returning the key of gyroscope
  Stream<GyroscopeEvent>? gyroscope() {
    try {
      return gyroscopeEventStream();
    } catch (e) {
      return null;
    }
  }
}
