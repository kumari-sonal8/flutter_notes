import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  static const String dbName = 'app_data.db';
  static const int dbVersion = 1;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory docDir = await getApplicationDocumentsDirectory();
    String path = join(docDir.path, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // Create user_table
    await db.execute('''
      CREATE TABLE user_table (
        uid TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        password TEXT
      )
    ''');

    // Create note table with foreign key reference to user_table
    await db.execute('''
      CREATE TABLE note (
        sno INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        desc TEXT,
        uid TEXT,
        FOREIGN KEY (uid) REFERENCES user_table(uid) ON DELETE CASCADE
      )
    ''');
  }
}
