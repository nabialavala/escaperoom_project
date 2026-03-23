import 'package:flutter/material.dart';
import '../repositories/session_repository.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

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
    loadSessions();
  }

  Future<void> loadSessions() async {
    final data = await sessionRepository.getLeaderboard();

    setState(() {
      sessions = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress & Stats"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : sessions.isEmpty
              ? const Center(child: Text("No progress yet."))
              : ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final s = sessions[index];

                    return ListTile(
                      title: Text(s['player_name']),
                      subtitle: Text(
                        "${s['theme']} • Level ${s['current_level']} • ${s['time_spent']}s",
                      ),
                      trailing: Text(
                        s['final_score'].toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
    );
  }
}