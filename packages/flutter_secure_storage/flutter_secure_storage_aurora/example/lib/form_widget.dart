// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_button.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/radius.dart';

import 'secure_storage_impl.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({Key? key}) : super(key: key);

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  String? password;
  String? key;
  String? value;

  String? getPassword;
  String? getKey;
  String? resultValue;
  final PluginImpl _pluginImpl = PluginImpl();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  /// Obtaining data from shared preferences during initialization
  void initialize() async {}

  void saveValue() {
    _formKey.currentState!.validate();
    if (password != null && key != null && value != null) {
      _pluginImpl.write(key: key!, value: value!, password: password!);
    }
  }

  void readValue() async {
    _formKey.currentState!.validate();
    await _pluginImpl.read(key: getKey!, password: getPassword!);
    resultValue = _pluginImpl.readValue;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const Text('Save value'),
          const SizedBox(height: 8.0),
          _TextFieldWidget('Password', (currentValue) => password = currentValue),
          _TextFieldWidget('Key', (currentValue) => key = currentValue),
          _TextFieldWidget('Value', (currentValue) => value = currentValue),
          const SizedBox(height: 6.0),
          ListButton('Save value', InternalColors.blue, onPressed: saveValue),
          const SizedBox(height: 10.0),
          const Text('Get value'),
          const SizedBox(height: 8.0),
          _TextFieldWidget('Password', (currentValue) => getPassword = currentValue),
          _TextFieldWidget('Key', (currentValue) => getKey = currentValue),
          const SizedBox(height: 6.0),
          ListButton('Get data', InternalColors.coal, onPressed: readValue),
          const SizedBox(height: 10.0),
          ResultData(resultValue),
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
      padding: const EdgeInsets.only(bottom: 10),
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

class ResultData extends StatelessWidget {
  final String? resultValue;
  const ResultData(
    this.resultValue, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return resultValue != null
        ? Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: InternalRadius.large,
              color: InternalColors.green,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Current Result: $resultValue',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
