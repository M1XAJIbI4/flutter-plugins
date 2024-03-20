// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';

import 'theme/radius.dart';

/// Common layout-widget for list work with [ListItemData]
class ListItem extends StatelessWidget {
  const ListItem(
    this.title,
    this.description,
    this.color,
    this.value, {
    super.key,
    this.widthData,
  });

  final String title;
  final String? description;
  final Color color;
  final dynamic value;
  final double? widthData;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: widthData == null
            ? Column(
                children: [
                  _dataInfo(),
                  const SizedBox(height: 14),
                  _dataValue(),
                ],
              )
            : IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: _dataInfo(),
                    ),
                    const SizedBox(width: 16),
                    _dataValue()
                  ],
                ),
              ),
      ),
    );
  }

  Widget _dataInfo() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (description != null && description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                description!,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _dataValue() {
    return Container(
      width: widthData,
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: InternalRadius.medium,
        color: color,
      ),
      child: value is Widget
          ? value
          : Text(
              value == null ? 'NULL' : value.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}
