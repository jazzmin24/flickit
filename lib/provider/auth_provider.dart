import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthProvider {
  final String _baseUrl = "http://127.0.0.1:5001/flikit-e7b4d/us-central1";

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
        return true;
      } else {
        // Handle error response
        print("Login failed: ${response.body}");
        return false;
      }
    } catch (error) {
      // Handle exceptions
      print("Error during login: $error");
      return false;
    }
  }
}
