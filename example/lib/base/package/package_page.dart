/*
 * Copyright (c) 2023. Open Mobile Platform LLC.
 * License: Proprietary.
 */
import 'package:flutter/material.dart';
import 'package:flutter_example_packages/base/package/package.dart';

class PackagePage extends Package {
  PackagePage({
    required super.key,
    required super.descEN,
    required super.descRU,
    required super.version,
    required super.isPlatformDependent,
    required this.page,
    required this.init,
  }) {
    init.call();
  }

  /// Package preview page
  final Widget Function() page;

  /// Init callback
  final void Function() init;
}
