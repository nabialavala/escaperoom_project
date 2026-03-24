## Experiment 626: Escape Missions
## escape_room

Experiment 626: Escape Missions is a puzzle-based escape room mobile application developed using Flutter. Inspired by the idea of controlled chaos and experimental challenges, players must navigate through a series of themed missions by solving puzzles, collecting items, and progressing through levels.

Each mission represents a unique “experiment,” where players must think critically under pressure to escape. The game features multiple immersive themes, including Zombie Lab, Murder Mystery, and Time Travel, each containing 10 progressively challenging levels.

Players must solve riddles, uncover clues, and collect key items to complete each mission. Progress is tracked using a local SQLite database, allowing players to resume sessions, monitor performance, and compete on a leaderboard.

The objective is simple: solve every puzzle, complete every experiment, and escape.

## Techologies Used
- Flutter (Dart)
- SQLite (sqflite package)
- SharedPreferences (for settings)
- Material UI

## Project Structure
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

## How the App Works
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

## Hint System
Hints are stored in the database and displayed during gameplay when unlocked.

## Scoring System
The final score is calculated using the following formula:
Score = 1000 - (time * 2) - (hints * 50) - (wrong attempts * 25) + (difficulty bonus * 100)

## Screens
- Home Screen: start game and view instructions  
- Login Screen: enter player name  
- Theme Screen: select game theme and access stats  
- Game Screen: solve puzzles and progress through levels  
- Progress Screen: view player statistics and sessions  
- Leaderboard Screen: view top scores  
- Summary Screen: display final results  
- Settings Screen: manage user preferences  

## Setup Instructions
1. Prerequisites
Make sure you have installed:
Flutter SDK
Dart SDK
Android Studio or VS Code
Emulator or physical Android device

2. Clone the repository:
git clone https://github.com/your-username/your-repo-name.git

3. Navigate to the project directory:
cd escape_room

4. Install dependencies:
flutter pub get

5. Run the application:
flutter run

6. Build APK (for submission)
flutter build apk --release

APK will be located in:
build/app/outputs/flutter-apk/app-release.apk

## Data & Persistence
Data is stored locally using SQLite
Player progress is automatically saved
Sessions can resume if not completed
Settings (username, theme, etc.) use SharedPreferences

## Features
- Player login system
- Multiple puzzle themes
- Real-time timer
- Hint system with delay
- Progress tracking
- Leaderboard ranking
- Persistent sessions
- Score calculation system

## Notes / Known Limitations
- App currently supports single-player mode
- No online database (local only)
- UI optimized for Android (not fully tested on iOS)

## Future Improvements
- Multiplayer support
- Online leaderboard
- More themes and puzzles
- Sound effects and animations
- User authentication system