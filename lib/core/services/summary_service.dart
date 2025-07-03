import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/summary_model.dart';

class SummaryService {
  static const String _baseUrl =
      'https://graduationprojectapi-production-e29d.up.railway.app/api/v1/summary';

  Future<List<Summary>> getSummaries() async {
    return _fetchSummaries('$_baseUrl/');
  }

  Future<List<Summary>> getSummariesByCategoryId(String categoryId) async {
    final url = '$_baseUrl/category/$categoryId';
    return _fetchSummaries(url);
  }

  Future<List<Summary>> _fetchSummaries(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('summaries') && data['summaries'] is List) {
          final List<dynamic> summaryList = data['summaries'];
          return summaryList
              .map((jsonItem) => Summary.fromJson(jsonItem))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load summaries: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load summaries: $e');
    }
  }
}
