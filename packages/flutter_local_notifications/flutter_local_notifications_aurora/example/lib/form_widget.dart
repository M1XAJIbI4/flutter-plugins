// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_button.dart';
import 'package:internal/theme/colors.dart';

import 'local_notifications_impl.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  String? title;
  String? body;

  final PluginImpl _pluginImpl = PluginImpl();

  void showNotification() {
    _formKey.currentState!.validate();
    if (title!.isNotEmpty && body!.isNotEmpty) {
      _pluginImpl.showNotification(title: title!, body: body!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TextFieldWidget('Title', (currentValue) => title = currentValue),
          _TextFieldWidget('Body', (currentValue) => body = currentValue),
          const SizedBox(height: 16.0),
          ListButton('Show notification', InternalColors.green, onPressed: showNotification),
        ],
      ),
    );
  }
}

class _TextFieldWidget extends StatelessWidget {
  final String enterText;
  final ValueChanged<dynamic> currentValue;

  const _TextFieldWidget(
    this.enterText,
    this.currentValue,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        onChanged: (value) => currentValue(value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please, enter value';
          }
          return null;
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: enterText,
        ),
      ),
    );
  }
}
