// services/category_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart'; // Adjust the import path based on your project structure

/// A service class for handling category-related API requests.
///
/// This class encapsulates the logic for fetching data from the categories API endpoint.
///
/// Note: Ensure you have the `http` package added to your `pubspec.yaml`:
/// dependencies:
///   flutter:
///     sdk: flutter
///   http: ^1.2.1 # or latest version
class CategoryService {
  /// The base URL for the categories API.
  static const String _baseUrl =
      'https://graduationprojectapi-production-e29d.up.railway.app/api/v1/categories/';

  /// Fetches a list of all categories from the API.
  ///
  /// Makes a GET request to the API endpoint, parses the JSON response,
  /// and returns a list of [Category] objects.
  ///
  /// Throws an [Exception] if the API call fails or if the response
  /// format is unexpected.
  Future<List<Category>> getCategories() async {
    try {
      // Make the GET request to the API.
      final response = await http.get(Uri.parse(_baseUrl));

      // Check if the request was successful (status code 200).
      if (response.statusCode == 200) {
        // Decode the JSON response body.
        final Map<String, dynamic> data = json.decode(response.body);

        // The API returns a map with a 'categories' key, which holds the list.
        // We need to ensure this key exists and is a list.
        if (data.containsKey('categories') && data['categories'] is List) {
          final List<dynamic> categoryList = data['categories'];

          // Map the list of dynamic JSON objects to a list of Category objects.
          return categoryList
              .map((jsonItem) => Category.fromJson(jsonItem))
              .toList();
        } else {
          // Throw an error if the expected 'categories' key is not found.
          throw Exception('Failed to parse categories: "categories" key not found or is not a list.');
        }
      } else {
        // If the server did not return a 200 OK response, throw an error.
        throw Exception('Failed to load categories: Status code ${response.statusCode}');
      }
    } catch (e) {
      // Catch any other exceptions (e.g., network errors) and rethrow.
      throw Exception('Failed to load categories: $e');
    }
  }
}
