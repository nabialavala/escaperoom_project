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

  Map<String, dynamic> toMap() {
    return{
      'id': id, 
      'theme': theme,
      'level_number': levelNumber,
      'question': question,
      'answer': answer,
    };
  }

  factory Puzzle.fromMap(Map<String, dynamic> map) {
    return Puzzle(
      id: map['id'],
      theme: map['theme'],
      levelNumber: map['level_number'],
      question: map['question'],
      answer: map['answer'],
    );
  }
}