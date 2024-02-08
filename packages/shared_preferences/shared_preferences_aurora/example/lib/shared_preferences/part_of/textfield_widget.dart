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
    TextInputFormatter? formatter;
    TextInputType? keyboardType;
    switch (fieldType) {
      case FieldType.intType:
        formatter = FilteringTextInputFormatter.digitsOnly;
        keyboardType = TextInputType.number;
        break;
      case FieldType.doubleType:
        formatter = FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]+(\.[0-9]*)?$'));
        keyboardType = TextInputType.number;
        break;
      case FieldType.stringType:
        formatter = FilteringTextInputFormatter.singleLineFormatter;
        keyboardType = TextInputType.text;
        break;
    }

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
        decoration: InputDecoration(
          hintText: label,
        ),
        keyboardType: keyboardType,
        inputFormatters: [formatter],
      ),
    );
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
