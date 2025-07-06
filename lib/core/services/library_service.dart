import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/saved_library_book_model.dart';

class LibraryService {
  static const String _keyPrefix = 'saved_books_';

  // Get current user ID from token
  static Future<String?> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      try {
        // Decode JWT token - you'll need to implement this based on your JWT library
        final decoded = decodeJwt(token);
        return decoded['id'];
      } catch (e) {
        print('Error decoding token: $e');
        return null;
      }
    }
    return null;
  }

  // Save a book to library
  static Future<bool> saveBook(SavedBook book) async {
    final userId = await _getCurrentUserId();
    if (userId == null) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBooks = await getSavedBooks();

      // Check if book is already saved
      final exists = savedBooks.any((savedBook) => savedBook.id == book.id);
      if (exists) return false;

      savedBooks.add(book);
      final booksJson = savedBooks.map((book) => jsonEncode(book.toJson())).toList();

      await prefs.setStringList('$_keyPrefix$userId', booksJson);
      return true;
    } catch (e) {
      print('Error saving book: $e');
      return false;
    }
  }

  // Remove a book from library
  static Future<bool> removeBook(String bookId) async {
    final userId = await _getCurrentUserId();
    if (userId == null) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBooks = await getSavedBooks();

      savedBooks.removeWhere((book) => book.id == bookId);
      final booksJson = savedBooks.map((book) => jsonEncode(book.toJson())).toList();

      await prefs.setStringList('$_keyPrefix$userId', booksJson);
      return true;
    } catch (e) {
      print('Error removing book: $e');
      return false;
    }
  }

  // Get all saved books
  static Future<List<SavedBook>> getSavedBooks() async {
    final userId = await _getCurrentUserId();
    if (userId == null) return [];

    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = prefs.getStringList('$_keyPrefix$userId') ?? [];

      return booksJson.map((bookJson) {
        final bookMap = jsonDecode(bookJson) as Map<String, dynamic>;
        return SavedBook.fromJson(bookMap);
      }).toList();
    } catch (e) {
      print('Error getting saved books: $e');
      return [];
    }
  }

  // Check if a book is saved
  static Future<bool> isBookSaved(String bookId) async {
    final savedBooks = await getSavedBooks();
    return savedBooks.any((book) => book.id == bookId);
  }

  // Get saved books count
  static Future<int> getSavedBooksCount() async {
    final savedBooks = await getSavedBooks();
    return savedBooks.length;
  }

  // Clear all saved books (for testing or user logout)
  static Future<bool> clearAllSavedBooks() async {
    final userId = await _getCurrentUserId();
    if (userId == null) return false;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('$_keyPrefix$userId');
      return true;
    } catch (e) {
      print('Error clearing saved books: $e');
      return false;
    }
  }

  // You'll need to implement this JWT decode function based on your JWT library
  static Map<String, dynamic> decodeJwt(String token) {
    // Example implementation - replace with your actual JWT decoding logic
    // You might be using packages like dart_jsonwebtoken or jwt_decoder
    try {
      // This is a placeholder - implement based on your JWT library
      final parts = token.split('.');
      if (parts.length != 3) throw Exception('Invalid token');

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));

      return jsonDecode(decoded) as Map<String, dynamic>;
    } catch (e) {
      print('Error decoding JWT: $e');
      throw Exception('Invalid token');
    }
  }
}