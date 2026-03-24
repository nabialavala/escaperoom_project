# Experiment 626: Escape Missions
# escape_room

Experiment 626: Escape Missions is a puzzle-based escape room mobile application developed using Flutter. Inspired by the idea of controlled chaos and experimental challenges, players must navigate through a series of themed missions by solving puzzles, collecting items, and progressing through levels.

Each mission represents a unique “experiment,” where players must think critically under pressure to escape. The game features multiple immersive themes, including Zombie Lab, Murder Mystery, and Time Travel, each containing 10 progressively challenging levels.

Players must solve riddles, uncover clues, and collect key items to complete each mission. Progress is tracked using a local SQLite database, allowing players to resume sessions, monitor performance, and compete on a leaderboard.

The objective is simple: solve every puzzle, complete every experiment, and escape.

# Techologies Used
Flutter (Dart)
SQLite (sqflite package)
SharedPreferences (for settings)
Material UI

# Project Structure
lib/
│
├── models/
│   ├── player.dart
│   ├── puzzle.dart
│   ├── session.dart
│
├── database/
│   └── database_helper.dart
│
├── repositories/
│   ├── puzzle_repository.dart
│   └── session_repository.dart
│
├── screens/
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── theme_screen.dart
│   ├── game_screen.dart
│   ├── progress_screen.dart
│   ├── leader_screen.dart
│   ├── settings_screen.dart
│   └── summary_screen.dart
│
├── services/
│   ├── hint_service.dart
│   └── score_service.dart
│
├── widgets/
│   ├── puzzle_card.dart
│   └── hint_popup.dart
│
└── main.dart

# How the App Works
1. Player Flow
User enters their name (Login Screen)
Selects a theme (Theme Screen)
Plays through puzzles (Game Screen)
Progress is saved automatically
User can view:
Progress
Leaderboard
Final score summary

2. The app uses a local SQLite database initialized in database_helper.
Tables:
players → stores usernames
puzzles → stores all puzzle data
sessions → tracks game progress

Key features:
Database versioning & upgrades supported
Automatic puzzle seeding on first launch
Foreign key relationship between sessions and players

3. Puzzle System
Each puzzle contains:
Story text
Question
Accepted answers (multiple allowed using |)
Hint
Reward item

Handled by the Puzzle model.

4. Session Tracking
Each game session tracks:
Current level
Time spent
Hints used
Wrong attempts
Collected items
Final score

Managed using the session model and repository.

5. Game Logic
The main game logic is handled in GameScreen:
Loads puzzles by theme
Validates answers
Unlocks hints after 60 seconds
Tracks score and progress
Saves session continuously

6. Leaderboard & Progress
Leaderboard: Shows top scores across players
Progress Screen: Shows current and completed sessions

Both pull data using SQL queries from session_repository.
