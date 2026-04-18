import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/coin_service.dart';

class DailyChallengePage extends StatefulWidget {
  const DailyChallengePage({super.key});

  @override
  State<DailyChallengePage> createState() => _DailyChallengePageState();
}

class _DailyChallengePageState extends State<DailyChallengePage> with SingleTickerProviderStateMixin {
  // Simulating progress: Day 1 & 2 done, Day 3 is today.
  int currentDayLevel = 3;
  int totalDays = 15;
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  Future<void> _completeChallenge() async {
    await CoinService.addCoins(20);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.greenAccent,
          content: const Text("Challenge Completed! +20 Coins", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      );
      setState(() {
        currentDayLevel++; // Simulate moving to next day
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080E),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("DAILY CHALLENGE", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // 1. Animated Particles
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) => CustomPaint(
              painter: DailyParticlePainter(_bgController.value),
              child: Container(),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                _buildHeaderCard(),
                const SizedBox(height: 20),
                Expanded(child: _buildLevelGrid()),
                _buildPlayButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pinkAccent.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.pinkAccent.withOpacity(0.1), blurRadius: 20)
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_month, color: Colors.pinkAccent, size: 40),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("PROGRESS", style: TextStyle(color: Colors.white70, fontSize: 12)),
              Text(
                "Day $currentDayLevel of $totalDays",
                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Spacer(),
          const Text("💰 +20", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildLevelGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemCount: totalDays,
      itemBuilder: (context, index) {
        int day = index + 1;
        bool isCompleted = day < currentDayLevel;
        bool isToday = day == currentDayLevel;
        bool isLocked = day > currentDayLevel;

        Color statusColor = isCompleted
            ? Colors.greenAccent
            : (isToday ? Colors.cyanAccent : Colors.white24);

        return Container(
          decoration: BoxDecoration(
            color: isToday ? statusColor.withOpacity(0.2) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: statusColor.withOpacity(isToday ? 1 : 0.3),
              width: isToday ? 2 : 1,
            ),
            boxShadow: isToday ? [BoxShadow(color: statusColor.withOpacity(0.3), blurRadius: 10)] : [],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isLocked) const Icon(Icons.lock_outline, color: Colors.white10, size: 20),
              if (isCompleted) const Icon(Icons.check_circle, color: Colors.greenAccent, size: 40),
              if (isToday)
                Text("$day", style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 20)),
              if (!isToday && !isCompleted && !isLocked)
                Text("$day", style: const TextStyle(color: Colors.white24)),

              if (!isCompleted && !isLocked && !isToday) Text("$day"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayButton() {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: GestureDetector(
        onTap: _completeChallenge,
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Colors.pinkAccent, Colors.purpleAccent]),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(color: Colors.pinkAccent.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))
            ],
          ),
          child: const Center(
            child: Text(
              "PLAY TODAY'S CHALLENGE",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ),
        ),
      ),
    );
  }
}

class DailyParticlePainter extends CustomPainter {
  final double animationValue;
  DailyParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(100);

    for (int i = 0; i < 15; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double offset = math.sin(animationValue * math.pi * 2 + i) * 15;

      paint.color = Colors.pinkAccent.withOpacity(0.1);
      canvas.drawCircle(Offset(x, y + offset), random.nextDouble() * 3 + 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}