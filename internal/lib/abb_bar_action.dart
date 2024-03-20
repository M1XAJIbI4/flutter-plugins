// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';

import 'theme/colors.dart';

/// Button refresh for [AppBar]
class AppBarAction extends StatelessWidget {
  const AppBarAction({
    super.key,
    this.onPressed,
    this.icon = Icons.refresh,
  });

  final VoidCallback? onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 40,
        height: 40,
        child: ClipOval(
          child: Material(
            color: Colors.white,
            child: Opacity(
              opacity: onPressed == null ? 0.5 : 1,
              child: IconButton(
                icon: Icon(icon, color: InternalColors.primary),
                onPressed: onPressed,
              ),
            )
          ),
        ),
      ),
    );
  }
}
