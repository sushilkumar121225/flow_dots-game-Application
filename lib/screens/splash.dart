import 'dart:async';
import 'package:flutter/material.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  double _opacity = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _startLoading();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Important: cancel timer to avoid memory leaks
    super.dispose();
  }

  void _startAnimation() {
    // Start the fade-in effect shortly after the screen loads
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  void _startLoading() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        _progress += 0.015; // Adjusted for a smoother fill
      });

      if (_progress >= 1.0) {
        _timer?.cancel();
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          // Modern Gradient Background
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF1A1A2E), // Deep Blue/Black
              Color(0xFF0F0F1B),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo Section
            AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: _opacity,
              child: AnimatedScale(
                duration: const Duration(seconds: 1),
                scale: _opacity == 1.0 ? 1.0 : 0.8,
                child: Column(
                  children: [
                    // LOGO IMAGE
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ],
                      ),
                      child: Image.asset(
                        'images/logo.png',
                        fit: BoxFit.contain,
                        // Fallback if image isn't found during dev
                        errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.blur_on, size: 80, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "FlowDots",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Colors.purpleAccent, Colors.blueAccent],
                      ).createShader(bounds),
                      child: const Text(
                        "Link the Dots, Train Your Brain",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80),
            // Progress Indicator Section
            Column(
              children: [
                SizedBox(
                  width: 220,
                  height: 6,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _progress,
                      color: Colors.purpleAccent,
                      backgroundColor: Colors.white10,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "LOADING ${( (_progress > 1.0 ? 1.0 : _progress) * 100).toInt()}%",
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}