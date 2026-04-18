import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Local state for toggles
  bool _soundEnabled = true;
  bool _hapticsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1B), // Matching Splash background
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        children: [
          _buildSectionHeader("Preferences"),
          _buildSettingsCard(
            children: [
              _buildSwitchTile(
                icon: Icons.volume_up_rounded,
                title: "Sound Effects",
                value: _soundEnabled,
                onChanged: (val) => setState(() => _soundEnabled = val),
              ),
              _buildDivider(),
              _buildSwitchTile(
                icon: Icons.vibration_rounded,
                title: "Haptic Feedback",
                value: _hapticsEnabled,
                onChanged: (val) => setState(() => _hapticsEnabled = val),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Data Management"),
          _buildSettingsCard(
            children: [
              _buildActionTile(
                icon: Icons.delete_forever_rounded,
                title: "Reset Progress",
                color: Colors.redAccent,
                onTap: () => _showResetDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader("Support & Info"),
          _buildSettingsCard(
            children: [
              _buildActionTile(
                icon: Icons.info_outline_rounded,
                title: "About Game",
                onTap: () => _showAboutDialog(context),
              ),
              _buildDivider(),
              _buildActionTile(
                icon: Icons.star_outline_rounded,
                title: "Rate FlowDots",
                onTap: () {}, // Implement Store Redirect
              ),
              _buildDivider(),
              _buildInfoTile(
                icon: Icons.code,
                title: "Version",
                trailing: "1.0.0",
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper: Section Headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.purpleAccent,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  // Helper: Card Container
  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(children: children),
    );
  }

  // Helper: Switch Tile
  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Switch.adaptive(
        value: value,
        activeColor: Colors.purpleAccent,
        onChanged: onChanged,
      ),
    );
  }

  // Helper: Action/Button Tile
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: onTap,
    );
  }

  // Helper: Static Info Tile
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white38),
      title: Text(title, style: const TextStyle(color: Colors.white38)),
      trailing: Text(trailing, style: const TextStyle(color: Colors.white38)),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, color: Colors.white10, indent: 55);
  }

  // --- LOGIC DIALOGS ---

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text("Reset All Progress?", style: TextStyle(color: Colors.white)),
        content: const Text(
          "This will delete all completed levels and scores. This action cannot be undone.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCEL"),
          ),
          TextButton(
            onPressed: () {
              // Add actual reset logic here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Progress Reset Successfully")),
              );
            },
            child: const Text("RESET", style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: "FlowDots",
      applicationVersion: "1.0.0",
      applicationIcon: const FlutterLogo(), // Replace with your Image.asset logo
      children: [
        const Text("FlowDots is a minimal puzzle game designed to challenge your brain. Link the colors and fill the board!"),
      ],
    );
  }
}