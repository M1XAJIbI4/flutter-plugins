/*
 * Copyright (C) 2023 Open Mobile Platform LLC.
 */
import 'package:package_info_plus_aurora/package_info_plus_aurora.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:xdga_directories/xdga_directories.dart' as xdga_directories;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;

/// The aurora implementation of [PathProviderPlatform]
///
/// This class implements the `package:path_provider` functionality for Aurora.
class PathProviderAurora extends PathProviderPlatform {
  /// Registers this class as the default instance of [PathProviderPlatform]
  static void registerWith() {
    PathProviderPlatform.instance = PathProviderAurora();
  }

  /// Path to a directory where the application may place application support files.
  @override
  Future<String?> getApplicationSupportPath() async {
    PackageInfo info = await PackageInfo.fromPlatform();

    final appName = info.packageName.split('.').last;
    final orgName = info.packageName.replaceAll('.$appName', '');

    // QStandardPaths::AppDataLocation
    return p.join(
      xdga_directories.getAppDataLocation(),
      orgName,
      appName,
    );
  }

  /// Path to the temporary directory on the device that is not backed up and is
  /// suitable for storing caches of downloaded files.
  @override
  Future<String> getTemporaryPath() async {
    PackageInfo info = await PackageInfo.fromPlatform();

    final appName = info.packageName.split('.').last;
    final orgName = info.packageName.replaceAll('.$appName', '');

    // QStandardPaths::CacheLocation
    return p.join(
      xdga_directories.getCacheLocation(),
      orgName,
      appName,
    );
  }

  /// Path to a directory where the application may place data that is
  /// user-generated, or that cannot otherwise be recreated by your application.
  @override
  Future<String> getApplicationDocumentsPath() async {
    // QStandardPaths::DocumentsLocation
    return xdga_directories.getDocumentsLocation();
  }

  /// Path to the directory where downloaded files can be stored.
  /// This is typically only relevant on desktop operating systems.
  @override
  Future<String> getDownloadsPath() async {
    // QStandardPaths::DownloadLocation
    return xdga_directories.getDownloadLocation();
  }

  /// Paths to directories where application specific data can be stored.
  /// These paths typically reside on external storage like separate partitions
  /// or SD cards. Phones may have multiple storage directories available.
  @override
  Future<List<String>?> getExternalStoragePaths({
    /// Optional parameter. See [StorageDirectory] for more informations on
    /// how this type translates to Android storage directories.
    StorageDirectory? type,
  }) async {
    switch (type) {
      case StorageDirectory.pictures:
        return [
          xdga_directories.getPicturesLocation()
        ]; // QStandardPaths::PicturesLocation
      case StorageDirectory.music:
        return [
          xdga_directories.getMusicLocation()
        ]; // QStandardPaths::MusicLocation
      case StorageDirectory.movies:
        return [
          xdga_directories.getMoviesLocation()
        ]; // QStandardPaths::MoviesLocation
      default:
        throw UnimplementedError('Type "$type" not supported.');
    }
  }
}
