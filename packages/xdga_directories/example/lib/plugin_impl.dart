// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:xdga_directories/xdga_directories.dart' as xdga;

/// Main features of the plugin <PluginName>
class PluginImpl {
  /// QStandardPaths::CacheLocation
  String getCacheLocation() {
    return xdga.getCacheLocation();
  }

  /// QStandardPaths::AppDataLocation
  String getAppDataLocation() {
    return xdga.getAppDataLocation();
  }

  /// QStandardPaths::DocumentsLocation
  String getDocumentsLocation() {
    return xdga.getDocumentsLocation();
  }

  /// QStandardPaths::DownloadLocation
  String getDownloadLocation() {
    return xdga.getDownloadLocation();
  }

  /// QStandardPaths::MusicLocation
  String getMusicLocation() {
    return xdga.getMusicLocation();
  }

  /// QStandardPaths::PicturesLocation
  String getPicturesLocation() {
    return xdga.getPicturesLocation();
  }

  /// QStandardPaths::GenericDataLocation
  String getGenericDataLocation() {
    return xdga.getGenericDataLocation();
  }

  /// QStandardPaths::MoviesLocation
  String getMoviesLocation() {
    return xdga.getMoviesLocation();
  }
}
