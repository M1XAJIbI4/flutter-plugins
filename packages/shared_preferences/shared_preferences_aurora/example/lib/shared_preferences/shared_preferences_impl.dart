// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:shared_preferences/shared_preferences.dart';

/// Main features of the plugin FlutterKeyboardVisibility
class SharedPreferencesImpl {
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  /// Read shared preferences
  Map<String, dynamic>? _readValues;

  /// Public values
  Map<String, dynamic>? get readValues => _readValues;

  /// Stream change visibility
  Future<void> setInt(int counter) async {
    // Save an integer value to 'counter' key.
    await (await _prefs).setInt('counter', counter);
  }

  /// Stream change visibility
  Future<void> setBool(bool repeat) async {
    // Save an boolean value to 'repeat' key.
    await (await _prefs).setBool('repeat', repeat);
  }

  /// Stream change visibility
  Future<void> setDouble(double decimal) async {
    // Save an double value to 'decimal' key.
    await (await _prefs).setDouble('decimal', decimal);
  }

  /// Stream change visibility
  Future<void> setString(String action) async {
    // Save an String value to 'action' key.
    await (await _prefs).setString('action', action);
  }

  Future<void> clearAllData() async {
    await (await _prefs).clear();
    _readValues!.clear();
    _readValues = null;
  }

  ///Get
  Future<void> getData() async {
    final prefs = await _prefs;
    _readValues = {
      'int': prefs.getInt('counter'),
      'bool': prefs.getBool('repeat'),
      'double': prefs.getDouble('decimal'),
      'string': prefs.getString('action'),
    };
  }
}
