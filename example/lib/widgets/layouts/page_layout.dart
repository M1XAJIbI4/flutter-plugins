/*
 * Copyright (c) 2023. Open Mobile Platform LLC.
 * License: Proprietary.
 */
import 'package:flutter/material.dart';

class PageLayout extends StatefulWidget {
  const PageLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<PageLayout> createState() => _PageLayoutState();
}

class _PageLayoutState extends State<PageLayout> {
  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      child: Builder(
        builder: (context) {
          return widget.child;
        },
      ),
    );
  }
}
