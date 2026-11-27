import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    // Inisialisasi database khusus Chrome/Web
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    final dbPath = await getDatabasesPath();

    _database = await openDatabase(
      p.join(dbPath, 'sajadahku.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE schedules(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL UNIQUE,
            fajr TEXT NOT NULL,
            dhuhr TEXT NOT NULL,
            asr TEXT NOT NULL,
            maghrib TEXT NOT NULL,
            isha TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE attendance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            prayer TEXT NOT NULL,
            status TEXT NOT NULL,
            note TEXT NOT NULL DEFAULT '',
            UNIQUE(date, prayer)
          )
        ''');
      },
    );

    return _database!;
  }
}
