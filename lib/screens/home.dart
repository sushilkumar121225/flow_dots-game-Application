import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../services/coin_service.dart';

// IMPORT ALL PAGES
import 'levelpage.dart';
import 'dailychallenge.dart';
import '../services/sound.dart';
import 'timetrial.dart';
import 'settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  int coins = 0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    loadCoins();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void loadCoins() async {
    int c = await CoinService.getCoins();
    setState(() {
      coins = c;
    });
  }

  void handleNavigation(String text) {
    Widget? page;
    switch (text) {
      case "Play": page = const LevelPage(); break;
      case "Daily Challenge": page = const DailyChallengePage(); break;
      case "Sound": page = const SoundPage(); break;
      case "Time Trial": page = const TimeTrialPage(); break;
      case "Settings": page = const SettingsPage(); break;
    }

    if (page != null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, anim, secondaryAnim) => page!,
          transitionsBuilder: (context, anim, secondaryAnim, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        ),
      ).then((_) => loadCoins());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080E),
      body: Stack(
        children: [
          // 1. ANIMATED PARTICLE BACKGROUND
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(_controller.value),
                child: Container(),
              );
            },
          ),

          // 2. MAIN UI CONTENT
          SafeArea(
            // FIXED: Added SingleChildScrollView to prevent bottom overflow
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60), // Top spacing

                    // TITLE WITH NEON GLOW
                    const Text(
                      "FlowDots",
                      style: TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 4,
                        shadows: [
                          Shadow(color: Colors.purpleAccent, blurRadius: 20),
                          Shadow(color: Colors.blueAccent, blurRadius: 40),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // COIN DISPLAY CHIP
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.amber.withOpacity(0.5)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.stars, color: Colors.amber, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "$coins",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),

                    // MENU BUTTONS WITH ICONS
                    _buildNeonButton("Play", Colors.cyanAccent, Icons.play_arrow_rounded),
                    _buildNeonButton("Daily Challenge", Colors.pinkAccent, Icons.calendar_today_rounded),
                    _buildNeonButton("Time Trial", Colors.orangeAccent, Icons.timer_outlined),
                    _buildNeonButton("Sound", Colors.blueAccent, Icons.volume_up_rounded),
                    _buildNeonButton("Settings", Colors.purpleAccent, Icons.settings_rounded),

                    const SizedBox(height: 40), // Bottom padding for scroll
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // UPDATED: Added IconData parameter
  Widget _buildNeonButton(String text, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: () => handleNavigation(text),
        child: Container(
          width: 280, // Slightly wider to accommodate icons
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: color.withOpacity(0.8), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    text.toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(color: color, blurRadius: 10),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3), size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  final double animationValue;
  ParticlePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final random = math.Random(42);

    for (int i = 0; i < 25; i++) {
      double x = random.nextDouble() * size.width;
      double y = random.nextDouble() * size.height;
      double offset = math.sin(animationValue * math.pi * 2 + i) * 20;

      final colors = [Colors.purpleAccent, Colors.blueAccent, Colors.cyanAccent];
      paint.color = colors[i % 3].withOpacity(0.15);

      canvas.drawCircle(Offset(x, y + offset), random.nextDouble() * 4 + 2, paint);
      paint.color = paint.color.withOpacity(0.02);
      canvas.drawCircle(Offset(x, y + offset), 15, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}