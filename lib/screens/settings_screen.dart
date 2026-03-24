import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController usernameController = TextEditingController();

  bool isDarkMode = true;
  bool soundEnabled = true;
  bool hintsEnabled = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      usernameController.text = prefs.getString('username') ?? '';
      isDarkMode = prefs.getBool('dark_mode') ?? true;
      soundEnabled = prefs.getBool('sound_enabled') ?? true;
      hintsEnabled = prefs.getBool('hints_enabled') ?? true;
      isLoading = false;
    });
  }

  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', usernameController.text.trim());
    await prefs.setBool('dark_mode', isDarkMode);
    await prefs.setBool('sound_enabled', soundEnabled);
    await prefs.setBool('hints_enabled', hintsEnabled);

    if (!mounted) return;

    await MyApp.of(context)?.updateThemeMode(isDarkMode);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully')),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Sound Enabled'),
              value: soundEnabled,
              onChanged: (value) {
                setState(() {
                  soundEnabled = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Hints Enabled'),
              value: hintsEnabled,
              onChanged: (value) {
                setState(() {
                  hintsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveSettings,
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}