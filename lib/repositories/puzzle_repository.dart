import '../database/database_helper.dart';
import '../models/puzzle.dart';

//Handles puzzle-related database queries so UI stays clean
class PuzzleRepository {
  final DatabaseHelper dbHelper = DatabaseHelper.instance;

  //Loads all puzzles for the slected theme in order
  Future<List<Puzzle>> getPuzzlesByTheme(String theme) async {
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