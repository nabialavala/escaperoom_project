import 'dart:async';
import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../models/session.dart';
import '../repositories/puzzle_repository.dart';
import '../repositories/session_repository.dart';
import '../services/hint_service.dart';
import '../services/score_service.dart';
import 'progress_screen.dart';
import '../widgets/puzzle_card.dart';
import '../widgets/hint_popup.dart';

class GameScreen extends StatefulWidget {
  final String theme;
  final String playerName;

  const GameScreen({
    super.key,
    required this.theme,
    required this.playerName,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final PuzzleRepository puzzleRepository = PuzzleRepository();
  final SessionRepository sessionRepository = SessionRepository();
  final TextEditingController answerController = TextEditingController();
  final HintService hintService = HintService();
  final ScoreService scoreService = ScoreService();

  Timer? hintTimer;
  Timer? gameTimer;
  bool canUseHint = false;
  String hintText = '';
  int elapsedSeconds = 0;

  List<Puzzle> puzzles = [];
  int currentPuzzleIndex = 0;
  bool isLoading = true;
  String feedbackMessage = '';
  List<String> collectedItems = [];

  int wrongAttempts = 0;
  int hintsUsed = 0;
  int mysteryGuessAttemptsLeft = 3;
  DateTime? gameStartTime;
  int? sessionId;
  int? currentPlayerId;

  final List<String> murderMysteryClues = [
    'The cause of death was not obvious to anyone at the table',
    'The act happened without drawing attention',
    'The act happened in a brief, unnoticed moment',
    'Not everyone stayed where they were',
    'Having a reason does not mean someone committed the crime',
    'Some stories confirm where people were the entire time',
    'Someone was seen away from where they claimed to be',
    'The poison was delivered through something consumed',
    'The person who controlled the meal had the opportunity',
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => loadPuzzles());
  }

  Color get themeColor {
    switch (widget.theme) {
      case 'Zombie':
        return const Color(0xFF2E7D32);
      case 'Murder Mystery':
        return const Color(0xFFC62828);
      case 'Time Travel':
        return const Color(0xFF5C6F8C);
      default:
        return Colors.deepPurple;
    }
  }

  Color get themeLightColor {
    switch (widget.theme) {
      case 'Zombie':
        return const Color(0xFFA5D6A7);
      case 'Murder Mystery':
        return const Color(0xFFEF9A9A);
      case 'Time Travel':
        return const Color(0xFFB0BEC5);
      default:
        return const Color(0xFFD1C4E9);
    }
  }

  bool get isDarkMode {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Color get pageBackgroundColor {
    return isDarkMode ? Colors.black : Colors.white;
  }

  Color get sectionColor {
    return isDarkMode
        ? themeColor.withOpacity(0.18)
        : themeColor.withOpacity(0.10);
  }

  Color get strongSectionColor {
    return isDarkMode
        ? themeColor.withOpacity(0.28)
        : themeColor.withOpacity(0.16);
  }

  Color get borderColor {
    return isDarkMode
        ? themeLightColor.withOpacity(0.55)
        : themeColor.withOpacity(0.45);
  }

  Color get primaryTextColor {
    return isDarkMode ? Colors.white : Colors.black;
  }

  Color get secondaryTextColor {
    return isDarkMode ? Colors.white70 : Colors.black87;
  }

  //Loads puzzles data, finds or creates the player, and restores any existing sessions
  Future<void> loadPuzzles() async {
    final loadedPuzzles =
        await puzzleRepository.getPuzzlesByTheme(widget.theme);

    final db = await sessionRepository.dbHelper.database;

    final existingPlayers = await db.query(
      'players',
      where: 'player_name = ?',
      whereArgs: [widget.playerName],
      limit: 1,
    );

    int playerId;

    if (existingPlayers.isEmpty) {
      playerId = await db.insert('players', {
        'player_name': widget.playerName,
        'created_at': DateTime.now().toIso8601String(),
      });
    } else {
      playerId = existingPlayers.first['id'] as int;
    }

    final activeSession =
        await sessionRepository.getActiveSession(playerId, widget.theme);

    if (activeSession != null) {
      gameStartTime = DateTime.now().subtract(
        Duration(seconds: activeSession.timeSpent),
      );

      setState(() {
        puzzles = loadedPuzzles;
        currentPuzzleIndex = activeSession.currentLevel - 1;
        isLoading = false;
        sessionId = activeSession.id;
        currentPlayerId = playerId;
        hintsUsed = activeSession.hintsUsed;
        wrongAttempts = activeSession.wrongAttempts;
        collectedItems = activeSession.collectedItemsList;
        elapsedSeconds = activeSession.timeSpent;
      });
    } else {
      gameStartTime = DateTime.now();

      final newSession = Session(
        playerId: playerId,
        theme: widget.theme,
        currentLevel: 1,
        timeSpent: 0,
        hintsUsed: 0,
        wrongAttempts: 0,
        status: 'in_progress',
        finalScore: 0,
        createdAt: gameStartTime!.toIso8601String(),
        collectedItems: '',
      );

      final createdSessionId = await sessionRepository.createSession(newSession);

      setState(() {
        puzzles = loadedPuzzles;
        currentPuzzleIndex = 0;
        isLoading = false;
        sessionId = createdSessionId;
        currentPlayerId = playerId;
        hintsUsed = 0;
        wrongAttempts = 0;
        collectedItems = [];
        elapsedSeconds = 0;
      });
    }

    startHintTimer();
    startGameTimer();
  }

  //Saves player's current progress so the game can be resumed
  Future<void> updateCurrentSession({
    required String status,
    required int finalScore,
  }) async {
    if (sessionId == null || gameStartTime == null || currentPlayerId == null) {
      return;
    }

    final currentSession = Session(
      id: sessionId,
      playerId: currentPlayerId!,
      theme: widget.theme,
      currentLevel: currentPuzzleIndex + 1,
      timeSpent: DateTime.now().difference(gameStartTime!).inSeconds,
      hintsUsed: hintsUsed,
      wrongAttempts: wrongAttempts,
      status: status,
      finalScore: finalScore,
      createdAt: gameStartTime!.toIso8601String(),
      collectedItems: collectedItems.join('|'),
    );

    await sessionRepository.updateSession(currentSession);
  }

  //Compares user input to accepts answer
  bool isCorrectAnswer(String userAnswer, Puzzle puzzle) {
    final normalizedInput = userAnswer.toLowerCase().trim();
    return puzzle.acceptedAnswerList.contains(normalizedInput);
  }

  //Handles correct and incorrect answers, advances leveles, updates score, and ends game when needed. 
  Future<void> checkAnswer() async {
    if (puzzles.isEmpty) return;

    final currentPuzzle = puzzles[currentPuzzleIndex];
    final userAnswer = answerController.text.trim().toLowerCase();

    if (isCorrectAnswer(userAnswer, currentPuzzle)) {
      if (currentPuzzle.theme == 'Murder Mystery' &&
          currentPuzzle.isFinalLevel == 1) {
        final timeSpent = gameStartTime == null
            ? 0
            : DateTime.now().difference(gameStartTime!).inSeconds;

        final difficultyBonus =
            scoreService.getDifficultyBonus(puzzles.length);

        final finalScore = scoreService.calculateScore(
          timeSpent: timeSpent,
          hintsUsed: hintsUsed,
          wrongAttempts: wrongAttempts,
          difficultyBonus: difficultyBonus,
        );

        setState(() {
          feedbackMessage =
              'Case solved! You identified the killer. Final Score: $finalScore';
          answerController.clear();
          hintText = '';
        });

        await updateCurrentSession(
          status: 'completed',
          finalScore: finalScore,
        );

        hintTimer?.cancel();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProgressScreen(
              playerName: widget.playerName,
            ),
          ),
        );
        return;
      }

      if (currentPuzzle.theme != 'Murder Mystery' &&
          !collectedItems.contains(currentPuzzle.rewardText)) {
        collectedItems.add(currentPuzzle.rewardText);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: themeColor,
          content: Text(
            'Collected: ${currentPuzzle.rewardText}',
            style: const TextStyle(color: Colors.white),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      if (currentPuzzleIndex < puzzles.length - 1) {
        setState(() {
          feedbackMessage = 'Correct!';
          currentPuzzleIndex++;
          answerController.clear();
          hintText = '';
        });

        await updateCurrentSession(
          status: 'in_progress',
          finalScore: 0,
        );

        startHintTimer();
      } else {
        final timeSpent = gameStartTime == null
            ? 0
            : DateTime.now().difference(gameStartTime!).inSeconds;

        final difficultyBonus =
            scoreService.getDifficultyBonus(puzzles.length);

        final finalScore = scoreService.calculateScore(
          timeSpent: timeSpent,
          hintsUsed: hintsUsed,
          wrongAttempts: wrongAttempts,
          difficultyBonus: difficultyBonus,
        );

        setState(() {
          feedbackMessage =
              'You completed all puzzles! Final Score: $finalScore';
          answerController.clear();
          hintText = '';
        });

        await updateCurrentSession(
          status: 'completed',
          finalScore: finalScore,
        );

        hintTimer?.cancel();

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ProgressScreen(
              playerName: widget.playerName,
            ),
          ),
        );
      }
    } else {
      wrongAttempts++;

      if (currentPuzzle.theme == 'Murder Mystery' &&
          currentPuzzle.isFinalLevel == 1) {
        mysteryGuessAttemptsLeft--;

        if (mysteryGuessAttemptsLeft <= 0) {
          setState(() {
            feedbackMessage =
                'No attempts left. The killer was Chef Marco.';
            answerController.clear();
            hintText = '';
          });

          await updateCurrentSession(
            status: 'completed',
            finalScore: 0,
          );

          hintTimer?.cancel();

          if (!mounted) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProgressScreen(
                playerName: widget.playerName,
              ),
            ),
          );
        } else {
          setState(() {
            feedbackMessage =
                'Wrong guess. You have $mysteryGuessAttemptsLeft tries left.';
          });

          await updateCurrentSession(
            status: 'in_progress',
            finalScore: 0,
          );
        }

        return;
      }

