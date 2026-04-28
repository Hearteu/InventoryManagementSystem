import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/part.dart';

class ApiService {
  // Production API URL via Nginx
  static const String baseUrl = 'https://hearteu02.com/api';

  Future<List<Part>> getParts() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/parts'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Part.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load parts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the backend: $e');
    }
  }
}
