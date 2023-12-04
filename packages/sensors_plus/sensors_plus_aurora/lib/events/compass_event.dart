// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause

class CompassEvent {
  CompassEvent(this.azimuth, this.calibrationLevel);

  final double azimuth;

  final double calibrationLevel;

  @override
  String toString() =>
      '[CompassEvent (azimuth: $azimuth, calibrationLevel: $calibrationLevel)]';
}
