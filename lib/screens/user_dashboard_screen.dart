import 'package:flickit/screens/leaderboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> userDrills = [
    {"name": "Toe Taps", "completed": 10, "totalCount": 40},
    {"name": "Dribble", "completed": 21, "totalCount": 30},
    {"name": "Sprints", "completed": 10, "totalCount": 20},
    {"name": "Push Ups", "completed": 40, "totalCount": 50},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          "Dashboard",
          style:  TextStyle(
            color: Colors.white,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black87,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the color of the back arrow here
        ),
        titleSpacing: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.blueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: userDrills.length,
                  itemBuilder: (context, index) {
                    final drill = userDrills[index];
                    return Card(
                      color: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      elevation: 5,
                      margin:  EdgeInsets.only(bottom: 16.h),
                      child: Padding(
                        padding:  EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              drill['name'],
                              style:  TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                             SizedBox(height: 8.h),
                            Text(
                              "Completed: ${drill['completed']} / ${drill['totalCount']}",
                              style:  TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white70,
                              ),
                            ),
                             SizedBox(height: 8.h),
                            LinearProgressIndicator(
                              value: drill['completed'] / drill['totalCount'],
                              backgroundColor: Colors.white10,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                  Colors.lightBlue),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            //  Spacer(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration:  BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                ),
              ),
              child: Center(
                child: IntrinsicWidth(
                  // Ensures the button's width matches its content
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LeaderboardScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      padding:  EdgeInsets.symmetric(
                        horizontal: 16.w, // Reduced horizontal padding
                        vertical: 12.h,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Ensures content defines button size
                      children: [
                        const Icon(
                          Icons.diamond,
                          color: Colors.lightBlueAccent,
                          size: 24,
                        ),
                         SizedBox(width: 8.w),
                         Text(
                          "Leaderboard",
                          style: TextStyle(fontSize: 16.sp, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
