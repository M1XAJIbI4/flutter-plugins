// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage_aurora/flutter_secure_storage_aurora.dart';

/// Main features of the plugin flutter_secure_storage
class PluginImpl {
  /// Get instance secure storage
  final _storage = const FlutterSecureStorage();

  /// Stream for update values SecureStorage from form
  StreamController<String?> _streamController = StreamController();

  /// Get save data to SecureStorage
  Stream<String?> getValueStream() {
    return _streamController.stream;
  }

  /// Get value from SecureStorage
  Future<dynamic> getValue({
    required String key,
    required String password,
  }) async {
    return await _storage.read(key: key);
  }

  /// Set value from SecureStorage
  Future<void> setValue({
    required String key,
    required String value,
    required String password,
  }) async {
    // Update secret key
    _setPassword(password);
    // Clear old data after change password
    await _storage.deleteAll();
    // Save new data
    await _storage.write(key: key, value: value);

    /// Retrieving already saved data using
    /// a password via the SecureStorage plugin
    _streamController.add(await getValue(
      key: key,
      password: password,
    ));
  }

  /// Clear all data
  Future<void> clear() async {
    await _storage.deleteAll();
    // After clear date SecureStorage is empty
    _streamController.add(null);
  }

  /// Set password for SecureStorage
  void _setPassword(String password) {
    FlutterSecureStorageAurora.setSecret(
      _getPasswordFromString(password),
    );
  }

  /// Generate secure key 32 length from string password
  String _getPasswordFromString(String password) {
    return md5.convert(utf8.encode(password)).toString();
  }
}
