// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences_aurora_example/shared_preferences/shared_preferences_impl.dart';

import '../../common/theme/radius.dart';
import '../common/list_button.dart';
import '../common/theme/colors.dart';

part 'part_of/radio_button_widget.dart';
part 'part_of/result_data.dart';
part 'part_of/textfield_widget.dart';

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
  onPressed() {
    if (_formKey.currentState!.validate()) {
      FocusManager.instance.primaryFocus?.unfocus();
      _sharedPreferencesImpl.setBool(repeat!);
      _sharedPreferencesImpl.setInt(counter!);
      _sharedPreferencesImpl.setDouble(decimal!);
      _sharedPreferencesImpl.setString(action!);
      setState(() {
        _sharedPreferencesImpl.getData();
      });
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
          const SizedBox(height: 16),
          ListButton('Save data', AppColors.primary, onPressed: onPressed),
          const SizedBox(height: 16),
          ResultData(_sharedPreferencesImpl),
        ],
      ),
    );
  }
}
