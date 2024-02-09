// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences_aurora_example/shared_preferences/shared_preferences_impl.dart';

import '../../common/theme/radius.dart';
import '../common/list_button.dart';
import '../common/theme/colors.dart';

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

  final SharedPreferencesImpl _sharedPreferencesImpl = SharedPreferencesImpl();

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

  void clear() async {
    await _sharedPreferencesImpl.clearAllData();
    setState(() {});
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    await _sharedPreferencesImpl.getData();
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
          Row(
            children: [
              ListButton('Save data', AppColors.primary, onPressed: onPressed),
              const SizedBox(width: 6.0),
              ListButton('Clear data', AppColors.coal, onPressed: clear)
            ],
          ),
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

enum FieldType {
  intType,
  doubleType,
  stringType,
}

class ResultData extends StatelessWidget {
  final SharedPreferencesImpl sharedPreferencesImpl;
  const ResultData(
    this.sharedPreferencesImpl, {
    super.key,
  });

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
              borderRadius: AppRadius.medium,
              color: AppColors.green,
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
  BoolType _character = BoolType.tr;

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
            Text(BoolType.tr.value.toString()),
            Radio<BoolType>(
              value: BoolType.tr,
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
            Text(BoolType.fal.value.toString()),
            Radio<BoolType>(
              value: BoolType.fal,
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

enum BoolType {
  tr(true),
  fal(false);

  const BoolType(this.value);
  final bool value;
}
