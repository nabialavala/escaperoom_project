import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
import 'screens/leader_screen.dart';
import 'screens/progress_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escape Room Test',
      home: const TestMenu(),
    );
  }
}

class TestMenu extends StatelessWidget {
  const TestMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TEST MENU')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GameScreen(
                    theme: 'Zombie',
                    playerName: 'Test Player',
                  ),
                ),
              );
            },
            child: const Text('Start Game'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LeaderScreen(),
                ),
              );
            },
            child: const Text('Leaderboard'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProgressScreen(
                    playerName: 'Test Player',
                  ),
                ),
              );
            },
            child: const Text('Progress'),
          ),
        ],
      ),
    );
  }
}