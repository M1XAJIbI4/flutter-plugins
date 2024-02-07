// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:internal/list_button.dart';
import 'package:internal/theme/colors.dart';

/// Form focus input
class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focus = FocusNode();
  final TextEditingController _controller = TextEditingController();

  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focus.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            focusNode: _focus,
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Click for focus',
            ),
            validator: (value) => null,
          ),
          const SizedBox(height: 16),
          ListButton(
            'Clear focus',
            InternalColors.green,
            onPressed: _hasFocus
                ? () async {
                    if (_formKey.currentState?.validate() == true) {
                      FocusScope.of(context).unfocus();
                      _controller.clear();
                    }
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
