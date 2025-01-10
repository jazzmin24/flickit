import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard = [
    {"username": "JohnDoe", "totalCount": 100},
    {"username": "JaneSmith", "totalCount": 90},
    // Fetch leaderboard data from MongoDB
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Leaderboard")),
      body: ListView.builder(
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          final user = leaderboard[index];
          return ListTile(
            leading: Text("#${index + 1}"),
            title: Text(user['username']),
            trailing: Text("Total: ${user['totalCount']}"),
          );
        },
      ),
    );
  }
}
