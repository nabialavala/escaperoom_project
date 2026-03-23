import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'seed_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDB('escape_room.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE puzzles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        theme TEXT NOT NULL,
        level_number INTEGER NOT NULL,
        story_text TEXT NOT NULL,
        question TEXT NOT NULL,
        accepted_answers TEXT NOT NULL,
        reward_text TEXT NOT NULL,
        is_final_level INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_id INTEGER NOT NULL,
        theme TEXT NOT NULL,
        current_level INTEGER NOT NULL, 
        time_spent INTEGER NOT NULL, 
        hints_used INTEGER NOT NULL, 
        wrong_attempts INTEGER NOT NULL, 
        status TEXT NOT NULL, 
        final_score INTEGER NOT NULL, 
        created_at TEXT NOT NULL,
        FOREIGN KEY (player_id) REFERENCES players(id)
      )
    ''');
    for (var puzzle in seedPuzzles) {
      await db.insert('puzzles', puzzle.toMap());
    }
  }
}