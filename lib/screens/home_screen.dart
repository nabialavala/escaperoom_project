import 'package:flutter/material.dart';
import 'login_screen.dart';

// Displays a quick instruction dialog explaining the basic gameplay flow.
void showHowToPlay(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.black,
       title: const Text(
         'How to Play',
         style: TextStyle(color: Colors.white),
       ),
    
      content: const Text(
        "1. Choose a theme to begin.\n\n"
        "2. Read each puzzle carefully.\n\n"
        "3. Enter your answer and submit.\n\n"
        "4. Use hints if you're stuck.\n\n"
        "5. Solve all puzzles to escape!\n\n"
        "Your score depends on time, hints, and mistakes.",
        style: TextStyle(color: Colors.grey),
      ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Got it!',
              style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    ),
  );
}

// Main landing screen where the player starts the game or reads how to play.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             
              const Text(
                "EXPERIMENT 626: ESCAPE MISSIONS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 10),

              
              const Text(
                "Solve puzzles. Stay sharp. Escape...",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 50),

              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),

                  // Moves the player from the home screen to the login screen.
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "START GAME",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              //  OPTIONAL EXTRA BUTTON
              TextButton(
                onPressed: () {
                  showHowToPlay(context);
                },
                child: const Text(
                  "How to Play",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}