import '../database/database_helper.dart';
import '../models/puzzle.dart';

class PuzzleRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  Future<List<Puzzle>> getPuzzlesByTheme(String theme) async{
    final db = await dbHelper.database;

    final result = await db.query(
      'puzzles',
      where: 'theme = ?',
      whereArgs: [theme],
      orderBy: 'level_number ASC',
    );
    return result.map((map) => Puzzle.fromMap(map)).toList();
  }
}