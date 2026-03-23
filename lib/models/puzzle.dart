class Puzzle {
  final int? id;
  final String theme;
  final int levelNumber;
  final String storyText;
  final String question;
  final String acceptedAnswers; // store as one string: answer1|answer2|answer3
  final String rewardText;
  final int isFinalLevel; // 0 = normal level, 1 = special final guess level

  Puzzle({
    this.id,
    required this.theme,
    required this.levelNumber,
    required this.storyText,
    required this.question,
    required this.acceptedAnswers,
    required this.rewardText,
    required this.isFinalLevel,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'theme': theme,
      'level_number': levelNumber,
      'story_text': storyText,
      'question': question,
      'accepted_answers': acceptedAnswers,
      'reward_text': rewardText,
      'is_final_level': isFinalLevel,
    };
  }

  factory Puzzle.fromMap(Map<String, dynamic> map) {
    return Puzzle(
      id: map['id'],
      theme: map['theme'],
      levelNumber: map['level_number'],
      storyText: map['story_text'],
      question: map['question'],
      acceptedAnswers: map['accepted_answers'],
      rewardText: map['reward_text'],
      isFinalLevel: map['is_final_level'],
    );
  }

  List<String> get acceptedAnswerList {
    return acceptedAnswers
        .split('|')
        .map((answer) => answer.trim().toLowerCase())
        .toList();
  }
}