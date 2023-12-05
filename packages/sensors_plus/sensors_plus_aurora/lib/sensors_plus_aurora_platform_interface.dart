// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sensors_plus_aurora/events/als_event.dart';
import 'package:sensors_plus_aurora/events/compass_event.dart';
import 'package:sensors_plus_aurora/events/orientation_event.dart';
import 'package:sensors_plus_aurora/events/proximity_event.dart';
import 'package:sensors_plus_aurora/events/rotation_event.dart';
import 'package:sensors_plus_aurora/events/tap_event.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

import 'sensors_plus_aurora_method_channel.dart';

abstract class SensorsPlusAuroraPlatform extends PlatformInterface {
  /// Constructs a SensorsPlusAuroraPlatform.
  SensorsPlusAuroraPlatform() : super(token: _token);

  static final Object _token = Object();

  static SensorsPlusAuroraPlatform _instance = MethodChannelSensorsPlusAurora();

  /// The default instance of [SensorsPlusAuroraPlatform] to use.
  ///
  /// Defaults to [MethodChannelSensorsPlusAurora].
  static SensorsPlusAuroraPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SensorsPlusAuroraPlatform] when
  /// they register themselves.
  static set instance(SensorsPlusAuroraPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Stream<OrientationEvent> onChangeOrientation() {
    throw UnimplementedError('onChangeOrientation() has not been implemented.');
  }

  Stream<AccelerometerEvent> onChangeAccelerometer() {
    throw UnimplementedError(
        'onChangeAccelerometer() has not been implemented.');
  }

  Stream<CompassEvent> onChangeCompass() {
    throw UnimplementedError('onChangeCompass() has not been implemented.');
  }

  Stream<TapEvent> onChangeTap() {
    throw UnimplementedError('onChangeTap() has not been implemented.');
  }

  Stream<ALSEvent> onChangeALS() {
    throw UnimplementedError('onChangeALS() has not been implemented.');
  }

  Stream<ProximityEvent> onChangeProximity() {
    throw UnimplementedError('onChangeProximity() has not been implemented.');
  }

  Stream<RotationEvent> onChangeRotation() {
    throw UnimplementedError('onChangeRotation() has not been implemented.');
  }

  Stream<MagnetometerEvent> onChangeMagnetometer() {
    throw UnimplementedError(
        'onChangeMagnetometer() has not been implemented.');
  }

  Stream<GyroscopeEvent> onChangeGyroscope() {
    throw UnimplementedError('onChangeGyroscope() has not been implemented.');
  }
}
