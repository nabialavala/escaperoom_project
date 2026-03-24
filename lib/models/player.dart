class Player {
  final int? id;
  final String playerName;
  final String createdAt;

  Player({
    this.id,
    required this.playerName,
    required this.createdAt,
  });

  //Converts player object into a map so it can be stored in the database
  Map<String, dynamic> toMap() {
    return {
      'id': id, 
      'player_name': playerName,
      'created_at': createdAt,
    };
  }
  
  //Rebuilds player object from database row when reading saved data
  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      id: map['id'], 
      playerName: map['player_name'],
      createdAt: map['created_at'],
    );
  }
}
