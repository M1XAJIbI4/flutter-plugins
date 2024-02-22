// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internal/list_button.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/radius.dart';

import 'sqflite_impl.dart';

class FormInsertWidget extends StatefulWidget {
  final PluginImpl pluginImpl;

  const FormInsertWidget({required this.pluginImpl, Key? key}) : super(key: key);

  @override
  State<FormInsertWidget> createState() => FormInsertWidgetState();
}

class FormInsertWidgetState extends State<FormInsertWidget> {
  String? enterText;
  int? enterCounter;
  double? enterDecimal;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  /// Obtaining data from database during initialization
  void initialize() async {
    await widget.pluginImpl.init();
  }

  /// Delete spaces from our text
  String _removeSpaces(String input) {
    return input.replaceAll(RegExp(r'\s'), '');
  }

  /// Insert data to database by id
  void insertDataById() async {
    if (_formKey.currentState!.validate()) {
      if (enterText != null && enterCounter != null && enterDecimal != null) {
        await widget.pluginImpl.insert(_removeSpaces(enterText!), enterCounter!, enterDecimal!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TextFieldWidget(
                'String',
                (currentValue) => enterText = currentValue,
                FieldType.stringType,
              ),
              _TextFieldWidget(
                'Int',
                (currentValue) => enterCounter = int.parse(currentValue),
                FieldType.intType,
              ),
              _TextFieldWidget(
                'Double',
                (currentValue) => enterDecimal = double.parse(currentValue.toString().replaceAll(',', '.')),
                FieldType.doubleType,
              ),
              ListButton('Insert', InternalColors.green, onPressed: insertDataById),
              const SizedBox(height: 6.0),
            ],
          ),
        ),
      ],
    );
  }
}

class FormUpdateWidget extends StatefulWidget {
  final PluginImpl pluginImpl;
  const FormUpdateWidget({
    required this.pluginImpl,
    Key? key,
  }) : super(key: key);

  @override
  State<FormUpdateWidget> createState() => _FormUpdateWidgetState();
}

class _FormUpdateWidgetState extends State<FormUpdateWidget> {
  int? updateId;
  String? updateText;
  int? updateCounter;
  double? updateDecimal;

  final _formKey = GlobalKey<FormState>();

  /// Delete spaces from our text
  String _removeSpaces(String input) {
    return input.replaceAll(RegExp(r'\s'), '');
  }

  /// Update data from our database by id
  updateDataById() async {
    if (_formKey.currentState!.validate()) {
      if (updateId != null && updateText != null && updateCounter != null && updateDecimal != null) {
        await widget.pluginImpl.update(updateId!, _removeSpaces(updateText!), updateCounter!, updateDecimal!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TextFieldWidget(
                'Id',
                (currentValue) => updateId = int.parse(currentValue),
                FieldType.intType,
              ),
              _TextFieldWidget(
                'String',
                (currentValue) => updateText = currentValue,
                FieldType.stringType,
              ),
              _TextFieldWidget(
                'Int',
                (currentValue) => updateCounter = int.parse(currentValue),
                FieldType.intType,
              ),
              _TextFieldWidget(
                'Double',
                (currentValue) => updateDecimal = double.parse(currentValue.toString().replaceAll(',', '.')),
                FieldType.doubleType,
              ),
              ListButton('Update data', InternalColors.green, onPressed: updateDataById),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ],
    );
  }
}

class FormDeleteWidget extends StatefulWidget {
  final PluginImpl pluginImpl;
  const FormDeleteWidget({required this.pluginImpl, Key? key}) : super(key: key);

  @override
  State<FormDeleteWidget> createState() => _FormDeleteWidgetState();
}

class _FormDeleteWidgetState extends State<FormDeleteWidget> {
  int? deleteId;

  final _formKey = GlobalKey<FormState>();

  /// Remove data from database by id
  void removeById() async {
    _formKey.currentState!.validate();
    if (deleteId != null) {
      await widget.pluginImpl.delete(deleteId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TextFieldWidget(
                'Int',
                (currentValue) => deleteId = int.parse(currentValue),
                FieldType.intType,
              ),
              ListButton('Remove item', InternalColors.blue, onPressed: removeById),
            ],
          ),
        ),
      ],
    );
  }
}

class _TextFieldWidget extends StatelessWidget {
  final String label;
  final ValueChanged<dynamic> currentValue;
  final FieldType fieldType;

  const _TextFieldWidget(
    this.label,
    this.currentValue,
    this.fieldType,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        onChanged: (value) {
          if (_validate(value)) currentValue(value);
        },
        validator: (value) {
          if (!_validate(value!)) return 'Please enter a valid ${label.toUpperCase()} value';
          return null;
        },
        decoration: _buildInputDecoration(),
        keyboardType: _getKeyboardType(),
        inputFormatters: [_getInputFormatter()!],
      ),
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      hintText: label,
    );
  }

  /// Setting the keyboard type
  TextInputType? _getKeyboardType() {
    switch (fieldType) {
      case FieldType.intType:
        return TextInputType.number;
      case FieldType.doubleType:
        return TextInputType.number;
      case FieldType.stringType:
        return TextInputType.text;
      default:
        return TextInputType.text;
    }
  }

  /// Setting the input formatter
  TextInputFormatter? _getInputFormatter() {
    switch (fieldType) {
      case FieldType.intType:
        return FilteringTextInputFormatter.digitsOnly;
      case FieldType.doubleType:
        return FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]+(\.[0-9]*|,[0-9]*)?'));
      case FieldType.stringType:
        return FilteringTextInputFormatter.singleLineFormatter;
    }
  }

  /// Validating our text field
  bool _validate(String value) {
    switch (fieldType) {
      case FieldType.intType:
        return int.tryParse(value) != null;
      case FieldType.doubleType:
        return double.tryParse(value.toString().replaceAll(',', '.')) != null;
      case FieldType.stringType:
        return value.isNotEmpty;
      default:
        return false;
    }
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

  /// Converter for displaying beautiful json
  String _prettyPrintMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return 'The data is empty';
    var jsonString = jsonEncode(map);
    var prettyString = JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString));
    return prettyString;
  }

  /// The handler for our stream data
  String _convertStreamDataToMap(List<Map<String, dynamic>> list) {
    Map<String, dynamic> map = Map.fromIterable(list,
        key: (item) => item['id'].toString(),
        value: (item) => {
              'name': item['name'],
              'value': item['value'],
              'double': item['num'],
            });
    return _prettyPrintMap(map);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _ResultDataContainerWidget(
              result: 'The data is empty',
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _ResultDataContainerWidget(
              result: _convertStreamDataToMap(snapshot.data),
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
        borderRadius: InternalRadius.small,
        color: InternalColors.grey,
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              '$result',
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

enum FieldType {
  intType,
  doubleType,
  stringType,
}
