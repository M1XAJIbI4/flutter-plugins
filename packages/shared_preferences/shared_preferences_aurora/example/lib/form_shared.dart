// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internal/list_button.dart';
import 'package:internal/theme/colors.dart';
import 'package:internal/theme/radius.dart';
import 'package:shared_preferences_aurora_example/shared_preferences_impl.dart';

class FormShared extends StatefulWidget {
  const FormShared({Key? key}) : super(key: key);

  @override
  State<FormShared> createState() => _FormSharedState();
}

class _FormSharedState extends State<FormShared> {
  final _formKey = GlobalKey<FormState>();
  bool? repeat;
  int? counter;
  double? decimal;
  String? action;
  List<String>? list;

  final PluginImpl _pluginImpl = PluginImpl();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  /// Obtaining data from shared preferences during initialization
  void initialize() async {
    await _pluginImpl.getData();
    setState(() {});
  }

  /// Saving data to shared preferences
  void onPressed() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      _pluginImpl.setBool(repeat!);
      _pluginImpl.setInt(counter!);
      _pluginImpl.setDouble(decimal!);
      _pluginImpl.setString(action!);
      _pluginImpl.setValueList(list!);
      _pluginImpl.getData();
      setState(() {});
    }
  }

  /// Clearing data from shared preferences
  void clear() async {
    if (_pluginImpl.readValues != null) {
      await _pluginImpl.clearAllData();
      setState(() {});
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
          Text(
            'Database status',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 16.0),
          ResultData(_pluginImpl),
          const SizedBox(height: 16.0),
          _TextFieldWidget(
            'Int',
            (currentValue) => counter = int.parse(currentValue),
            FieldType.intType,
          ),
          const SizedBox(height: 16.0),
          _TextFieldWidget(
            'Double',
            (currentValue) => decimal = double.parse(currentValue.toString().replaceAll(',', '.')),
            FieldType.doubleType,
          ),
          const SizedBox(height: 16.0),
          _TextFieldWidget(
            'String',
            (currentValue) => action = currentValue,
            FieldType.stringType,
          ),
          const SizedBox(height: 16.0),
          _TextFieldWidget(
            'List like: first, second, third',
            (currentValue) => list = currentValue.split(','),
            FieldType.stringType,
          ),
          const SizedBox(height: 16.0),
          _RadioButtonWidget((currentValue) => repeat = currentValue),
          const SizedBox(height: 16.0),
          ListButton('Save data', InternalColors.green, onPressed: onPressed),
          const SizedBox(height: 16.0),
          ListButton(
            'Clear data',
            _pluginImpl.readValues != null ? InternalColors.blue : InternalColors.primary,
            onPressed: _pluginImpl.readValues != null ? clear : null,
          ),
        ],
      ),
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
    return TextFormField(
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

class ResultData extends StatelessWidget {
  final PluginImpl sharedPreferencesImpl;
  const ResultData(
    this.sharedPreferencesImpl, {
    super.key,
  });

  String _prettyPrintMap(Map<String, dynamic>? map) {
    if (map == null || map.isEmpty) return 'The data is empty';
    var jsonString = jsonEncode(map);
    var prettyString = JsonEncoder.withIndent('  ').convert(jsonDecode(jsonString));
    return prettyString;
  }

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
              _prettyPrintMap(sharedPreferencesImpl.readValues),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RadioButtonWidget extends StatefulWidget {
  final ValueChanged<bool> currentValue;
  const _RadioButtonWidget(
    this.currentValue,
  );

  @override
  State<_RadioButtonWidget> createState() => _RadioButtonWidgetState();
}

class _RadioButtonWidgetState extends State<_RadioButtonWidget> {
  BoolType _character = BoolType.trueEnum;

  @override
  void initState() {
    super.initState();
    widget.currentValue(_character.value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Choose value type "Bool"'),
        Row(
          children: <Widget>[
            Text(BoolType.trueEnum.value.toString()),
            Radio<BoolType>(
              value: BoolType.trueEnum,
              groupValue: _character,
              onChanged: (BoolType? value) {
                if (value != null) {
                  setState(() {
                    _character = value;
                    widget.currentValue(_character.value); // Update value
                  });
                }
              },
            ),
            const SizedBox(
              width: 16,
            ),
            Text(BoolType.falseEnum.value.toString()),
            Radio<BoolType>(
              value: BoolType.falseEnum,
              groupValue: _character,
              onChanged: (BoolType? value) {
                if (value != null) {
                  setState(() {
                    _character = value;
                    widget.currentValue(_character.value); // Update value
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

enum FieldType {
  intType,
  doubleType,
  stringType,
}

enum BoolType {
  trueEnum(true),
  falseEnum(false);

  const BoolType(this.value);
  final bool value;
}
