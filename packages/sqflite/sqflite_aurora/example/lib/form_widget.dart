// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

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
  String? enterName;
  int? enterCounter;
  double? enterDecimal;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    initialize();
    super.initState();
  }

  /// Obtaining data from shared preferences during initialization
  void initialize() async {
    await widget.pluginImpl.init();
  }

  /// Saving data to shared preferences
  void insertData() async {
    if (mounted) _formKey.currentState!.validate();
    if (enterName != null && enterCounter != null && enterDecimal != null) {
      await widget.pluginImpl.insert(enterName!, enterCounter!, enterDecimal!);
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
                'String ',
                (currentValue) => enterName = currentValue,
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
  String? updateName;
  int? updateCounter;
  double? updateDecimal;

  final _formKey = GlobalKey<FormState>();
  updateData() async {
    _formKey.currentState!.validate();
    if (updateId != null && updateName != null && updateCounter != null && updateDecimal != null) {
      await widget.pluginImpl.update(updateId!, updateName!, updateCounter!, updateDecimal!);
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
                (currentValue) => updateName = currentValue,
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
              ListButton('Update data', InternalColors.blue, onPressed: updateData),
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

  /// Clearing data from shared preferences
  void clear() async {
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
        return FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]+(\.[0-9]*|,[0-9]*)?$'));
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _streamController.stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _ResultDataContainerWidget(
              result: '[]',
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return _ResultDataContainerWidget(
              result: snapshot.data.toString(),
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
