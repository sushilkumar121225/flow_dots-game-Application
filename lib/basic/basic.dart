import 'package:flutter/material.dart';
import '../services/coin_service.dart';
import 'dart:math' as math;

// --- Models required for Level Logic ---
class PathPoint {
  final int x, y;
  PathPoint(this.x, this.y);
  @override
  bool operator ==(Object other) => other is PathPoint && x == other.x && y == other.y;
  @override
  int get hashCode => Object.hash(x, y);
}

class FlowLevel {
  final int gridSize;
  final Map<Color, List<PathPoint>> endpoints;
  FlowLevel({required this.gridSize, required this.endpoints});
}

// --- 15 Unique 4x4 Levels Logic ---
class LevelData {
  static FlowLevel getLevel(int index) {
    List<FlowLevel> levels = [
      // Level 1: Simple Vertical/Horizontal
      FlowLevel(gridSize: 4, endpoints: {
        Colors.red: [PathPoint(0, 0), PathPoint(0, 3)],
        Colors.blue: [PathPoint(1, 0), PathPoint(1, 3)],
        Colors.green: [PathPoint(2, 0), PathPoint(2, 3)],
      }),
      // Level 2: Corners
      FlowLevel(gridSize: 4, endpoints: {
        Colors.orange: [PathPoint(0, 0), PathPoint(3, 3)],
        Colors.cyan: [PathPoint(3, 0), PathPoint(0, 3)],
        Colors.purple: [PathPoint(1, 1), PathPoint(2, 2)],
      }),
      // Level 3: Zig Zag
      FlowLevel(gridSize: 4, endpoints: {
        Colors.yellow: [PathPoint(0, 0), PathPoint(2, 0)],
        Colors.blue: [PathPoint(0, 1), PathPoint(3, 1)],
        Colors.red: [PathPoint(0, 2), PathPoint(3, 2)],
        Colors.green: [PathPoint(0, 3), PathPoint(3, 3)],
      }),
      // Level 4: Perimeter
      FlowLevel(gridSize: 4, endpoints: {
        Colors.pink: [PathPoint(0, 0), PathPoint(1, 0)],
        Colors.blue: [PathPoint(2, 0), PathPoint(3, 0)],
        Colors.lime: [PathPoint(0, 3), PathPoint(3, 3)],
      }),
      // Level 5: Spiral Feel
      FlowLevel(gridSize: 4, endpoints: {
        Colors.red: [PathPoint(0, 0), PathPoint(1, 1)],
        Colors.blue: [PathPoint(3, 0), PathPoint(2, 1)],
        Colors.orange: [PathPoint(0, 3), PathPoint(1, 2)],
        Colors.green: [PathPoint(3, 3), PathPoint(2, 2)],
      }),
      // Level 6: Central Cross
      FlowLevel(gridSize: 4, endpoints: {
        Colors.cyan: [PathPoint(1, 0), PathPoint(1, 3)],
        const Color(0xFFFF00FF): [PathPoint(2, 0), PathPoint(2, 3)],
        Colors.white: [PathPoint(0, 1), PathPoint(3, 1)],
      }),
      // Level 7: Snake
      FlowLevel(gridSize: 4, endpoints: {
        Colors.indigo: [PathPoint(0, 0), PathPoint(3, 0)],
        Colors.teal: [PathPoint(0, 1), PathPoint(3, 3)],
      }),
      // Level 8: Columns
      FlowLevel(gridSize: 4, endpoints: {
        Colors.red: [PathPoint(0, 0), PathPoint(3, 0)],
        Colors.yellow: [PathPoint(0, 1), PathPoint(3, 1)],
        Colors.blue: [PathPoint(0, 2), PathPoint(3, 2)],
        Colors.green: [PathPoint(0, 3), PathPoint(3, 3)],
      }),
      // Level 9: Diagonal split
      FlowLevel(gridSize: 4, endpoints: {
        Colors.purple: [PathPoint(0, 0), PathPoint(1, 0)],
        Colors.orange: [PathPoint(0, 1), PathPoint(2, 0)],
        Colors.blue: [PathPoint(0, 2), PathPoint(3, 0)],
      }),
      // Level 10: Maze-like
      FlowLevel(gridSize: 4, endpoints: {
        Colors.pink: [PathPoint(0, 0), PathPoint(3, 1)],
        Colors.cyan: [PathPoint(0, 1), PathPoint(3, 0)],
        Colors.green: [PathPoint(1, 1), PathPoint(2, 2)],
      }),
      // Level 11: Parallel lines
      FlowLevel(gridSize: 4, endpoints: {
        Colors.red: [PathPoint(0, 0), PathPoint(0, 1)],
        Colors.blue: [PathPoint(1, 0), PathPoint(1, 1)],
        Colors.green: [PathPoint(2, 0), PathPoint(2, 1)],
        Colors.yellow: [PathPoint(3, 0), PathPoint(3, 1)],
      }),
      // Level 12: Blocks
      FlowLevel(gridSize: 4, endpoints: {
        Colors.orange: [PathPoint(0, 0), PathPoint(1, 1)],
        Colors.purple: [PathPoint(2, 2), PathPoint(3, 3)],
      }),
      // Level 13: Edge to edge
      FlowLevel(gridSize: 4, endpoints: {
        Colors.blue: [PathPoint(0, 0), PathPoint(3, 3)],
        Colors.white: [PathPoint(0, 3), PathPoint(3, 0)],
      }),
      // Level 14: Center trap
      FlowLevel(gridSize: 4, endpoints: {
        Colors.lime: [PathPoint(1, 1), PathPoint(2, 1)],
        Colors.red: [PathPoint(1, 2), PathPoint(2, 2)],
      }),
      // Level 15: Full complexity
      FlowLevel(gridSize: 4, endpoints: {
        Colors.red: [PathPoint(0, 0), PathPoint(3, 3)],
        Colors.blue: [PathPoint(1, 0), PathPoint(0, 3)],
        Colors.green: [PathPoint(2, 0), PathPoint(3, 1)],
        Colors.yellow: [PathPoint(3, 0), PathPoint(0, 1)],
      }),
    ];
    return levels[index % levels.length];
  }
}

