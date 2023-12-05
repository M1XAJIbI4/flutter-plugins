// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:flutter_example_packages/base/package/package_page.dart';
import 'package:get_it/get_it.dart';

import 'model.dart';
import 'page.dart';

/// Package values
final packageCamera = PackagePage(
  key: 'camera',
  descEN: '''
    A Flutter plugin for Aurora, iOS, Android and Web allowing access 
    to the device cameras.
    ''',
  descRU: '''
    Плагин Flutter для Aurora, iOS, Android и Интернета, обеспечивающий доступ
    к камерам устройства.
    ''',
  version: '0.10.5+2',
  isPlatformDependent: true,
  page: () => CameraPage(),
  init: () {
    GetIt.instance.registerFactory<CameraModel>(() => CameraModel());
  },
);
