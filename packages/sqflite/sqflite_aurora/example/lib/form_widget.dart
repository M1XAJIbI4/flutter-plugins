// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internal/list_button.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/radius.dart';

import 'sqflite_impl.dart';

class FormInsertWidget extends StatefulWidget {
  const FormInsertWidget({Key? key}) : super(key: key);

  @override
  State<FormInsertWidget> createState() => FormInsertWidgetState();
}

class FormInsertWidgetState extends State<FormInsertWidget> {
  String? enterName;
  int? enterCounter;
  double? enterDecimal;
  int? deleteId;

  final PluginImpl _pluginImpl = PluginImpl();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  /// Obtaining data from shared preferences during initialization
  void initialize() async {
    await _pluginImpl.init();
  }

  /// Saving data to shared preferences
  void insertData() async {
    await _pluginImpl.insert(
      enterName!,
      enterCounter!,
      enterDecimal!,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              ResultData(_pluginImpl),
              _TextFieldWidget(
                'Name (TEXT)',
                (currentValue) => enterName = currentValue,
                FieldType.stringType,
              ),
              _TextFieldWidget(
                'Value (Integer)',
                (currentValue) => enterCounter = int.parse(currentValue),
                FieldType.intType,
              ),
              _TextFieldWidget(
                'Value (DOUBLE)',
                (currentValue) => enterDecimal = double.parse(currentValue),
                FieldType.doubleType,
              ),
              ListButton('Save data', InternalColors.blue, onPressed: insertData),
              const SizedBox(height: 6.0),
            ],
          ),
        ),
      ],
    );
  }
}

class FormUpdateWidget extends StatefulWidget {
  const FormUpdateWidget({Key? key}) : super(key: key);

  @override
  State<FormUpdateWidget> createState() => _FormUpdateWidgetState();
}

class _FormUpdateWidgetState extends State<FormUpdateWidget> {
  int? updateId;
  String? updateName;
  int? updateCounter;
  double? updateDecimal;

  final PluginImpl _pluginImpl = PluginImpl();

  updateData() async {
    await _pluginImpl.update(
      updateId!,
      updateName!,
      updateCounter!,
      updateDecimal!,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TextFieldWidget(
                'ID',
                (currentValue) => updateId = int.parse(currentValue),
                FieldType.intType,
              ),
              _TextFieldWidget(
                'Enter String value',
                (currentValue) => updateName = currentValue,
                FieldType.stringType,
              ),
              _TextFieldWidget(
                'Enter int value',
                (currentValue) => updateCounter = int.parse(currentValue),
                FieldType.intType,
              ),
              _TextFieldWidget(
                'Enter double value',
                (currentValue) => updateDecimal = double.parse(currentValue),
                FieldType.doubleType,
              ),
              ListButton('Update data', InternalColors.blue, onPressed: updateData),
              const SizedBox(height: 6.0),
            ],
          ),
        ),
      ],
    );
  }
}

class FormDeleteWidget extends StatefulWidget {
  const FormDeleteWidget({Key? key}) : super(key: key);

  @override
  State<FormDeleteWidget> createState() => _FormDeleteWidgetState();
}

class _FormDeleteWidgetState extends State<FormDeleteWidget> {
  int? deleteId;

  final PluginImpl _pluginImpl = PluginImpl();

  /// Clearing data from shared preferences
  void clear() async {
    await _pluginImpl.delete(deleteId!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TextFieldWidget(
                'Enter int value',
                (currentValue) => deleteId = int.parse(currentValue),
                FieldType.intType,
              ),
              ListButton('Clear data', InternalColors.coal, onPressed: clear),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        onChanged: (value) {
          if (_validate(value)) currentValue(value);
        },
        validator: (value) {
          if (!_validate(value!)) return 'Please enter a valid value';
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
        return FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]+(\.[0-9]*)?$'));
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
        return double.tryParse(value) != null;
      case FieldType.stringType:
        return value.isNotEmpty;
      default:
        return false;
    }
  }
}

class ResultData extends StatelessWidget {
  final PluginImpl pluginImpl;
  const ResultData(
    this.pluginImpl, {
    super.key,
  });

  /// Convert to display readings in a text widget
  String listMapEntriesToString(List<Map<dynamic, dynamic>> listOfMaps) {
    return listOfMaps.map((map) => map.entries.map((entry) => '${entry.key}: ${entry.value}\n').join()).join();
  }

  @override
  Widget build(BuildContext context) {
    return pluginImpl.data.isNotEmpty
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
                const Text('Current Result: ', style: TextStyle(fontSize: 18)),
                Text(
                  listMapEntriesToString(pluginImpl.data),
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}

enum FieldType {
  intType,
  doubleType,
  stringType,
}
