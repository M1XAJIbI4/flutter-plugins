// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter/material.dart';
import 'package:flutter_example_packages/widgets/base/export.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_example_packages/theme/colors.dart';

enum PlatformFilter {
  disable,
  dependent,
  independent,
  demo,
}

class HomeAppBar extends AppStatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({
    super.key,
    required this.onChangeFiltered,
  });

  final void Function(String, PlatformFilter) onChangeFiltered;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}

class _HomeAppBarState extends AppState<HomeAppBar> {
  String? _search;
  PlatformFilter _filter = PlatformFilter.disable;

  final _searchController = TextEditingController();
  final _searchFocus = FocusNode();

  @override
  Widget buildWide(
    BuildContext context,
    MediaQueryData media,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.primary,
      shape: const Border(bottom: BorderSide(width: 0)),
      leading: _search != null
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipOval(
                child: Material(
                  color: Colors.blueGrey,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: l10n.homeSearch,
                    onPressed: () {
                      setState(() {
                        _search = null;
                        widget.onChangeFiltered.call("", _filter);
                        _searchController.clear();
                      });
                    },
                  ),
                ),
              ),
            )
          : null,
      title: _search != null
          ? TextField(
              focusNode: _searchFocus,
              controller: _searchController,
              style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
                hintText: l10n.homeSearchTitle,
                hintStyle:
                    theme.textTheme.titleLarge?.copyWith(color: Colors.white54),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(0),
              ),
              onChanged: (value) {
                _search = value;
                widget.onChangeFiltered.call(value, _filter);
              },
            )
          : null,
      actions: [
        if (_search == null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 40,
              height: 40,
              child: ClipOval(
                child: Material(
                  color: Colors.blueGrey,
                  child: IconButton(
                    icon: const Icon(Icons.search),
                    tooltip: l10n.homeSearch,
                    onPressed: () {
                      setState(() {
                        _search = "";
                        _searchFocus.requestFocus();
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 40,
            height: 40,
            child: ClipOval(
              child: Material(
                color: () {
                  switch (_filter) {
                    case PlatformFilter.disable:
                      return Colors.blueGrey;
                    case PlatformFilter.dependent:
                      return Colors.deepOrangeAccent;
                    case PlatformFilter.independent:
                      return Colors.blueAccent;
                    case PlatformFilter.demo:
                      return Colors.green;
                  }
                }.call(),
                child: IconButton(
                  icon: () {
                    switch (_filter) {
                      case PlatformFilter.disable:
                        return const Icon(Icons.filter_list_off);
                      case PlatformFilter.dependent:
                        return const Icon(Icons.filter_list);
                      case PlatformFilter.independent:
                        return const Icon(Icons.filter_list);
                      case PlatformFilter.demo:
                        return const Icon(Icons.visibility);
                    }
                  }.call(),
                  tooltip: l10n.homeFilter,
                  onPressed: () {
                    setState(() {
                      switch (_filter) {
                        case PlatformFilter.disable:
                          _filter = PlatformFilter.dependent;
                          break;
                        case PlatformFilter.dependent:
                          _filter = PlatformFilter.independent;
                          break;
                        case PlatformFilter.independent:
                          _filter = PlatformFilter.demo;
                          break;
                        case PlatformFilter.demo:
                          _filter = PlatformFilter.disable;
                          break;
                      }
                      widget.onChangeFiltered.call(_search ?? "", _filter);
                    });
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
