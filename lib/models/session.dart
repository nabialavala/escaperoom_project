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

  Map<String, dynamic> toMap() {
    return{
      'id': id,
      'player_id': playerId,
      'theme': theme,
      'current_level': currentLevel,
      'time_spent': timeSpent,
      'hints_used': hintsUsed,
      'wrong_attempts': wrongAttempts,
      'status': status,
      'final_score': finalScore,
      'created_at': createdAt,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['id'],
      playerId: map['player_id'],
      theme: map['theme'],
      currentLevel: map['current_level'],
      timeSpent: map['time_spent'],
      hintsUsed: map['hints_used'],
      wrongAttempts: map['wrong_attempts'],
      status: map['status'],
      finalScore: map['final_score'],
      createdAt: map['created_at'],
    );
  }
}