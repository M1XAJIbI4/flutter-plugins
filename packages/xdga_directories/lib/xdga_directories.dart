// SPDX-FileCopyrightText: Copyright 2023 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'xdga_directories_bindings_generated.dart';

/// The dynamic library in which the symbols for [XdgaDirectoriesBindings] can be found.
final DynamicLibrary _dylib = () {
  return DynamicLibrary.open('libxdga_directories.so');
}();

/// The bindings to the native functions in [_dylib].
final XdgaDirectoriesBindings _bindings = XdgaDirectoriesBindings(_dylib);

/// QStandardPaths::CacheLocation
String getCacheLocation() => _bindings
    .getCacheLocation()
    .cast<Utf8>()
    .toDartString()
    .replaceAll("/qsource", "");

/// QStandardPaths::AppDataLocation
String getAppDataLocation() => _bindings
    .getAppDataLocation()
    .cast<Utf8>()
    .toDartString()
    .replaceAll("/qsource", "");

///  QStandardPaths::DocumentsLocation
String getDocumentsLocation() =>
    _bindings.getDocumentsLocation().cast<Utf8>().toDartString();

///  QStandardPaths::DownloadLocation
String getDownloadLocation() =>
    _bindings.getDownloadLocation().cast<Utf8>().toDartString();

///  QStandardPaths::MusicLocation
String getMusicLocation() =>
    _bindings.getMusicLocation().cast<Utf8>().toDartString();

///  QStandardPaths::PicturesLocation
String getPicturesLocation() =>
    _bindings.getPicturesLocation().cast<Utf8>().toDartString();

///  QStandardPaths::GenericDataLocation
String getGenericDataLocation() =>
    _bindings.getGenericDataLocation().cast<Utf8>().toDartString();

///  QStandardPaths::MoviesLocation
String getMoviesLocation() =>
    _bindings.getMoviesLocation().cast<Utf8>().toDartString();
