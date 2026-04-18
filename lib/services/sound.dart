import 'package:flutter/material.dart';
import 'dart:math' as math;

class SoundPage extends StatefulWidget {
  const SoundPage({super.key});

  @override
  State<SoundPage> createState() => _SoundPageState();
}

class _SoundPageState extends State<SoundPage> with TickerProviderStateMixin {
  bool _isSoundOn = true;
  bool _isMusicOn = true;
  bool _isHapticOn = true;
  double _volume = 0.7;

  late AnimationController _visualizerController;

  @override
  void initState() {
    super.initState();
    _visualizerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _visualizerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF08080E),
      appBar: AppBar(
        title: const Text("AUDIO SETTINGS",
            style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. VISUALIZER SECTION
            _buildVisualizerCard(),

            const SizedBox(height: 30),

            // 2. MAIN VOLUME SLIDER
            _buildVolumeSlider(),

            const SizedBox(height: 30),

            // 3. SETTINGS GROUP
            _buildSettingsToggle(
              title: "Sound Effects",
              subtitle: "In-game clicks and dots connecting",
              icon: Icons.graphic_eq_rounded,
              value: _isSoundOn,
              color: Colors.cyanAccent,
              onChanged: (val) => setState(() => _isSoundOn = val),
            ),
            const SizedBox(height: 16),
            _buildSettingsToggle(
              title: "Ambient Music",
              subtitle: "Relaxing background atmosphere",
              icon: Icons.music_note_rounded,
              value: _isMusicOn,
              color: Colors.purpleAccent,
              onChanged: (val) => setState(() => _isMusicOn = val),
            ),
            const SizedBox(height: 16),
            _buildSettingsToggle(
              title: "Haptic Feedback",
              subtitle: "Vibration on touch",
              icon: Icons.vibration_rounded,
              value: _isHapticOn,
              color: Colors.pinkAccent,
              onChanged: (val) => setState(() => _isHapticOn = val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizerCard() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isSoundOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            color: _isSoundOn ? Colors.cyanAccent : Colors.white24,
            size: 40,
          ),
          const SizedBox(height: 20),
          // Animated Bars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(15, (index) {
              return AnimatedBuilder(
                animation: _visualizerController,
                builder: (context, child) {
                  double randomHeight = _isSoundOn
                      ? (math.sin(_visualizerController.value * math.pi + index) * 30).abs() + 10
                      : 4.0;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 6,
                    height: randomHeight,
                    decoration: BoxDecoration(
                      color: _isSoundOn
                          ? Colors.cyanAccent.withOpacity(0.8)
                          : Colors.white10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildVolumeSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("MASTER VOLUME",
                style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
            Text("${(_volume * 100).toInt()}%",
                style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.cyanAccent,
            inactiveTrackColor: Colors.white10,
            thumbColor: Colors.white,
            overlayColor: Colors.cyanAccent.withOpacity(0.2),
            trackHeight: 4,
          ),
          child: Slider(
            value: _volume,
            onChanged: (val) => setState(() => _volume = val),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsToggle({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: value ? color.withOpacity(0.3) : Colors.white10,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: value ? color.withOpacity(0.1) : Colors.white10,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: value ? color : Colors.white38),
        ),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: Colors.white38, fontSize: 12)),
        trailing: Switch.adaptive(
          value: value,
          activeColor: color,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
