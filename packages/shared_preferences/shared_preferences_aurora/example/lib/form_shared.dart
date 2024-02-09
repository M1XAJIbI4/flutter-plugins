// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
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

  final PluginImpl _sharedPreferencesImpl = PluginImpl();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  /// Obtaining data from shared preferences during initialization
  void initialize() async {
    await _sharedPreferencesImpl.getData();
    setState(() {});
  }

  /// Saving data to shared preferences
  void onPressed() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      _sharedPreferencesImpl.setBool(repeat!);
      _sharedPreferencesImpl.setInt(counter!);
      _sharedPreferencesImpl.setDouble(decimal!);
      _sharedPreferencesImpl.setString(action!);
      _sharedPreferencesImpl.getData();
      setState(() {});
    }
  }

  /// Clearing data from shared preferences
  void clear() async {
    await _sharedPreferencesImpl.clearAllData();
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
          _RadioButtonWidget((currentValue) => repeat = currentValue),
          _TextFieldWidget(
            'Enter int value',
            (currentValue) => counter = int.parse(currentValue),
            FieldType.intType,
          ),
          _TextFieldWidget(
            'Enter double value',
            (currentValue) => decimal = double.parse(currentValue),
            FieldType.doubleType,
          ),
          _TextFieldWidget(
            'Enter String value',
            (currentValue) => action = currentValue,
            FieldType.stringType,
          ),
          ListButton('Save data', InternalColors.blue, onPressed: onPressed),
          const SizedBox(height: 6.0),
          ListButton('Clear data', InternalColors.coal, onPressed: clear),
          const SizedBox(height: 6.0),
          ResultData(_sharedPreferencesImpl),
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
  final PluginImpl sharedPreferencesImpl;
  const ResultData(
    this.sharedPreferencesImpl, {
    super.key,
  });

  /// Convert to display readings in a text widget
  String mapEntriesToString(Map<String, dynamic> map) {
    return map.entries.map((entry) => '${entry.key}: ${entry.value}\n').join();
  }

  @override
  Widget build(BuildContext context) {
    return sharedPreferencesImpl.readValues != null
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
                  mapEntriesToString(sharedPreferencesImpl.readValues!),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
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
        const Text('Choose value type "bool"'),
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
