// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';

import 'theme/colors.dart';

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
              icon: const Icon(Icons.refresh, color: InternalColors.primary),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
