import 'package:drink_reminder/common/helpers.dart';
import 'package:drink_reminder/features/hydration_history/domain/entities/history.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const String databaseName = 'hydrations';
const String tableName = 'histories';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), '$databaseName.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE $tableName(id INTEGER PRIMARY KEY, value INTEGER, millisSinceEpoch INTEGER)''');
  }

  Future<void> insertOrUpdateHistory(History newHistory) async {
    final History? todayHistory = await getTodayHistory();
    if (todayHistory != null) {
      updateHistory(History(
          id: todayHistory.id,
          value: newHistory.value,
          createdAt: DateTime.now()));
    } else {
      insertHistory(newHistory);
    }
  }

  Future<void> deleteHistory(String id) async {
    Database db = await instance.database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<History?> getTodayHistory() async {
    Database db = await instance.database;
    final now = DateTime.now();
    final result = await db.query(tableName,
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

  Future<List<History>> getAllHistory() async {
    Database db = await instance.database;
    final now = DateTime.now();
    final result = await db.query(tableName,
        where: 'millisSinceEpoch BETWEEN ? AND ?',
        whereArgs: [
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
          DateTime(now.year, now.month, now.day, 24, 59, 59)
              .millisecondsSinceEpoch
        ]);
    if (result.isEmpty) {
      return [];
    }
    return result.map((e) => History.fromMap(e)).toList();
  }

  Future<List<History?>> getCurrentWeekHistory() async {
    Database db = await instance.database;
    final now = DateTime.now();
    final result = await db.query(tableName,
        where: 'millisSinceEpoch BETWEEN ? AND ?',
        whereArgs: [
          findFirstDateOfTheWeek(DateTime(now.year, now.month, now.day))
              .millisecondsSinceEpoch,
          findLastDateOfTheWeek(
                  DateTime(now.year, now.month, now.day, 24, 59, 59))
              .millisecondsSinceEpoch
        ]);
    final List<History?> list = List.filled(7, null);

    if (result.isEmpty) {
      return list;
    }

    for (var i = 0; i < 7; i++) {
      var tempDate =
          findFirstDateOfTheWeek(DateTime(now.year, now.month, now.day))
              .add(Duration(days: i));
      for (var item in result) {
        if (tempDate.day ==
            DateTime.fromMillisecondsSinceEpoch(item['millisSinceEpoch'] as int)
                .day) {
          list[i] = History.fromMap(item);
        }
      }
    }

    return list;
  }

  // Add record to histories table
  Future<void> insertHistory(History history) async {
    Database db = await instance.database;
    await db.insert(tableName, history.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Update record
  Future<void> updateHistory(History history) async {
    Database db = await instance.database;
    await db.update(tableName, history.toMap(),
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
    await db.delete(tableName,
        where: 'millisSinceEpoch BETWEEN ? AND ?',
        whereArgs: [
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
          DateTime(now.year, now.month, now.day, 24, 59, 59)
              .millisecondsSinceEpoch
        ]);
  }
}
