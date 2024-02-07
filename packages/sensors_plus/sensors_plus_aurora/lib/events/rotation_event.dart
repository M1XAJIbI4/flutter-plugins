// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
class RotationEvent {
  RotationEvent(this.x, this.y, this.z);

  final double x;
  final double y;
  final double z;

  @override
  String toString() => '[RotationEvent (x: $x, y: $y, z: $z)]';
}
