import 'package:flutter/material.dart';
import 'home_screen.dart';

// Shows a final summary of the player's performance after a completed run.
class SummaryScreen extends StatelessWidget {
  final int score;
  final int time;
  final int hintsUsed;
  final int wrongAttempts;

  const SummaryScreen({
    super.key,
    required this.score,
    required this.time,
    required this.hintsUsed,
    required this.wrongAttempts,
  });

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
              const Icon(Icons.emoji_events, color: Colors.white, size: 60),

              const SizedBox(height: 20),

              const Text(
                "ESCAPE COMPLETE",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 40),

              summaryItem("Score", score.toString()),
              summaryItem("Time (seconds)", time.toString()),
              summaryItem("Hints Used", hintsUsed.toString()),
              summaryItem("Wrong Attempts", wrongAttempts.toString()),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),

                  // Sends the player back to the home screen and clears old routes from the stack.
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  child: const Text(
                    "PLAY AGAIN",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable row widget for displaying summary labels and values.
  Widget summaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(color: Colors.grey, fontSize: 18)),
          Text(value,
              style: const TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }
}