import 'package:sqflite/sqflite.dart';
import 'database_helper.dart';
import 'models.dart';

class SajadahRepository {
  final DatabaseHelper _helper = DatabaseHelper.instance;

  Future<void> saveSchedule(PrayerSchedule schedule) async {
    final db = await _helper.database;
    await db.insert('schedules', schedule.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PrayerSchedule>> getSchedules() async {
    final db = await _helper.database;
    final rows = await db.query('schedules', orderBy: 'date DESC');
    return rows.map(PrayerSchedule.fromMap).toList();
  }

  Future<PrayerSchedule?> getSchedule(String date) async {
    final db = await _helper.database;
    final rows = await db.query('schedules', where: 'date = ?', whereArgs: [date]);
    return rows.isEmpty ? null : PrayerSchedule.fromMap(rows.first);
  }

  Future<void> deleteSchedule(int id) async {
    final db = await _helper.database;
    await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> saveAttendance(PrayerAttendance attendance) async {
    final db = await _helper.database;
    await db.insert('attendance', attendance.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PrayerAttendance>> getAttendance({String? date}) async {
    final db = await _helper.database;
    final rows = await db.query(
      'attendance',
      where: date == null ? null : 'date = ?',
      whereArgs: date == null ? null : [date],
      orderBy: 'date DESC, id ASC',
    );
    return rows.map(PrayerAttendance.fromMap).toList();
  }

  Future<void> deleteAttendance(int id) async {
    final db = await _helper.database;
    await db.delete('attendance', where: 'id = ?', whereArgs: [id]);
  }
}
