// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_button.dart';
import 'package:internal/theme/colors.dart';

import 'plugin_impl.dart';

/// Form focus input
class FormWidget extends StatefulWidget {
  const FormWidget({super.key, required this.impl});

  final PluginImpl impl;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> _formItems = [
    {'label': 'Title', 'controller': TextEditingController()},
    {'label': 'Body', 'controller': TextEditingController()},
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Fields
          for (final item in _formItems)
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: item['controller'],
                decoration: InputDecoration(
                  labelText: item['label'],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'The parameter "${item['label']}" not must be empty.';
                  }
                  if (value.length > 50) {
                    return 'The parameter "${item['label']}" max length 10 symbols.';
                  }
                  return null;
                },
              ),
            ),

          /// Button submit
          ListButton(
            'Show notification',
            InternalColors.green,
            onPressed: () async => setState(() async {
              if (_formKey.currentState?.validate() == true) {
                // Save values
                await widget.impl.showNotification(
                  title: _formItems[0]['controller'].text,
                  body: _formItems[1]['controller'].text,
                );
                // Clear form
                for (final item in _formItems) {
                  item['controller'].clear();
                }
                // Close keyboard
                FocusScope.of(context).unfocus();
              }
            }),
          ),
        ],
      ),
    );
  }
}
