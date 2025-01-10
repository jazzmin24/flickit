import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userDrills = [
    {"name": "Toe Taps", "completed": 20, "totalCount": 40},
    {"name": "Dribble", "completed": 15, "totalCount": 30},
    // Fetch user data from MongoDB
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard")),
      body: ListView.builder(
        itemCount: userDrills.length,
        itemBuilder: (context, index) {
          final drill = userDrills[index];
          return ListTile(
            title: Text(drill['name']),
            subtitle: Text(
                "Completed: ${drill['completed']} / ${drill['totalCount']}"),
          );
        },
      ),
    );
  }
}
