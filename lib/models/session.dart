class Session {
  final int? id;
  final int playerId;
  final String theme;
  final int currentLevel;
  final int timeSpent;
  final int hintsUsed;
  final int wrongAttempts;
  final String status;
  final int finalScore;
  final String createdAt;

  Session({
    this.id,
    required this.playerId,
    required this.theme,
    required this.currentLevel,
    required this.timeSpent,
    required this.hintsUsed,
    required this.wrongAttempts,
    required this.status,
    required this.finalScore,
    required this.createdAt,
  });
}