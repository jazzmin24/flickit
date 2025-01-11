import 'package:flutter/material.dart';

class DrillDetailPage extends StatelessWidget {
  final Map<String, dynamic> drill;

  DrillDetailPage({required this.drill});

  final TextEditingController countController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ✅ Handle potential null values to prevent crashes
    final String drillName = drill['drillName'] ?? "Unknown Drill";
    final int totalCount = drill['totalCount'] ?? 0;
    final String imageUrl = drill['picture'] ?? "";
    final String description = drill['details'] ?? "No description available.";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Custom AppBar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        drillName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // 🔹 Drill Image (Half Screen)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[800],
                                child: const Center(
                                  child: Icon(Icons.image_not_supported,
                                      color: Colors.white, size: 50),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.image_not_supported,
                                  color: Colors.white, size: 50),
                            ),
                          ),
                  ),
                ),
              ),

              // 🔹 Drill Description
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // 🔹 Drill Info & Input Field
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drillName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Total Count: $totalCount",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🔹 Input Field
                      TextField(
                        controller: countController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Completed Count",
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.black26,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide:
                                const BorderSide(color: Colors.lightBlue),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 🔹 Submit Button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (countController.text.isNotEmpty) {
                              final completedCount =
                                  int.tryParse(countController.text) ?? 0;
                              if (completedCount <= totalCount) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("✅ Count submitted successfully!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "❌ Count cannot exceed total count."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("⚠️ Please enter a valid count."),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
