import 'package:drink_reminder/features/hydration_reminder/domain/entities/hydration.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'groceries.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE groceries(
          id INTEGER PRIMARY KEY,
          name TEXT
      )
      ''');
  }

  Future<void> insertHydration(Hydration hydration) async {
    Database db = await instance.database;
    await db.insert('hydrations', hydration.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Hydration>> currentHydrations() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('hydrations');

    return List.generate(
      maps.length,
      (index) => Hydration(
        id: maps[index]['id'],
        value: maps[index]['value'],
        createdAt: DateTime.fromMillisecondsSinceEpoch(
            maps[index]['millisSinceEpoch']),
      ),
    );
  }
}
