/*
 * Copyright (c) 2023. Open Mobile Platform LLC.
 * License: Proprietary.
 */
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

abstract class AppStatelessWidget extends StatelessWidget {
  const AppStatelessWidget({super.key});

  Widget buildWide(
    BuildContext context,
    MediaQueryData media,
    AppLocalizations l10n,
  );

  void onPostFrameCallback() {}

  @override
  Widget build(BuildContext context) => buildWide(
        context,
        MediaQuery.of(context),
        AppLocalizations.of(context)!,
      );
}
