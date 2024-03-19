// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_button.dart';
import 'package:internal/theme/colors.dart';

import 'plugin_impl.dart';

/// Keys form demo
enum FormTypeKeys { insert, update }

/// Form focus input
class FormWidget extends StatefulWidget {
  const FormWidget({super.key, required this.impl, required this.type});

  final PluginImpl impl;
  final FormTypeKeys type;

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _errorUpdate = false;

  final TextEditingController _idEdit = TextEditingController();
  final TextEditingController _intEdit = TextEditingController();
  final TextEditingController _doubleEdit = TextEditingController();
  final TextEditingController _stringEdit = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Field ID
          if (widget.type == FormTypeKeys.update)
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _idEdit,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Specify "${ValueKeys.id.name.toUpperCase()}"',
                ),
                validator: (value) {
                  if (_errorUpdate) {
                    return '${ValueKeys.id.name.toUpperCase()} not found.';
                  }
                  if (int.tryParse(value ?? '') == null) {
                    return 'The parameter type must be "${ValueKeys.int.name}"';
                  }
                  return null;
                },
              ),
            ),

          /// Field ValueKeys.int
          TextFormField(
            controller: _intEdit,
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
            controller: _doubleEdit,
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

          /// Field ValueKeys.string
          TextFormField(
            controller: _stringEdit,
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

          /// Button submit
          ListButton(
            '${widget.type.name} data',
            InternalColors.green,
            onPressed: () async => setState(() async {
              // Clear error update
              _errorUpdate = false;
              // Validate all form
              if (_formKey.currentState?.validate() == true) {
                // Get values
                final ID = _idEdit.text;
                final valueInt = _intEdit.text;
                final valueDouble = _doubleEdit.text.replaceAll(',', '.');
                final valueString = _stringEdit.text;

                // Update database data
                if (widget.type == FormTypeKeys.insert) {
                  await widget.impl.insert(
                    valueInt: int.parse(valueInt),
                    valueDouble: double.parse(valueDouble),
                    valueString: valueString,
                  );
                }
                if (widget.type == FormTypeKeys.update) {
                  // Update with result
                  _errorUpdate = !await widget.impl.update(
                    id: int.parse(ID),
                    valueInt: int.parse(valueInt),
                    valueDouble: double.parse(valueDouble),
                    valueString: valueString,
                  );
                  // Validate after update
                  _formKey.currentState?.validate();
                }

                // If not error update clear form
                if (!_errorUpdate) {
                  // Clear form
                  _idEdit.clear();
                  _intEdit.clear();
                  _doubleEdit.clear();
                  _stringEdit.clear();

                  // Close keyboard
                  FocusScope.of(context).unfocus();
                }
              }
            }),
          ),
        ],
      ),
    );
  }
}
