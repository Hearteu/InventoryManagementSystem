import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/part.dart';

class ApiService {
  static const String baseUrl = 'https://hearteu02.com/api';

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer \$token',
    };
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('\$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await setToken(data['token']);
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Login error: \$e');
      return false;
    }
  }

  Future<List<Part>> getParts() async {
    try {
      final response = await http.get(
        Uri.parse('\$baseUrl/parts'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Part.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load parts: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the backend: \$e');
    }
  }

  Future<Part> addPart(Map<String, dynamic> partData) async {
    try {
      final response = await http.post(
        Uri.parse('\$baseUrl/parts'),
        headers: await _getHeaders(),
        body: jsonEncode(partData),
      );

      if (response.statusCode == 200) {
        return Part.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to add part: \${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: \$e');
    }
  }

  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await http.get(
        Uri.parse('\$baseUrl/dashboard/stats'),
        headers: await _getHeaders(),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load stats: \${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: \$e');
    }
  }

  Future<void> addStockMovement(String partId, String type, int quantity, String reason) async {
    try {
      final response = await http.post(
        Uri.parse('\$baseUrl/stock/movement'),
        headers: await _getHeaders(),
        body: jsonEncode({
          'part_id': partId,
          'transaction_type': type,
          'quantity': quantity,
          'reason': reason,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add movement: \${response.body}');
      }
    } catch (e) {
      throw Exception('Network error: \$e');
    }
  }
}
