import 'package:baseera_app/core/models/summary_model.dart';

class SavedBook {
  final String id;
  final String title;
  final String author;
  final String coverImagePath;
  final String description;
  final String createdAt;
  final String savedAt;

  SavedBook({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImagePath,
    required this.description,
    required this.createdAt,
    required this.savedAt,
  });

  factory SavedBook.fromJson(Map<String, dynamic> json) {
    return SavedBook(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      coverImagePath: json['coverImagePath'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
      savedAt: json['savedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverImagePath': coverImagePath,
      'description': description,
      'createdAt': createdAt,
      'savedAt': savedAt,
    };
  }

  factory SavedBook.fromSummary(Summary summary) {
    return SavedBook(
      id: summary.id, // Make sure your Summary model has an id field
      title: summary.title,
      author: summary.author,
      coverImagePath: summary.coverImagePath,
      description: summary.description,
      createdAt: summary.createdAt,
      savedAt: DateTime.now().toIso8601String(),
    );
  }
}