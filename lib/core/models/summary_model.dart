import 'category_model.dart';

/// Represents a single summary item from the API.
class Summary {
  final String id;
  final String title;
  final String author;
  final String description;
  final String content;
  final String language;
  final String coverImagePath;
  final String audioPath;
  final Category category;
  final  String createdAt;
  Summary({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.content,
    required this.language,
    required this.coverImagePath,
    required this.audioPath,
    required this.category,
    required this.createdAt,
  });

  /// Parses JSON to create a Summary instance.
  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      id: json['_id'] as String,
      title: json['title'] as String,
      createdAt: json['createdAt'] as String,
      author: json['author'] as String,
      description: json['description'] as String,
      content: json['content'] as String,
      language: json['language'] as String,
      coverImagePath: json['coverImage']['path'] as String,
      audioPath: json['audio']['path'] as String,
      category: Category.fromJson(json['category_id']),
    );
  }
}
