// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:battery_plus_aurora_example/common/theme/radius.dart';
import 'package:flutter/material.dart';

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
  final String description;
  final Color color;
  final String? value;
  final double? widthData;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
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
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: widthData,
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: AppRadius.medium,
                  color: color,
                ),
                child: Text(
                  value ?? 'NULL',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
