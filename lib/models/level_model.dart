class LevelModel {
  final int? id;
  final int level;
  final String difficulty;
  final int completed;
  final int moves;

  LevelModel({
    this.id,
    required this.level,
    required this.difficulty,
    this.completed = 0,
    this.moves = 0,
  });

  // Convert object → Map (for DB)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'difficulty': difficulty,
      'completed': completed,
      'moves': moves,
    };
  }

  // Convert Map → object (from DB)
  factory LevelModel.fromMap(Map<String, dynamic> map) {
    return LevelModel(
      id: map['id'],
      level: map['level'],
      difficulty: map['difficulty'],
      completed: map['completed'],
      moves: map['moves'],
    );
  }
}