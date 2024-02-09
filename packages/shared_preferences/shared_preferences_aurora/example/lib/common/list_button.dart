// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';

import 'theme/radius.dart';

/// Common button
class ListButton extends StatelessWidget {
  const ListButton(
    this.text,
    this.color, {
    super.key,
    this.onPressed,
  });

  final String text;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color,
            disabledBackgroundColor: Colors.black45,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.medium,
            ),
          ),
          onPressed: onPressed,
          child: Text(text.toUpperCase()),
        ),
      ),
    );
  }
}
