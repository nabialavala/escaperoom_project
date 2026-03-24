import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Controls the username text field so the saved player name can be edited.
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
  // Reads saved user preferences from SharedPreferences when the screen opens.
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
  // Saves the current username and toggle preferences so they persist between app launches.
  Future<void> saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final updatedUsername = usernameController.text.trim();

    await prefs.setString('username', updatedUsername);
    await prefs.setBool('dark_mode', isDarkMode);
    await prefs.setBool('sound_enabled', soundEnabled);
    await prefs.setBool('hints_enabled', hintsEnabled);

    if (!mounted) return;

    await MyApp.of(context)?.updateThemeMode(isDarkMode);

    if (!mounted) return;

    Navigator.pop(context, updatedUsername); // 🔥 THIS IS THE KEY
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