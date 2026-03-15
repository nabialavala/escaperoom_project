import '../database/database_helper.dart';
import '../models/session.dart';

class SessionRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<int> createSession(Session session) async {
    final db = await dbHelper.database;
    return await db.insert('sessions', session.toMap());
  }

  Future<int> updateSession(Session session) async {
    final db = await dbHelper.database;
    return await db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }
}