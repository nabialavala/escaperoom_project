import 'package:flutter/material.dart';
import '../models/puzzle.dart';
import '../repositories/puzzle_repository.dart';

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
  final TextEditingController answerController = TextEditingController();

  List<Puzzle> puzzles = [];
  int currentPuzzleIndex = 0;
  bool isLoading = true;
  String feedbackMessage = '';

  @override
  void initState() {
    super.initState();
    loadPuzzles();
  }

  Future<void> loadPuzzles() async {
    final loadedPuzzles =
        await puzzleRepository.getPuzzlesByTheme(widget.theme);

    setState(() {
      puzzles = loadedPuzzles;
      currentPuzzleIndex = 0;
      isLoading = false;
    });
  }

  void checkAnswer() {
    if (puzzles.isEmpty) return;

    final userAnswer = answerController.text.trim().toLowerCase();
    final correctAnswer = puzzles[currentPuzzleIndex].answer.trim().toLowerCase();

    if (userAnswer == correctAnswer) {
      setState(() {
        feedbackMessage = 'Correct!';
      });

      if (currentPuzzleIndex < puzzles.length - 1) {
        setState(() {
          currentPuzzleIndex++;
          answerController.clear();
        });
      } else {
        setState(() {
          feedbackMessage = 'You completed all puzzles!';
          answerController.clear();
        });
      }
    } else {
      setState(() {
        feedbackMessage = 'Wrong answer. Try again.';
      });
    }
  }

  @override
  void dispose() {
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