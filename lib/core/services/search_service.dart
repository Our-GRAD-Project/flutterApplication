import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/summary_model.dart';

class SearchService {
  static const String baseUrl = 'https://graduationprojectapi-production-e29d.up.railway.app/api/v1';

  Future<List<Summary>> searchSummaries(String keyword) async {
    final uri = Uri.parse('$baseUrl/summary/?keywords=$keyword');

    try {
      final response = await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> summariesJson = data['summaries'] ?? [];

        return summariesJson.map((json) => Summary.fromJson(json)).toList();
      } else {
        throw Exception('Search failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search error: ${e.toString()}');
    }
  }
}
