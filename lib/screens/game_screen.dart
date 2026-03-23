import 'dart:async';
import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../models/session.dart';
import '../repositories/puzzle_repository.dart';
import '../repositories/session_repository.dart';
import '../services/hint_service.dart';
import '../services/score_service.dart';
import 'progress_screen.dart';

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
  bool canUseHint = false;
  String hintText = '';

  List<Puzzle> puzzles = [];
  int currentPuzzleIndex = 0;
  bool isLoading = true;
  String feedbackMessage = '';

  int wrongAttempts = 0;
  int hintsUsed = 0;
  DateTime? gameStartTime;
  int? sessionId;
  int? currentPlayerId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => loadPuzzles());
  }

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
      });
    }

    startHintTimer();
  }

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
    );

    await sessionRepository.updateSession(currentSession);
  }

  Future<void> checkAnswer() async {
    if (puzzles.isEmpty) return;

    final userAnswer = answerController.text.trim().toLowerCase();
    final correctAnswer =
        puzzles[currentPuzzleIndex].answer.trim().toLowerCase();

    if (userAnswer == correctAnswer) {
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

      setState(() {
        feedbackMessage = 'Wrong answer. Try again.';
      });

      await updateCurrentSession(
        status: 'in_progress',
        finalScore: 0,
      );
    }
  }

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

  Future<void> showHint() async {
    if (!canUseHint || puzzles.isEmpty) return;

    final answer = puzzles[currentPuzzleIndex].answer;
    final hint = hintService.getHint(answer);

    hintsUsed++;

    setState(() {
      hintText = hint;
      canUseHint = false;
    });

    await updateCurrentSession(
      status: 'in_progress',
      finalScore: 0,
    );
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    answerController.dispose();
    super.dispose();
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
      appBar: AppBar(
        title: Text('${widget.theme} - Level ${currentPuzzle.levelNumber}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              currentPuzzle.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Enter your answer',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: checkAnswer,
              child: const Text('Submit Answer'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: canUseHint ? showHint : null,
              child: const Text('Use Hint'),
            ),
            const SizedBox(height: 12),
            Text(
              hintText,
              style: const TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              feedbackMessage,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}