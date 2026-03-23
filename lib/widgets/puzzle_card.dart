import 'package:flutter/material.dart';

class PuzzleCard extends StatelessWidget {
  final String puzzle;

  const PuzzleCard({super.key, required this.puzzle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        puzzle,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }
}