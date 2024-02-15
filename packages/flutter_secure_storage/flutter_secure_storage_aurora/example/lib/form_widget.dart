// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internal/list_button.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/radius.dart';

import 'secure_storage_impl.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({
    super.key,
    required this.pluginImpl,
  });

  final PluginImpl pluginImpl;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  String? password;
  String? key;
  String? value;

  void saveValue() async {
    _formKey.currentState!.validate();
    if (password != null && key != null && value != null) {
      await widget.pluginImpl.write(key: key!, value: value!, password: password!);
    }
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
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }
}

class FormGetWidget extends StatefulWidget {
  const FormGetWidget({
    super.key,
    required this.pluginImpl,
  });

  final PluginImpl pluginImpl;

  @override
  State<FormGetWidget> createState() => _FormGetWidgetState();
}

class _FormGetWidgetState extends State<FormGetWidget> {
  final _formKey = GlobalKey<FormState>();
  String? getPassword;
  String? getKey;

  void readValue() async {
    _formKey.currentState!.validate();
    await widget.pluginImpl.read(key: getKey!, password: getPassword!);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Get value'),
          const SizedBox(height: 16.0),
          _TextFieldWidget('Password', (currentValue) => getPassword = currentValue),
          _TextFieldWidget('Key', (currentValue) => getKey = currentValue),
          const SizedBox(height: 6.0),
          ListButton('Get data', InternalColors.coal, onPressed: readValue),
          const SizedBox(height: 16.0),
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

class ResultData extends StatefulWidget {
  ResultData({
    super.key,
    required this.pluginImpl,
  });

  final PluginImpl pluginImpl;
  @override
  _ResultDataState createState() => _ResultDataState();
}

class _ResultDataState extends State<ResultData> {
  late final StreamController _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = widget.pluginImpl.streamController;
  }

  @override
  void dispose() {
    // Cancel the subscription when not needed
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _ResultDataContainerWidget(
              result: 'No data',
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _ResultDataContainerWidget(
              result: snapshot.data,
            );
          }
        });
  }
}

class _ResultDataContainerWidget extends StatelessWidget {
  final String result;
  const _ResultDataContainerWidget({
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: InternalRadius.large,
        color: InternalColors.green,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              'Current Result: $result',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
