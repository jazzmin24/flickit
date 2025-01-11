import 'package:flickit/screens/drill_detail_page.dart';
import 'package:flickit/screens/user_dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flickit/provider/drill_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final drillProvider = Provider.of<DrillProvider>(context, listen: false);

    // Fetch drills when the screen is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      drillProvider.fetchDrills(
          "67815edfe6306adda05d0515"); // Replace with actual userId
    });

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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AppBar-like Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Football Drills",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        CupertinoIcons.profile_circled,
                        color: Colors.lightBlueAccent,
                        size: 40,
                      ),
                      onPressed: () {
                        // Navigate to DashboardScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Drill Grid
                Expanded(
                  child: Consumer<DrillProvider>(
                    builder: (context, drillProvider, child) {
                      if (drillProvider.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (drillProvider.drills.isEmpty) {
                        return const Center(
                          child: Text(
                            "No drills available",
                            style: TextStyle(color: Colors.white70),
                          ),
                        );
                      }

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 items per row
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.8, // Adjust height for content
                        ),
                        itemCount: drillProvider.drills.length,
                        itemBuilder: (context, index) {
                          final drill = drillProvider.drills[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigate to Drill Detail Page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DrillDetailPage(drill: drill),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Drill Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    child: Image.network(
                                      drill['picture'],
                                      height: 160,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.image_not_supported,
                                          size: 100,
                                          color: Colors.white54,
                                        );
                                      },
                                    ),
                                  ),
                                  const Spacer(), // Push content to the bottom
                                  // Drill Name
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      drill['drillName'],
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  // Total Count
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      "Count: ${drill['totalCount']}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(
                                      height: 5), // Add some bottom padding
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
