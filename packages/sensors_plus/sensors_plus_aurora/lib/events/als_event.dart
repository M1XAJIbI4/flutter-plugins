// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause

enum LightLevel { undefined, dark, twilight, light, bright, sunny }

class ALSEvent {
  ALSEvent(this.lightLevel);

  final LightLevel lightLevel;

  @override
  String toString() => '[ALSEvent (lightLevel: $lightLevel)]';
}
