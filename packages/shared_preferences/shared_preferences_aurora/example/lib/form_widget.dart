// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:internal/list_button.dart';
import 'package:internal/list_item_data.dart';
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

  final TextEditingController _stringController = TextEditingController();
  final TextEditingController _intController = TextEditingController();
  final TextEditingController _doubleController = TextEditingController();

  bool _boolValue = true;
  bool _listValue1 = false;
  bool _listValue2 = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Field ValueKeys.string
          TextFormField(
            controller: _stringController,
            decoration: InputDecoration(
              labelText: 'Specify type "${ValueKeys.string.name}"',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'The parameter "${ValueKeys.string.name}" not must be empty.';
              }
              if (value.length > 10) {
                return 'The parameter "${ValueKeys.string.name}" max length 10 symbols.';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),

          /// Field ValueKeys.int
          TextFormField(
            controller: _intController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Specify type "${ValueKeys.int.name}"',
            ),
            validator: (value) {
              if (int.tryParse(value ?? '') == null) {
                return 'The parameter type must be "${ValueKeys.int.name}"';
              }
              return null;
            },
          ),
          const SizedBox(height: 16.0),

          /// Field ValueKeys.double
          TextFormField(
            controller: _doubleController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Specify type "${ValueKeys.double.name}"',
            ),
            validator: (value) {
              if (double.tryParse(value?.replaceAll(',', '.') ?? '') == null) {
                return 'The parameter type must be "${ValueKeys.double.name}"';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          /// Field ValueKeys.bool
          ListItemData(
            'Specify type "${ValueKeys.bool.name}"',
            'The value will be stored as a boolean.',
            InternalColors.blue,
            value: true,
            builder: (value) {
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    RadioListTile(
                      title: const Text('True'),
                      value: true,
                      groupValue: _boolValue,
                      onChanged: (bool? value) =>
                          setState(() => _boolValue = value ?? false),
                    ),
                    RadioListTile(
                      title: const Text('False'),
                      value: false,
                      groupValue: _boolValue,
                      onChanged: (bool? value) =>
                          setState(() => _boolValue = value ?? false),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          /// Field ValueKeys.list
          ListItemData(
            'Specify type "${ValueKeys.list.name}"',
            'The value will be stored as a string list.',
            InternalColors.blue,
            value: true,
            builder: (value) {
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Value 1'),
                      value: _listValue1,
                      onChanged: (bool? value) =>
                          setState(() => _listValue1 = value ?? false),
                    ),
                    CheckboxListTile(
                      title: const Text('Value 2'),
                      value: _listValue2,
                      onChanged: (bool? value) =>
                          setState(() => _listValue2 = value ?? false),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          /// Button submit
          ListButton(
            'Save data',
            InternalColors.green,
            onPressed: () async {
              if (_formKey.currentState?.validate() == true) {
                // Get values
                final valueInt = int.parse(_intController.text);
                final valueBool = _boolValue;
                final valueString = _stringController.text;
                final valueDouble = double.parse(
                  _doubleController.text.replaceAll(',', '.'),
                );
                final valueList = [
                  _listValue1 ? 'val1' : null,
                  _listValue2 ? 'val2' : null,
                ].whereNotNull().toList();

                // Save data
                await widget.impl.setValue(ValueKeys.int, valueInt);
                await widget.impl.setValue(ValueKeys.bool, valueBool);
                await widget.impl.setValue(ValueKeys.string, valueString);
                await widget.impl.setValue(ValueKeys.double, valueDouble);
                await widget.impl.setValue(ValueKeys.list, valueList);

                // Clear form
                setState(() {
                  _stringController.clear();
                  _intController.clear();
                  _doubleController.clear();
                  _boolValue = true;
                  _listValue1 = false;
                  _listValue2 = false;
                });

                FocusScope.of(context).unfocus();
              }
            },
          ),
        ],
      ),
    );
  }
}
