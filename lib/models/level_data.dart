// It mainly defines data structures for levels and points.
// This is backend logic only
import 'package:flutter/material.dart';

class PathPoint {
  final int x;
  final int y;

  const PathPoint(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PathPoint && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  @override
  String toString() {
    return 'PathPoint($x, $y)';
  }
}

class FlowLevel {
  final int id;
  final int gridSize;
  final Map<Color, List<PathPoint>> endpoints;

  const FlowLevel({
    required this.id,
    required this.gridSize,
    required this.endpoints,
  });
}

class LevelData {
  static final List<FlowLevel> basicLevels = [
    FlowLevel(
      id: 1,
      gridSize: 4,
      endpoints: {
        Colors.redAccent: [const PathPoint(0, 0), const PathPoint(3, 3)],
        Colors.greenAccent: [const PathPoint(0, 1), const PathPoint(3, 2)],
        Colors.blueAccent: [const PathPoint(3, 0), const PathPoint(3, 1)],
      },
    ),
  ];

  static FlowLevel getLevel(int index) {
    // If we only have 1 defined, just return a default one or loop them
    if (index < basicLevels.length) {
      return basicLevels[index];
    }
    // Fallback exactly to user's first screenshot level for now
    return FlowLevel(
      id: index + 1,
      gridSize: 4,
      endpoints: {
        Colors.redAccent: [const PathPoint(0, 0), const PathPoint(3, 3)],
        Colors.greenAccent: [const PathPoint(1, 0), const PathPoint(3, 2)],
        Colors.blueAccent: [const PathPoint(3, 0), const PathPoint(3, 1)],
      },
    );
  }
}
// modified by: Sushil Raj