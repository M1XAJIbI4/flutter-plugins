// SPDX-FileCopyrightText: Copyright 2024 Open Mobile Platform LLC <community@omp.ru>
// SPDX-License-Identifier: BSD-3-Clause
import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Keys form demo
enum ValueKeys { id, int, double, string }

/// Table name
const table = 'Test';

/// Main features of the plugin shared_preferences
class PluginImpl {
  /// Get instance Database
  Database? _db;

  /// Stream for update values sqflite
  /// from form
  StreamController<bool>? _streamController;

  /// Check save data to Database
  Stream<bool> isEmptyStream() {
    if (_streamController == null) {
      _streamController = StreamController<bool>(onListen: () async {
        // Init db
        await init();
        // Check is empty
        _streamController!.add(await isEmpty());
      }, onCancel: () async {
        // Close db
        await close();
      });
    }
    return _streamController!.stream;
  }

  /// Check is table not empty
  Future<bool> isEmpty() async {
    final rows = await _db?.rawQuery(
      'SELECT COUNT(rowid) as count FROM ${table}',
    );
    if (rows != null && rows.isNotEmpty && rows[0].containsKey('count')) {
      return rows[0]['count'] == 0;
    }
    return true;
  }

  /// Init database
  Future<void> init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = p.join(databasesPath, 'demo.db');

    // Open the database
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        await db.execute('''CREATE TABLE ${table} (
              val_int INTEGER,
              val_double REAL,
              val_str TEXT
            )''');
      },
    );
  }

  /// Close database
  Future<void> close() async {
    await _db?.close();
  }

  /// Get value from Database
  Future<Map<ValueKeys, dynamic>?> getValues() async {
    final rows = await _db?.rawQuery('SELECT rowid as id, * FROM ${table}');
    if (rows != null && rows.isNotEmpty && rows[0].containsKey('id')) {
      return {
        ValueKeys.id: rows[0]['id'],
        ValueKeys.int: rows[0]['val_int'],
        ValueKeys.double: rows[0]['val_double'],
        ValueKeys.string: rows[0]['val_str'],
      };
    }
    return null;
  }

  /// Set value to Database
  Future<void> insert({
    required int valueInt,
    required double valueDouble,
    required String valueString,
  }) async {
    await _db?.transaction((txn) async {
      await txn.rawInsert(
        'INSERT INTO ${table}(val_int, val_double, val_str) VALUES(?, ?, ?)',
        [valueInt, valueDouble, valueString],
      );
    });
    // After insert sqflite not empty
    _streamController!.add(false);
  }

  /// Update values to Database
  Future<bool> update({
    required int id,
    required int valueInt,
    required double valueDouble,
    required String valueString,
  }) async {
    try {
      await _db?.transaction((txn) async {
        final result = await txn.rawUpdate(
          'UPDATE ${table} SET val_int = ?, val_double = ?, val_str = ? WHERE rowid = ?',
          [valueInt, valueDouble, valueString, id],
        );
        if (result == 0) {
          throw Exception('Nothing to update');
        }
      });
      // After insert sqflite not empty
      _streamController!.add(false);
      // Update success
      return true;
    } catch (e) {
      // Id not found
      return false;
    }
  }

  /// Clear all data table
  Future<void> clear() async {
    await _db?.rawDelete('DELETE FROM ${table}');
    // After clear date sqflite is empty
    _streamController!.add(true);
  }
}
