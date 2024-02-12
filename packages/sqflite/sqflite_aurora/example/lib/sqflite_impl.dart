// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Main features of the plugin FlutterKeyboardVisibility
class PluginImpl {
  /// Database
  Database? _db;

  /// Error
  String? _error;

  /// Public error
  String? get error => _error;

  /// Public is error
  bool get isError => _error != null;

  /// Public data
  List<Map> get data => _data ?? [];

  /// Private data
  List<Map>? _data;

  /// Init database
  Future<void> init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'demo.db');

    // Delete the database
    await deleteDatabase(path);

    // open the database
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute('''CREATE TABLE Test (
              name TEXT, 
              value INTEGER, 
              num REAL
            )''');
      },
    );
  }

  /// Close database
  Future<void> close() async {
    await _db?.close();
  }

  /// Remove all rows
  Future<void> clear() async {
    try {
      // Query
      await _db?.rawDelete('DELETE FROM Test');
      // Update data
      _data = await _allSelect();
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Insert data
  Future<void> insert(
    String name,
    int value,
    double num,
  ) async {
    try {
      // Query
      await _db?.transaction((txn) async {
        await txn.rawInsert('INSERT INTO Test(name, value, num) VALUES(?, ?, ?)', [name, value, num]);
      });
      // Update data
      _data = await _allSelect();
    } catch (e) {
      _error = e.toString();
    }
  }

  /// Update data by ID
  Future<bool> update(
    int id,
    String name,
    int value,
    double num,
  ) async {
    int? count = 0;
    try {
      // Query
      count =
          await _db?.rawUpdate('UPDATE Test SET name = ?, value = ?, num = ? WHERE rowid = ?', [name, value, num, id]);
      // Update data
      _data = await _allSelect();
      // Check state
    } catch (e) {
      _error = e.toString();
    }
    return count == 1;
  }

  /// Delete data by ID
  Future<bool> delete(
    int id,
  ) async {
    int? count = 0;
    try {
      // Query
      count = await _db?.rawDelete('DELETE FROM Test WHERE rowid = ?', [id]);
      // Update data
      _data = await _allSelect();
    } catch (e) {
      _error = e.toString();
    }
    return count == 1;
  }

  /// Select all rows
  Future<List<Map>?> _allSelect() async {
    try {
      return await _db?.rawQuery('SELECT rowid as id, * FROM Test');
    } catch (e) {
      _error = e.toString();
    }
    return null;
  }
}
