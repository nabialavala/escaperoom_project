import 'package:flutter/material.dart';
import 'game_screen.dart';

class ThemeScreen extends StatelessWidget {
  final String username;

  const ThemeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: Text("Welcome, $username"),
        backgroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Text(
              "Choose Your Escape",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            //  ZOMBIE / MAD SCIENTIST
            themeButton(
              context,
              title: "Zombie / Mad Scientist",
              icon: Icons.science,
            ),

            const SizedBox(height: 20),

            //  MURDER MYSTERY
            themeButton(
              context,
              title: "Murder Mystery Dinner",
              icon: Icons.search,
            ),

            const SizedBox(height: 20),

            //  TIME TRAVEL
            themeButton(
              context,
              title: "Time Travel",
              icon: Icons.access_time,
            ),
          ],
        ),
      ),
    );
  }

  Widget themeButton(BuildContext context,
      {required String title, required IconData icon}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[900],
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GameScreen(theme: title, playerName: username),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}