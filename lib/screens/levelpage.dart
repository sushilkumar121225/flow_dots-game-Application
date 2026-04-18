import 'package:flutter/material.dart';
import '../basic/basic.dart'; // Ensure you have created this file

class LevelPage extends StatelessWidget {
  const LevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080E), // Deep Cyberpunk Background
      appBar: AppBar(
        title: const Text(
          "SELECT DIFFICULTY",
          style: TextStyle(letterSpacing: 3, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCategoryButton(
                context,
                title: "BASIC",
                subtitle: "4 x 4 Grid",
                color: Colors.cyanAccent,
                icon: Icons.grid_view_rounded,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BasicPage()),
                  );
                },
              ),
              _buildCategoryButton(
                context,
                title: "MEDIUM",
                subtitle: "5 x 5 Grid",
                color: Colors.purpleAccent,
                icon: Icons.grid_4x4_rounded,
                onTap: () {
                  // Navigate to MediumPage()
                },
              ),
              _buildCategoryButton(
                context,
                title: "ADVANCED",
                subtitle: "6 x 6 Grid",
                color: Colors.pinkAccent,
                icon: Icons.grid_on_rounded,
                onTap: () {
                  // Navigate to AdvancedPage()
                },
              ),
              _buildCategoryButton(
                context,
                title: "EXPERT",
                subtitle: "8 x 8 Grid",
                color: Colors.orangeAccent,
                icon: Icons.blur_on_rounded,
                onTap: () {
                  // Navigate to ExpertPage()
                },
              ),
              _buildCategoryButton(
                context,
                title: "MASTER",
                subtitle: "10 x 10 Grid",
                color: Colors.redAccent,
                icon: Icons.stream,
                onTap: () {
                  // Navigate to MasterPage()
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, {
        required String title,
        required String subtitle,
        required Color color,
        required IconData icon,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 90,
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.5), width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 15,
                spreadRadius: 2,
              )
            ],
          ),
          child: Stack(
            children: [
              // Decorative background icon
              Positioned(
                right: -10,
                bottom: -10,
                child: Icon(
                  icon,
                  size: 80,
                  color: color.withOpacity(0.1),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: color, size: 30),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            shadows: [
                              Shadow(color: color, blurRadius: 10),
                            ],
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: color.withOpacity(0.5),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}