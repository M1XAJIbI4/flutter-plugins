// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:shared_preferences/shared_preferences.dart';

/// Main features of the plugin FlutterKeyboardVisibility
class PluginImpl {
  /// Read shared preferences
  Future<SharedPreferences> get _prefs async => await SharedPreferences.getInstance();

  Map<String, dynamic>? readValues;

  /// Set Int value
  Future<void> setInt(int counter) async {
    // Save an integer value to 'counter' key.
    await (await _prefs).setInt('counter', counter);
  }

  /// Set bool value
  Future<void> setBool(bool repeat) async {
    // Save an boolean value to 'repeat' key.
    await (await _prefs).setBool('repeat', repeat);
  }

  /// Set double value
  Future<void> setDouble(double decimal) async {
    // Save an double value to 'decimal' key.
    await (await _prefs).setDouble('decimal', decimal);
  }

  /// Set String value
  Future<void> setString(String action) async {
    // Save an String value to 'action' key.
    await (await _prefs).setString('action', action);
  }

  /// CLear all data from shared preferences
  Future<void> clearAllData() async {
    await (await _prefs).clear();
    readValues!.clear();
    readValues = null;
  }

  /// Get data from shared preferences
  Future<void> getData() async {
    final prefs = await _prefs;
    readValues = {
      'int': prefs.getInt('counter'),
      'bool': prefs.getBool('repeat'),
      'double': prefs.getDouble('decimal'),
      'string': prefs.getString('action'),
    };
  }
}
