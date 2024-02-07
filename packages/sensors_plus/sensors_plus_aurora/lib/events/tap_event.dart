// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
enum TapDirection {
  undefined,
  x,
  y,
  z,
  xPos,
  yPos,
  zPos,
  xNeg,
  yNeg,
  zNeg,
  xBoth,
  yBoth,
  zBoth,
}

class TapEvent {
  TapEvent(this.tapDirection, this.isDoubleTap);

  final TapDirection tapDirection;

  final bool isDoubleTap;

  @override
  String toString() =>
      '[TapEvent (tapDirection: $tapDirection, isDoubleTap: $isDoubleTap)]';
}
