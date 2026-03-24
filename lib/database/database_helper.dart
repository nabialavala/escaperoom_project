import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'seed_data.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  //Returns the single shared database instance so the app does not open multiple connections
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('escape_room.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
      onOpen: _onOpen,
    );
  }

  //Creates all required tables the first time the database is built
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE players (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player_name TEXT NOT NULL,
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE puzzles (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        theme TEXT NOT NULL,
        level_number INTEGER NOT NULL,
        story_text TEXT NOT NULL,
        question TEXT NOT NULL,
        accepted_answers TEXT NOT NULL,
        reward_text TEXT NOT NULL,
        is_final_level INTEGER NOT NULL,
        hint TEXT NOT NULL
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
        collected_items TEXT NOT NULL DEFAULT '',
        FOREIGN KEY (player_id) REFERENCES players (id)
      )
    ''');

    await _seedPuzzles(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("""
        ALTER TABLE sessions
        ADD COLUMN collected_items TEXT NOT NULL DEFAULT ''
      """);
    }

    if (oldVersion < 3) {
      await db.execute('DROP TABLE IF EXISTS puzzles');

      await db.execute('''
        CREATE TABLE puzzles (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          theme TEXT NOT NULL,
          level_number INTEGER NOT NULL,
          story_text TEXT NOT NULL,
          question TEXT NOT NULL,
          accepted_answers TEXT NOT NULL,
          reward_text TEXT NOT NULL,
          is_final_level INTEGER NOT NULL,
          hint TEXT NOT NULL
        )
      ''');

      await _seedPuzzles(db);
    }
  }

  Future<void> _onOpen(Database db) async {
    await _seedPuzzlesIfEmpty(db);
  }

  Future<void> _seedPuzzles(Database db) async {
    for (final puzzle in seedPuzzles) {
      await db.insert(
        'puzzles',
        puzzle.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  //Prevents duplicate puzzle inserts by only seeding when puzzle table is empty
  Future<void> _seedPuzzlesIfEmpty(Database db) async {
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM puzzles');
    final count = Sqflite.firstIntValue(result) ?? 0;

    if (count == 0) {
      await _seedPuzzles(db);
    }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}