class BasicPage extends StatelessWidget {
  const BasicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080E),
      appBar: AppBar(
        title: const Text("BASIC (4x4)",
            style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(25),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
        ),
        itemCount: 15,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => GameScreen(level: index + 1)),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.cyanAccent.withOpacity(0.5), width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.cyanAccent.withOpacity(0.1), blurRadius: 8),
                ],
              ),
              child: Center(
                child: Text("${index + 1}",
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final int level;
  const GameScreen({super.key, required this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late FlowLevel levelState;
  final Map<Color, List<PathPoint>> paths = {};
  Color? activeColor;
  bool isCompleted = false;
  int moves = 0;

  @override
  void initState() {
    super.initState();
    setupLevel();
  }

  void setupLevel() {
    levelState = LevelData.getLevel(widget.level - 1);
    paths.clear();
    for (var color in levelState.endpoints.keys) {
      paths[color] = [];
    }
    isCompleted = false;
    moves = 0;
  }

  PathPoint _getPointFromOffset(Offset localPos, double size) {
    double cellSize = size / levelState.gridSize;
    int x = (localPos.dx / cellSize).floor();
    int y = (localPos.dy / cellSize).floor();
    return PathPoint(x, y);
  }

  bool _isAdjacent(PathPoint p1, PathPoint p2) {
    int dx = (p1.x - p2.x).abs();
    int dy = (p1.y - p2.y).abs();
    return (dx == 1 && dy == 0) || (dx == 0 && dy == 1);
  }

  void _clearOtherPaths(PathPoint pt, Color ignoreColor) {
    for (var entry in paths.entries) {
      if (entry.key == ignoreColor) continue;
      int index = entry.value.indexOf(pt);
      if (index != -1) {
        setState(() {
          entry.value.removeRange(index, entry.value.length);
        });
      }
    }
  }

  void _onPanDown(DragDownDetails details, double size) {
    if (isCompleted) return;
    PathPoint pt = _getPointFromOffset(details.localPosition, size);
    if (pt.x < 0 || pt.x >= levelState.gridSize || pt.y < 0 || pt.y >= levelState.gridSize) return;

    for (var entry in levelState.endpoints.entries) {
      if (entry.value.contains(pt)) {
        setState(() {
          activeColor = entry.key;
          paths[activeColor!] = [pt];
          _clearOtherPaths(pt, activeColor!);
        });
        return;
      }
    }
  }

  void _onPanUpdate(DragUpdateDetails details, double size) {
    if (activeColor == null || isCompleted) return;
    PathPoint pt = _getPointFromOffset(details.localPosition, size);
    if (pt.x < 0 || pt.x >= levelState.gridSize || pt.y < 0 || pt.y >= levelState.gridSize) return;

    List<PathPoint> path = paths[activeColor!]!;
    if (path.isEmpty) return;
    PathPoint lastPoint = path.last;

    if (_isAdjacent(lastPoint, pt)) {
      if (path.length > 1 && path[path.length - 2] == pt) {
        setState(() => path.removeLast());
        return;
      }
      if (!path.contains(pt)) {
        setState(() {
          path.add(pt);
          _clearOtherPaths(pt, activeColor!);
        });
        if (levelState.endpoints[activeColor!]!.contains(pt)) {
          setState(() => activeColor = null);
          _checkWin();
        }
      }
    }
  }

  void _checkWin() {
    bool allConnected = true;
    for (var entry in levelState.endpoints.entries) {
      List<PathPoint> path = paths[entry.key]!;
      if (path.length < 2 || !entry.value.contains(path.first) || !entry.value.contains(path.last)) {
        allConnected = false;
        break;
      }
    }

    // Also check if grid is full (optional for Flow, but good for UX)
    int filledCells = 0;
    for(var p in paths.values) filledCells += p.length;

    if (allConnected) {
      setState(() => isCompleted = true);
      showCompleteDialog();
    }
  }

  void showCompleteDialog() async {
    await CoinService.addCoins(5);
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF15151A),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("LEVEL COMPLETED", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Text("You finished in $moves moves.", style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.monetization_on, color: Colors.amber, size: 30),
                  SizedBox(width: 10),
                  Text("+5 Coins", style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: StadiumBorder()),
                  onPressed: () { Navigator.pop(context); Navigator.pop(context); },
                  child: const Text("NEXT LEVEL", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    double gridSize = screenSize * 0.85;

    return Scaffold(
      backgroundColor: const Color(0xFF08080E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildTitle(),
              const SizedBox(height: 20),
              Text("LEVEL ${widget.level}", style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Moves: $moves", style: const TextStyle(color: Colors.white54, fontSize: 16)),
              const SizedBox(height: 40),
              _buildGameBoard(gridSize),
              const SizedBox(height: 40),
              _buildBottomTools(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      text: const TextSpan(
        children: [
          TextSpan(text: "Flow", style: TextStyle(color: Color(0xFF9000FF), fontSize: 32, fontWeight: FontWeight.bold)),
          TextSpan(text: "Dots", style: TextStyle(color: Color(0xFFFF0055), fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGameBoard(double size) {
    return Center(
      child: GestureDetector(
        onPanDown: (details) => _onPanDown(details, size),
        onPanUpdate: (details) => _onPanUpdate(details, size),
        onPanEnd: (details) => setState(() => {moves++, activeColor = null}),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white24, width: 2),
            color: Colors.white.withOpacity(0.02),
          ),
          child: CustomPaint(
            painter: FlowGridPainter(levelState: levelState, paths: paths),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomTools() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _toolButton(Icons.refresh, Colors.orange, () => setState(() => setupLevel())),
        _toolButton(Icons.lightbulb_outline, Colors.blueAccent, () {}),
        _toolButton(Icons.settings_backup_restore, Colors.redAccent, () => Navigator.pop(context)),
      ],
    );
  }

  Widget _toolButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: color.withOpacity(0.5))),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}

class FlowGridPainter extends CustomPainter {
  final FlowLevel levelState;
  final Map<Color, List<PathPoint>> paths;

  FlowGridPainter({required this.levelState, required this.paths});

  @override
  void paint(Canvas canvas, Size size) {
    int gridSize = levelState.gridSize;
    double cellSize = size.width / gridSize;

    // Draw Grid Lines
    final gridPaint = Paint()..color = Colors.white12..strokeWidth = 1.0;
    for (int i = 0; i <= gridSize; i++) {
      canvas.drawLine(Offset(i * cellSize, 0), Offset(i * cellSize, size.height), gridPaint);
      canvas.drawLine(Offset(0, i * cellSize), Offset(size.width, i * cellSize), gridPaint);
    }

    // Draw Paths
    final pathPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = cellSize * 0.35
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (var entry in paths.entries) {
      if (entry.value.length >= 2) {
        pathPaint.color = entry.key;
        Path p = Path();
        p.moveTo(entry.value[0].x * cellSize + cellSize / 2, entry.value[0].y * cellSize + cellSize / 2);
        for (int i = 1; i < entry.value.length; i++) {
          p.lineTo(entry.value[i].x * cellSize + cellSize / 2, entry.value[i].y * cellSize + cellSize / 2);
        }
        canvas.drawPath(p, pathPaint);
      }
    }

    // Draw Endpoints
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (var entry in levelState.endpoints.entries) {
      dotPaint.color = entry.key;
      for (var pt in entry.value) {
        canvas.drawCircle(Offset(pt.x * cellSize + cellSize / 2, pt.y * cellSize + cellSize / 2), cellSize * 0.35, dotPaint);
      }
    }
  }

  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}