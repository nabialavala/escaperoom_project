import 'package:flutter/material.dart';
import '../repositories/session_repository.dart';

class LeaderScreen extends StatefulWidget {
  const LeaderScreen({super.key});

  @override
  State<LeaderScreen> createState() => _LeaderScreenState();
}

class _LeaderScreenState extends State<LeaderScreen> {
  final SessionRepository sessionRepository = SessionRepository();

  // Stores leaderboard rows returned from the session repository.
  List<Map<String, dynamic>> leaderboard = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadLeaderboard();
  }

  // Pulls completed session scores from the database and displays them in ranking order.
  Future<void> loadLeaderboard() async {
    final data = await sessionRepository.getLeaderboard();

    setState(() {
      leaderboard = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : leaderboard.isEmpty
              ? const Center(child: Text('No scores yet.'))
              : ListView.builder(
                  itemCount: leaderboard.length,
                  itemBuilder: (context, index) {
                    final entry = leaderboard[index];

                    return ListTile(
                      leading: Text('#${index + 1}'),
                      title: Text(entry['player_name'].toString()),
                      subtitle: Text(
                        '${entry['theme']} • ${entry['time_spent']}s',
                      ),
                      trailing: Text(
                        entry['final_score'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}