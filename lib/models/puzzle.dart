class Puzzle {
  final int? id;
  final String theme;
  final int levelNumber;
  final String question;
  final String answer;

  Puzzle({
    this.id,
    required this.theme,
    required this.levelNumber,
    required this.question,
    required this.answer,
  });
}