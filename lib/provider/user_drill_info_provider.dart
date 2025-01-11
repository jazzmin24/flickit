import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserDrillInfoProvider extends ChangeNotifier {
  final String _baseUrl = "http://0.0.0.0:5001/flikit-e7b4d/us-central1";

  List<Map<String, dynamic>> _userDrills = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get userDrills => _userDrills;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// **Load Drill Progress from API**
  Future<void> fetchUserDrillProgress(String userId) async {
    _isLoading = true;
    notifyListeners();
    
    final url = Uri.parse("$_baseUrl/getUserDrillProgress");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 200) {
        _userDrills = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        await _saveDrillProgressToLocal(_userDrills);
        log("✅ Drill progress fetched: ${response.body}");
        _errorMessage = null;
      } else {
        _errorMessage = "Failed to fetch drills. Try again.";
        log("❌ Error fetching drills: ${response.body}");
      }
    } catch (error) {
      _errorMessage = "Network error. Please check your connection.";
      log("❌ Network Error: $error");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// **Post Drill Progress to API**
  Future<bool> postUserDrillProgress(
      String userId, String drillId, String drillName, int completedCount, int totalCount) async {
    final url = Uri.parse("$_baseUrl/addUserDrillProgress");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "userId": userId,
          "drillId": drillId,
          "drillName": drillName,
          "completedCount": completedCount,
          "totalCount": totalCount,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        log("✅ Drill progress updated: ${response.body}");
        await fetchUserDrillProgress(userId); // Refresh local data
        return true;
      } else {
        log("❌ Error posting drill progress: ${response.body}");
        return false;
      }
    } catch (error) {
      log("❌ Network Error: $error");
      return false;
    }
  }

  /// **Save Drill Progress Locally**
  Future<void> _saveDrillProgressToLocal(List<Map<String, dynamic>> drills) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userDrills", jsonEncode(drills));
  }

  /// **Load Drill Progress from Local Storage**
  Future<void> loadDrillProgressFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedData = prefs.getString("userDrills");

    if (storedData != null) {
      _userDrills = List<Map<String, dynamic>>.from(jsonDecode(storedData));
      notifyListeners();
    }
  }
}
