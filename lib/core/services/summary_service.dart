import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/summary_model.dart';

class SummaryService {
  static const String _baseUrl =
      'https://graduationprojectapi-production-e29d.up.railway.app/api/v1/summary';

  // Updated to accept a page parameter
  Future<List<Summary>> getSummaries({required int page}) async {
    final url = '$_baseUrl/?page=$page';
    return _fetchSummaries(url);
  }Future<Summary> getOneSummary({required String id}) async {
    final url = '$_baseUrl/$id'; // use id in the URL
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('summary')) {
          return Summary.fromJson(data['summary']);
        } else {
          throw Exception('No summary found in response');
        }
      } else {
        throw Exception('Failed to load summary: Status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load summary: $e');
    }
  }

  // Category method left unchanged (you didn’t request any changes here)
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
