import 'package:drink_reminder/features/hydration_history/domain/entities/history.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'hydrations.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE histories(id INTEGER PRIMARY KEY, value INTEGER, millisSinceEpoch INTEGER)''');
  }

  Future<void> insertOrUpdateHistory(History history) async {
    final History? todayHistory = await getTodayHistory();
    if (todayHistory != null) {
      updateHistory(history);
    } else {
      insertHistory(history);
    }
  }

  Future<History?> getTodayHistory() async {
    Database db = await instance.database;
    final now = DateTime.now();
    final result = await db.query('histories',
        where: 'millisSinceEpoch BETWEEN ? AND ?',
        whereArgs: [
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
          DateTime(now.year, now.month, now.day, 24, 59, 59)
              .millisecondsSinceEpoch
        ]);
    if (result.isEmpty) {
      return null;
    }
    return History.fromMap(result.first);
  }

  // Add record to histories table
  Future<void> insertHistory(History history) async {
    Database db = await instance.database;
    await db.insert('histories', history.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update record
  Future<void> updateHistory(History history) async {
    Database db = await instance.database;
    await db.update('histories', history.toMap(),
        where: 'id = ?',
        whereArgs: [history.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Reset/delete today current histories
  Future<void> reset() async {
    Database db = await instance.database;
    final now = DateTime.now();

    // The query parameter here is basically the same as the query parameter in
    // currentHydrations() function. The difference is here we are deleting
    // today histories record.
    await db.delete('histories',
        where: 'millisSinceEpoch BETWEEN ? AND ?',
        whereArgs: [
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
          DateTime(now.year, now.month, now.day, 24, 59, 59)
              .millisecondsSinceEpoch
        ]);
  }

  // Get today current histories
  Future<List<History>> currentHydrations() async {
    Database db = await instance.database;
    final now = DateTime.now();

    // To get today current histories, we should add BETWEEN parameter
    // to fetch histories start from beginning time of
    //today 00.00 a.m to end of the day 12.59 p.m
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM histories
      WHERE millisSinceEpoch
      BETWEEN '${DateTime(now.year, now.month, now.day).millisecondsSinceEpoch}'
      AND '${DateTime(now.year, now.month, now.day, 24, 59, 59).millisecondsSinceEpoch}'
    ''');

    final result = List.generate(
      maps.length,
      (index) => History.fromMap(maps[index]),
    );

    return result;
  }
}
