import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DrillProvider extends ChangeNotifier {
  final String _baseUrl =
      "http://0.0.0.0:5001/flikit-e7b4d/us-central1/getDrills";

  List<Map<String, dynamic>> _drills = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get drills => _drills;
  bool get isLoading => _isLoading;

  Future<void> fetchDrills(String userId) async {
    _isLoading = true;
    notifyListeners();
    log("Incoming---- ${userId}");
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId}),
      );

      if (response.statusCode == 200) {
        _drills = List<Map<String, dynamic>>.from(json.decode(response.body));
        log("✅ Drill data fetched successfully!");
      } else {
        log("❌ Failed to fetch drills: ${response.body}");
      }
    } catch (error) {
      log("🚨 Error fetching drills: $error");
    }

    _isLoading = false;
    notifyListeners();
  }
}