      setState(() {
        feedbackMessage = 'Wrong answer. Try again.';
      });

      await updateCurrentSession(
        status: 'in_progress',
        finalScore: 0,
      );
    }
  }

  //Unlocks hint after the player has spent enough time on the current puzzle
  void startHintTimer() {
    hintTimer?.cancel();

    setState(() {
      canUseHint = false;
      hintText = '';
    });

    hintTimer = Timer(const Duration(seconds: 60), () {
      if (mounted) {
        setState(() {
          canUseHint = true;
        });
      }
    });
  }

  //Updates the elapsed time every second so the player can see live time
  void startGameTimer() {
    gameTimer?.cancel();
    gameTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && gameStartTime != null) {
        setState(() {
          elapsedSeconds =
              DateTime.now().difference(gameStartTime!).inSeconds;
        });
      }
    });
  }

  // Displays the current puzzle hint and records hint usage for scoring
  Future<void> showHint() async {
    if (!canUseHint || puzzles.isEmpty) return;

    final currentPuzzle = puzzles[currentPuzzleIndex];
    final hint = hintService.getHint(currentPuzzle.hint);

    hintsUsed++;

    setState(() {
      hintText = hint;
      canUseHint = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: themeColor,
        content: Text(
          'Hint unlocked: $hint',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    await updateCurrentSession(
      status: 'in_progress',
      finalScore: 0,
    );
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    gameTimer?.cancel();
    answerController.dispose();
    super.dispose();
  }

  Widget buildInfoSection({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: sectionColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: child,
    );
  }

  ButtonStyle themedButtonStyle({required bool enabled}) {
    return ElevatedButton.styleFrom(
      backgroundColor: enabled ? themeColor : themeColor.withOpacity(0.35),
      foregroundColor: Colors.white,
      disabledBackgroundColor: themeColor.withOpacity(0.25),
      disabledForegroundColor: Colors.white70,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Escape Room'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (puzzles.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Escape Room'),
        ),
        body: const Center(
          child: Text('No puzzles found for this theme.'),
        ),
      );
    }

    final currentPuzzle = puzzles[currentPuzzleIndex];

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: pageBackgroundColor,
        elevation: 0,
        title: Text(
          '${widget.theme} - Level ${currentPuzzle.levelNumber}',
          style: TextStyle(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildInfoSection(
              child: Text(
                currentPuzzle.storyText,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: secondaryTextColor,
                ),
              ),
            ),
            if (widget.theme != 'Murder Mystery') ...[
              const SizedBox(height: 20),
              buildInfoSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collected Items (${collectedItems.length}/10)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (collectedItems.isEmpty)
                      Text(
                        'No items collected yet.',
                        style: TextStyle(color: secondaryTextColor),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: collectedItems.asMap().entries.map((entry) {
                          final index = entry.key + 1;
                          final item = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              '$index. $item',
                              style: TextStyle(
                                fontSize: 16,
                                color: secondaryTextColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Text(
              'Time Elapsed: $elapsedSeconds seconds',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: secondaryTextColor,
              ),
            ),
            const SizedBox(height: 12),
            if (currentPuzzle.theme == 'Murder Mystery' &&
                currentPuzzle.isFinalLevel == 1) ...[
              buildInfoSection(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clues Collected:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...murderMysteryClues.asMap().entries.map((entry) {
                      final number = entry.key + 1;
                      final clue = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '$number. $clue',
                          style: TextStyle(
                            fontSize: 16,
                            color: secondaryTextColor,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: strongSectionColor,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    Text(
                      currentPuzzle.question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'You have $mysteryGuessAttemptsLeft guesses remaining.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              PuzzleCard(
                puzzle: currentPuzzle.question,
                backgroundColor: strongSectionColor,
                borderColor: borderColor,
                textColor: primaryTextColor,
              ),
            ],
            const SizedBox(height: 20),
            TextField(
              controller: answerController,
              style: TextStyle(color: primaryTextColor),
              decoration: InputDecoration(
                labelText: 'Enter your answer',
                labelStyle: TextStyle(color: secondaryTextColor),
                filled: true,
                fillColor: isDarkMode
                    ? themeColor.withOpacity(0.10)
                    : themeColor.withOpacity(0.06),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: themeColor, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: themedButtonStyle(enabled: true),
              onPressed: checkAnswer,
              child: const Text('Submit Answer'),
            ),
            if (!(currentPuzzle.theme == 'Murder Mystery' &&
                currentPuzzle.isFinalLevel == 1)) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                style: themedButtonStyle(enabled: canUseHint),
                onPressed: canUseHint ? showHint : null,
                child: const Text('Use Hint'),
              ),
              const SizedBox(height: 12),
              if (hintText.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: sectionColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    hintText,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: secondaryTextColor,
                    ),
                  ),
                ),
              if (hintText.isNotEmpty) ...[
                const SizedBox(height: 12),
                ElevatedButton(
                  style: themedButtonStyle(enabled: true),
                  onPressed: () {
                    showHintPopup(
                      context,
                      hintText,
                      themeColor,
                    );
                  },
                  child: const Text('View Hint'),
                ),
              ],
            ],
            const SizedBox(height: 16),
            if (feedbackMessage.isNotEmpty)
              Text(
                feedbackMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: primaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ),
    );
  }
}