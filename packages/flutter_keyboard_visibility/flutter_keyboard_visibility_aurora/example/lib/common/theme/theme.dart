// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'colors.dart';
import 'radius.dart';

final theme = ThemeData.light();

/// Custom theme example
final appTheme = ThemeData(
  colorScheme: theme.colorScheme.copyWith(
    primary: AppColors.primary,
    secondary: AppColors.secondary,
  ),

  /// [AppBar]
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    titleTextStyle: TextStyle(
      fontSize: 20,
      color: Colors.white,
    ),
  ),

  /// [Card]
  cardTheme: CardTheme(
    color: AppColors.secondary,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.medium,
    ),
  ),

  /// [TextField]
  inputDecorationTheme: theme.inputDecorationTheme.copyWith(
    contentPadding: const EdgeInsets.symmetric(
      vertical: 14,
      horizontal: 16,
    ),
    border: const OutlineInputBorder(),
  ),
);
