import 'package:flickit/screens/drill_detail_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> drills = [
    {"name": "Toe Taps", "totalCount": 40, "image": "assets/toe_taps.png"},
    {"name": "Dribble", "totalCount": 30, "image": "assets/dribble.png"},
    // Add more drills
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: ListView.builder(
        itemCount: drills.length,
        itemBuilder: (context, index) {
          final drill = drills[index];
          return ListTile(
            leading: Image.asset(drill['image']),
            title: Text(drill['name']),
            subtitle: Text("Total Count: ${drill['totalCount']}"),
            onTap: () {
              // Navigate to Drill Detail Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrillDetailPage(drill: drill),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
