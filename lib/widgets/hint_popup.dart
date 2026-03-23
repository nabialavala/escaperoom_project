import 'package:flutter/material.dart';

void showHintPopup(BuildContext context, String hint) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: Colors.black,
      title: const Text(
        "Hint",
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        hint,
        style: const TextStyle(color: Colors.grey),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Close",
            style: TextStyle(color: Colors.deepPurple),
          ),
        ),
      ],
    ),
  );
}