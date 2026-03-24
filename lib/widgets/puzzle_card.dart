import 'package:flutter/material.dart';

// Reusable card widget for displaying the current puzzle question.
class PuzzleCard extends StatelessWidget {
  final String puzzle;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const PuzzleCard({
    super.key,
    required this.puzzle,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Gives the puzzle text its own styled panel so it stands out from the rest of the screen.
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
      ),
      child: Text(
        puzzle,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 20,
        ),
      ),
    );
  }
}