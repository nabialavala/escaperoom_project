class Player {
  final int? id;
  final String playerName;
  final String createdAt;

  Player({
    this.id,
    required this.playerName,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'player_name': playerName,
      'created_at': createdAt,
    };
  }
  
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'], 
      playerName: map['player_name'],
      createdAt: map['created_at'],
    );
  }
}
