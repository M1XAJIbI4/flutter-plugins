// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_secure_storage_aurora/flutter_secure_storage_aurora.dart';

/// Main features of the plugin FlutterKeyboardVisibility
class PluginImpl {
  final _secureStorage = const FlutterSecureStorage();

  /// Error
  String? _error;

  /// Public error
  String? get error => _error;

  /// Public is error
  bool get isError => _error != null;

  /// Save success
  bool _isSuccess = false;

  /// Public success
  bool get isSuccess => _isSuccess;

  /// Value for read form secure storage
  String _readValue = "";

  /// Public read value
  String get readValue => _readValue;

  // Get data from secure storage
  Future<void> read({
    required String key,
    required String password,
  }) async {
    try {
      // Update secret key
      _updateByPassword(password);
      // Read data
      _readValue = await _secureStorage.read(key: key) ?? "Not found";
    } catch (e) {
      _readValue = "Error password";
    }
  }

  // Write new data in secure storage
  Future<void> write({
    required String key,
    required String value,
    required String password,
  }) async {
    try {
      // Update secret key
      _updateByPassword(password);
      // Clear old data
      await _secureStorage.deleteAll();
      // Save new data
      await _secureStorage.write(key: key, value: value);
      // Show success
      _isSuccess = true;
      // Close success
      Future.delayed(const Duration(milliseconds: 1500), () {
        _isSuccess = false;
      });
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Update password
  void _updateByPassword(String password) {
    FlutterSecureStorageAurora.setSecret(
      _getPasswordFromString(
        password,
      ),
    );
  }

  /// Generate secure key 32 length from string password
  String _getPasswordFromString(String password) {
    return md5.convert(utf8.encode(password)).toString();
  }

  /// Clear value if change values
  void clearReadValue() {
    _readValue = "";
  }
}
