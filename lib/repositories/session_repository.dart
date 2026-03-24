import '../database/database_helper.dart';
import '../models/session.dart';

//Handles all database operations related to saving game sessions
class SessionRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  //Inserts a new session when a player starts a fresh run
  Future<int> createSession(Session session) async {
    final db = await dbHelper.database;
    return await db.insert('sessions', session.toMap());
  }

  //Updates an existing session as the player progresses through the game
  Future<int> updateSession(Session session) async {
    final db = await dbHelper.database;
    return await db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<int> deleteSession(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
}

  //Returns all sessions for one player so progress and history can be displayed
  Future<List<Map<String, dynamic>>> getPlayerSessions(String playerName) async {
    final db = await dbHelper.database;

    final result = await db.rawQuery('''
      SELECT
        sessions.id,
        players.player_name,
        sessions.theme,
        sessions.current_level,
        sessions.time_spent,
        sessions.hints_used,
        sessions.wrong_attempts,
        sessions.status,
        sessions.final_score,
        sessions.created_at
      FROM sessions
      INNER JOIN players
        ON sessions.player_id = players.id
      WHERE players.player_name = ?
      ORDER BY sessions.created_at DESC
    ''', [playerName]);

    return result;
  }

  //Returns completed sessions sorted by highest score for the leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard() async {
    final db = await dbHelper.database;

    final result = await db.rawQuery('''
      SELECT 
        sessions.id,
        players.player_name,
        sessions.theme,
        sessions.final_score,
        sessions.time_spent,
        sessions.current_level
      FROM sessions
      INNER JOIN players
        ON sessions.player_id = players.id
      WHERE sessions.status = 'completed'
        AND sessions.final_score IS NOT NULL
      ORDER BY sessions.final_score DESC
    ''');

    return result;
  }

  //Finds the latest unfinished session for this player and theme so the game can resume
  Future<Session?> getActiveSession(int playerId, String theme) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'sessions',
      where: 'player_id = ? AND theme = ? AND status = ?',
      whereArgs: [playerId, theme, 'in_progress'],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return Session.fromMap(result.first);
  }
}