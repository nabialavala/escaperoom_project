import 'package:flutter/material.dart';
import 'game_screen.dart';
import 'progress_screen.dart';
import 'leader_screen.dart';
import 'settings_screen.dart';

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              const Text(
                "Choose Your Escape",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              themeButton(
                context,
                title: "Zombie",
                icon: Icons.science,
              ),

              const SizedBox(height: 20),

              themeButton(
                context,
                title: "Murder Mystery",
                icon: Icons.search,
              ),

              const SizedBox(height: 20),

              themeButton(
                context,
                title: "Time Travel",
                icon: Icons.access_time,
              ),

              const SizedBox(height: 40),

              const Text(
                "Stats",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 20),

              statsButton(
                context,
                title: "Progress",
                icon: Icons.bar_chart,
                destination: ProgressScreen(playerName: username),
              ),

              const SizedBox(height: 15),

              statsButton(
                context,
                title: "Leaderboard",
                icon: Icons.emoji_events,
                destination: const LeaderScreen(),
              ),

              const SizedBox(height: 15),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white30),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () async {
                    final updatedUsername = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsScreen(),
                      ),
                    );

                    if (updatedUsername != null && updatedUsername is String) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ThemeScreen(username: updatedUsername),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.settings, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "Settings",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget themeButton(
    BuildContext context, {
    required String title,
    required IconData icon,
  }) {
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
              builder: (_) => GameScreen(
                theme: title,
                playerName: username,
              ),
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
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statsButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget destination,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white30),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}