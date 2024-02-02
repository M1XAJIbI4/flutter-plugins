// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../common/list_button.dart';
import '../common/theme/colors.dart';

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
    final localizations = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            focusNode: _focus,
            controller: _controller,
            decoration: InputDecoration(
              labelText: localizations.formInput,
            ),
            validator: (value) => null,
          ),
          const SizedBox(height: 16),
          ListButton(
            localizations.formButton,
            AppColors.green,
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
