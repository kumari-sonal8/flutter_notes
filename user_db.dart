import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class UserDB {
  final dbHelper = AppDatabase.instance;

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<String> addUser({
    required String uid,
    required String name,
    required String email,
    required String password,
  }) async {
    final db = await dbHelper.database;
    final hashedPassword = hashPassword(password);

    final existing = await db.query(
      'user_table',
      where: 'uid = ?',
      whereArgs: [uid],
    );

    if (existing.isNotEmpty) return 'duplicate';

    try {
      await db.insert('user_table', {
        'uid': uid,
        'name': name,
        'email': email,
        'password': hashedPassword,
      });
      return 'success';
    } catch (e) {
      return 'error';
    }
  }

  Future<Map<String, dynamic>?> loginUser({
    required String uid,
    required String name,
    required String password,
  }) async {
    final db = await dbHelper.database;
    final hashed = hashPassword(password);

    final result = await db.query(
      'user_table',
      where: 'uid = ? AND name = ? AND password = ?',
      whereArgs: [uid, name, hashed],
    );

    return result.isNotEmpty ? result.first : null;
  }
}
