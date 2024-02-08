part of '../form_shared.dart';

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
