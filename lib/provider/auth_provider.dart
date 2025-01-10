import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthProvider extends ChangeNotifier {
  final String _baseUrl = "http://127.0.0.1:5001/flikit-e7b4d/us-central1";

  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  void _setLoginState(bool value) {
    _isLoggedIn = value;
    notifyListeners(); // Notify listeners about the state change
  }

  /// Register API
  Future<bool> registerUser(String username, String password) async {
    final url = Uri.parse("$_baseUrl/register");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully registered
        print("Registration successful: ${response.body}");
        return true;
      } else {
        // Handle error response
        print("Registration failed: ${response.body}");
        return false;
      }
    } catch (error) {
      // Handle exceptions
      print("Error during registration: $error");
      return false;
    }
  }

  /// Login API
  Future<bool> loginUser(String username, String password) async {
    final url = Uri.parse("$_baseUrl/login");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        // Successfully logged in
        print("Login successful: ${response.body}");
        _setLoginState(true); // Update login state and notify listeners
        return true;
      } else {
        // Handle error response
        print("Login failed: ${response.body}");
        _setLoginState(false); // Update login state and notify listeners
        return false;
      }
    } catch (error) {
      // Handle exceptions
      print("Error during login: $error");
      _setLoginState(false); // Update login state and notify listeners
      return false;
    }
  }

  /// Logout
  void logout() {
    _setLoginState(false); // Update login state and notify listeners
    print("User logged out");
  }
}
