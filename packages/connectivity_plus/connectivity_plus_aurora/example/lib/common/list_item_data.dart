// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';

import 'list_item.dart';

/// Common data-widget for list body plugin
class ListItemData<T> extends StatelessWidget {
  const ListItemData(
    this.title,
    this.description,
    this.color, {
    super.key,
    this.widthData,
    this.value,
    this.future,
    this.stream,
    this.builder,
  });

  final String title;
  final String description;
  final Color color;

  final double? widthData;
  final T? value;
  final Stream<T>? stream;
  final Future<T>? future;
  final Function(T?)? builder;

  AsyncWidgetBuilder<T?> get widgetBuilder => (BuildContext context, AsyncSnapshot<T?> snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('none');
          case ConnectionState.waiting:
          case ConnectionState.active:
          case ConnectionState.done:
            return ListItem(
              title,
              description,
              color,
              builder == null ? snapshot.data.toString() : builder!(snapshot.data),
              widthData: widthData,
            );
        }
      };

  @override
  Widget build(BuildContext context) {
    if (stream != null) {
      return StreamBuilder(
        stream: stream,
        builder: widgetBuilder,
      );
    }
    if (future != null) {
      return FutureBuilder(
        future: future,
        builder: widgetBuilder,
      );
    }
    return FutureBuilder(
      future: Future.value(value),
      builder: widgetBuilder,
    );
  }
}
