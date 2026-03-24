import 'package:flutter/material.dart';

void showHintPopup(BuildContext context, String hint, Color themeColor) {
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDarkMode
              ? Colors.white24
              : themeColor.withOpacity(0.35),
        ),
      ),
      title: Text(
        'Hint',
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        hint,
        style: TextStyle(
          color: isDarkMode ? Colors.white70 : Colors.black87,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: themeColor),
          ),
        ),
      ],
    ),
  );
}