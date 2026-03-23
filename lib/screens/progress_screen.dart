import 'package:flutter/material.dart';
import '../repositories/session_repository.dart';

class ProgressScreen extends StatefulWidget {
  final String playerName;

  const ProgressScreen({
    super.key,
    required this.playerName,
  });

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final SessionRepository sessionRepository = SessionRepository();

  List<Map<String, dynamic>> sessions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPlayerSessions();
  }

  Future<void> loadPlayerSessions() async {
    final data = await sessionRepository.getPlayerSessions(widget.playerName);

    setState(() {
      sessions = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeSessions =
        sessions.where((session) => session['status'] == 'in_progress').toList();

    final completedSessions =
        sessions.where((session) => session['status'] == 'completed').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress & Stats'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sessions.isEmpty
              ? const Center(child: Text('No stats found for this player.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.playerName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      if (activeSessions.isNotEmpty) ...[
                        const Text(
                          'Current Run',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...activeSessions.map((session) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session['theme'].toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Current Level: ${session['current_level']}'),
                                  Text('Wrong Attempts: ${session['wrong_attempts']}'),
                                  Text('Hints Used: ${session['hints_used']}'),
                                  Text('Time Elapsed: ${session['time_spent']} seconds'),
                                  Text('Status: ${session['status']}'),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                      ],

                      const Text(
                        'Completed Runs',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      if (completedSessions.isEmpty)
                        const Text('No completed runs yet.')
                      else
                        ...completedSessions.map((session) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    session['theme'].toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Level Reached: ${session['current_level']}'),
                                  Text('Wrong Attempts: ${session['wrong_attempts']}'),
                                  Text('Hints Used: ${session['hints_used']}'),
                                  Text('Time Elapsed: ${session['time_spent']} seconds'),
                                  Text('Points Earned: ${session['final_score']}'),
                                  Text('Status: ${session['status']}'),
                                ],
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
    );
  }
}