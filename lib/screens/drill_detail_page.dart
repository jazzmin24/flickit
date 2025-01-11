import 'package:flickit/provider/user_drill_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DrillDetailPage extends StatefulWidget {
  final Map<String, dynamic> drill;
  final String userId; // Pass User ID

  const DrillDetailPage({required this.drill, required this.userId, Key? key})
      : super(key: key);

  @override
  _DrillDetailPageState createState() => _DrillDetailPageState();
}

class _DrillDetailPageState extends State<DrillDetailPage> {
  final TextEditingController countController = TextEditingController();
  int completedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserDrillData();
  }

  /// Load existing progress of the user for this drill
  Future<void> _loadUserDrillData() async {
    final drillProvider =
        Provider.of<UserDrillInfoProvider>(context, listen: false);
    await drillProvider.fetchUserDrillProgress(widget.userId);

    // Find the user's progress for this drill
    var drillData = drillProvider.userDrills.firstWhere(
      (d) => d['drillId'] == widget.drill['_id'],
      orElse: () => {},
    );

    if (drillData.isNotEmpty) {
      setState(() {
        completedCount = drillData['completedCount'] ?? 0;
        countController.text = completedCount.toString();
      });
    }
  }

  /// Update the user's progress
  Future<void> _submitProgress() async {
    final drillProvider =
        Provider.of<UserDrillInfoProvider>(context, listen: false);
    int newCompletedCount = int.tryParse(countController.text) ?? 0;

    if (newCompletedCount <= widget.drill['totalCount']) {
      bool success = await drillProvider.postUserDrillProgress(
        widget.userId,
        widget.drill['_id'],
        widget.drill['drillName'],
        newCompletedCount,
        widget.drill['totalCount'],
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("✅ Progress Updated!"),
              backgroundColor: Colors.green),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("❌ Update Failed"), backgroundColor: Colors.red),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("⚠️ Count cannot exceed total"),
            backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String drillName = widget.drill['drillName'] ?? "Unknown Drill";
    final int totalCount = widget.drill['totalCount'] ?? 0;
    final String imageUrl = widget.drill['picture'] ?? "";
    final String description =
        widget.drill['details'] ?? "No description available.";

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 AppBar with Back Button
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          drillName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔹 Drill Image
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _errorImage(),
                          )
                        : _errorImage(),
                  ),
                ),

                // 🔹 Drill Description
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    description,
                    style: TextStyle(fontSize: 16.sp, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ),

                // 🔹 Drill Info & Input Field
                Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drillName,
                        style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 10.h),
                      Text("Total Count: $totalCount",
                          style: TextStyle(
                              fontSize: 16.sp, color: Colors.white70)),
                      SizedBox(height: 20.h),

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
                              borderRadius: BorderRadius.circular(15.r)),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide:
                                const BorderSide(color: Colors.blueAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.r),
                            borderSide:
                                const BorderSide(color: Colors.lightBlue),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),

                      // 🔹 Submit Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitProgress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 50.w, vertical: 15.h),
                          ),
                          child: Text("Submit",
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _errorImage() {
    return Container(
      height: 200.h,
      color: Colors.grey[800],
      child: const Center(
        child: Icon(Icons.image_not_supported, color: Colors.white, size: 50),
      ),
    );
  }
}
