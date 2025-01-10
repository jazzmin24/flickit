import 'package:flutter/material.dart';

class DrillDetailPage extends StatelessWidget {
  final Map<String, dynamic> drill;

  DrillDetailPage({required this.drill});

  final TextEditingController countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(drill['name'])),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(drill['image']),
            SizedBox(height: 10),
            Text(
              "Drill: ${drill['name']}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text("Total Count: ${drill['totalCount']}"),
            TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Completed Count"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final completedCount = int.parse(countController.text);
                if (completedCount <= drill['totalCount']) {
                  // Save to MongoDB
                } else {
                  // Show error
                }
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
