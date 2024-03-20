// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';

import 'list_item.dart';

/// Common data-widget for list body plugin
class ListItemData<T> extends StatelessWidget {
  const ListItemData(
    this.title,
    this.color, {
    super.key,
    this.loader,
    this.widthData,
    this.description,
    this.value,
    this.future,
    this.stream,
    this.builder,
    this.replace = true,
  });

  final String title;
  final Color color;

  final bool? loader;
  final bool replace;
  final double? widthData;
  final String? description;
  final T? value;
  final Stream<T>? stream;
  final Future<T>? future;
  final Function(T?)? builder;

  AsyncWidgetBuilder<T?> get widgetBuilder =>
      (BuildContext context, AsyncSnapshot<T?> snapshot) {
        final value = builder == null
            ? snapshot.data.toString()
            : builder!(snapshot.data);
        return ListItem(
          title,
          replace
              ? description
                  ?.replaceAll(RegExp(r"\s+"), ' ')
                  .replaceAll('\n', ' ')
                  .trim()
              : description,
          color,
          snapshot.connectionState == ConnectionState.waiting && loader == true
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Icon(
                    Icons.sync,
                    color: Colors.white,
                  ),
                )
              : value,
          widthData: widthData,
        );
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
