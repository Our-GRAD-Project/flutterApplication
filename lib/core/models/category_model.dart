// models/category_model.dart

/// Represents a single category item.
///
/// This class is designed to hold the essential information for a category,
/// specifically its unique ID and name, parsed from the API response.
class Category {
  /// The unique identifier for the category (e.g., "686280021fdd74516087d1ef").
  final String id;

  /// The name of the category (e.g., "Leadership").
  final String name;

  /// Creates a new [Category] instance.
  Category({
    required this.id,
    required this.name,
  });

  /// Creates a [Category] instance from a JSON map.
  ///
  /// This factory constructor handles the conversion from a raw JSON object
  /// to a structured [Category] object. It specifically maps the "_id" key
  /// from the JSON to the [id] property of the class.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['_id'] as String,
      name: json['name'] as String,
    );
  }
}
