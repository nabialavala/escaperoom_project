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


