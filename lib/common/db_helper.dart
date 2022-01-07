import 'package:drink_reminder/features/hydration_reminder/domain/entities/hydration.dart';
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
        '''CREATE TABLE hydrations(id INTEGER PRIMARY KEY, value INTEGER, millisSinceEpoch INTEGER)''');
  }

  // Add record to hydrations table
  Future<void> insertHydration(Hydration hydration) async {
    Database db = await instance.database;
    await db.insert('hydrations', hydration.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Reset/delete today current hydrations
  Future<void> reset() async {
    Database db = await instance.database;
    final now = DateTime.now();

    // The query parameter here is basically the same as the query parameter in
    // currentHydrations() function. The difference is here we are deleting
    // today hydrations record.
    await db.delete('hydrations',
        where: 'millisSinceEpoch BETWEEN ? AND ?',
        whereArgs: [
          DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
          DateTime(now.year, now.month, now.day, 24, 59, 59)
              .millisecondsSinceEpoch
        ]);
  }

  // Get today current hydrations
  Future<List<Hydration>> currentHydrations() async {
    Database db = await instance.database;
    final now = DateTime.now();

    // To get today current hydrations, we should add BETWEEN parameter
    // to fetch hydrations start from beginning time of
    //today 00.00 a.m to end of the day 12.59 p.m
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT * FROM hydrations
      WHERE millisSinceEpoch
      BETWEEN '${DateTime(now.year, now.month, now.day).millisecondsSinceEpoch}'
      AND '${DateTime(now.year, now.month, now.day, 24, 59, 59).millisecondsSinceEpoch}'
    ''');

    final result = List.generate(
      maps.length,
      (index) => Hydration(
        id: maps[index]['id'],
        value: maps[index]['value'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            maps[index]['millisSinceEpoch']),
      ),
    );

    return result;
  }

  Future<void> deleteLastDrink() async {
    Database db = await instance.database;
    final hydrations = await currentHydrations();
    final test = await db
        .delete('hydrations', where: 'id = ?', whereArgs: [hydrations.last.id]);
  }
}
