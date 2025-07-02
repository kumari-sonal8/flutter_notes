import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class NoteDB {
  final dbHelper = AppDatabase.instance;

  Future<bool> addNote({
    required String title,
    required String desc,
    required String uid,
  }) async {
    final db = await dbHelper.database;
    final result = await db.insert('note', {
      'title': title,
      'desc': desc,
      'uid': uid,
    });
    return result > 0;
  }

  Future<List<Map<String, dynamic>>> getNotes(String uid) async {
    final db = await dbHelper.database;
    return await db.query('note', where: 'uid = ?', whereArgs: [uid]);
  }

  Future<bool> updateNote({
    required int sno,
    required String title,
    required String desc,
  }) async {
    final db = await dbHelper.database;
    final result = await db.update(
      'note',
      {'title': title, 'desc': desc},
      where: 'sno = ?',
      whereArgs: [sno],
    );
    return result > 0;
  }

  Future<bool> deleteNote(int sno) async {
    final db = await dbHelper.database;
    final result = await db.delete('note', where: 'sno = ?', whereArgs: [sno]);
    return result > 0;
  }
}
