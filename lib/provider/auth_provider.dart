import 'dart:convert';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final String _baseUrl = "http://0.0.0.0:5001/flikit-e7b4d/us-central1";

  bool _isLoggedIn = false;
  String? _userId;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;

  /// Load login state from SharedPreferences
  Future<void> loadLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool("isLoggedIn") ?? false;
    _userId = prefs.getString("userId");
    notifyListeners();
  }

  /// Save login state in SharedPreferences
  Future<void> _saveLoginState(bool value, String? userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", value);
    await prefs.setString("userId", userId ?? "");
    _isLoggedIn = value;
    _userId = userId;
    notifyListeners();
  }

  /// Register API
  Future<bool> registerUser(String username, String password) async {
    final url = Uri.parse("$_baseUrl/register");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey("message") &&
          responseData["message"] == "Registration successful") {
        log("Registration successful: ${response.body}");
        return true;
      } else {
        log("Registration failed: ${response.body}");
        return false;
      }
    } catch (error) {
      log("Error during registration: $error");
      return false;
    }
  }

  /// Login API
  Future<bool> loginUser(String username, String password) async {
    final url = Uri.parse("$_baseUrl/login");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData.containsKey("userId")) {
        log("✅ Login successful: ${response.body}");

        // Update `_userId` first
        _userId = responseData["userId"];

        // Save login state
        await _saveLoginState(true, _userId);

        // Notify UI about state change
        notifyListeners();

        log("🔹 Saved userId: $_userId"); // Ensure userId is logged properly
        return true;
      } else {
        log("❌ Login failed: ${response.body}");
        await _saveLoginState(false, null);
        return false;
      }
    } catch (error) {
      log("❌ Error during login: $error");
      await _saveLoginState(false, null);
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _isLoggedIn = false;
    _userId = null;
    notifyListeners();
    log("User logged out");
  }
}
