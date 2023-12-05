// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/widgets.dart';
import 'package:scoped_model/scoped_model.dart';

/// Model for [CameraPage]
class CameraModel extends Model {
  /// Get [ScopedModel]
  static CameraModel of(BuildContext context) =>
      ScopedModel.of<CameraModel>(context);
}
