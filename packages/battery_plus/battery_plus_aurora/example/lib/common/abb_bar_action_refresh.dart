// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:battery_plus_aurora_example/common/theme/colors.dart';
import 'package:flutter/material.dart';

/// Button refresh for [AppBar]
class AppBarActionRefresh extends StatelessWidget {
  const AppBarActionRefresh({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 40,
        height: 40,
        child: ClipOval(
          child: Material(
            color: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.primary),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
