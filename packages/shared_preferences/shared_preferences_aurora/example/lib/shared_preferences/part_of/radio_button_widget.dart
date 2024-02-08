part of '../form_shared.dart';

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
