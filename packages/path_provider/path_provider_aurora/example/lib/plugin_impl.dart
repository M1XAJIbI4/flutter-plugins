// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:io';

import 'package:path_provider/path_provider.dart' as provider;
import 'package:path_provider/path_provider.dart';

/// Main features of the plugin path_provider
class PluginImpl {
  /// Directory where the application may place application support files.
  Future<Directory> getApplicationSupportDirectory() {
    return provider.getApplicationSupportDirectory();
  }

  /// Directory location where user-specific non-essential (cached)
  /// data should be written.
  Future<Directory> getTemporaryDirectory() {
    return provider.getTemporaryDirectory();
  }

  /// Directory containing user document files.
  Future<Directory> getApplicationDocumentsDirectory() {
    return provider.getApplicationDocumentsDirectory();
  }

  /// Directory for user's downloaded files.
  Future<Directory?> getDownloadsDirectory() {
    return provider.getDownloadsDirectory();
  }

  /// There is no concept of External in Aurora OS, but this interface
  /// allows you to get the StorageDirectory.pictures directory.
  Future<Directory?> getExternalStorageDirectoriesPictures() async {
    final folders = await provider.getExternalStorageDirectories(
      type: StorageDirectory.pictures,
    );
    return folders?.firstOrNull;
  }

  /// There is no concept of External in Aurora OS, but this interface
  /// allows you to get the StorageDirectory.music directory.
  Future<Directory?> getExternalStorageDirectoriesMusic() async {
    final folders = await provider.getExternalStorageDirectories(
      type: StorageDirectory.music,
    );
    return folders?.firstOrNull;
  }

  /// There is no concept of External in Aurora OS, but this interface
  /// allows you to get the StorageDirectory.movies directory.
  Future<Directory?> getExternalStorageDirectoriesMovies() async {
    final folders = await provider.getExternalStorageDirectories(
      type: StorageDirectory.movies,
    );
    return folders?.firstOrNull;
  }
}
