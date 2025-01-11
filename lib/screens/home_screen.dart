import 'dart:developer';

import 'package:flickit/provider/auth_provider.dart';
import 'package:flickit/screens/drill_detail_page.dart';
import 'package:flickit/screens/user_dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flickit/provider/drill_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void initialise() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final drillProvider = Provider.of<DrillProvider>(context, listen: false);
    log("-----------------------");
    log(authProvider.userId ?? "");
    log("-----------------------");
    drillProvider.fetchDrills(authProvider.userId ?? "");

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialise();
  }

  @override
  Widget build(BuildContext context) {
    final drillProvider = Provider.of<DrillProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Fetch drills when the screen is loade

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
                    Text(
                      "Football Drills",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        CupertinoIcons.profile_circled,
                        color: Colors.lightBlueAccent,
                        size: 40.sp,
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

                SizedBox(height: 20.h),

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
                              log('${authProvider.userId}');
                              // Navigate to Drill Detail Page
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) =>
                              //         DrillDetailPage(drill: drill),
                              //   ),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10.r,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Drill Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15.r),
                                      topRight: Radius.circular(15.r),
                                    ),
                                    child: Image.network(
                                      drill['picture'],
                                      height: 170.h,
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
                                  const Spacer(),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0.w),
                                    child: Text(
                                      drill['drillName'],
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  // Total Count
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0.w),
                                    child: Text(
                                      "Count: ${drill['totalCount']}",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
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
