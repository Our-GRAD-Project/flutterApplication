import 'dart:io';
import 'dart:convert';
import 'package:baseera_app/core/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../core/services/jwt_decoder.dart';
import '../../core/models/summary_model.dart';
import '../summary_screen/summary_screen.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  List<Map<String, dynamic>> downloadedBooks = [];
  bool isLoading = true;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      final decoded = decodeJwt(token);
      setState(() {
        userId = decoded['id'];
      });
      await _loadDownloadedBooks();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadDownloadedBooks() async {
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final downloadedBooksJson = prefs.getStringList('downloaded_books_$userId') ?? [];

    // Verify that files still exist
    List<Map<String, dynamic>> validBooks = [];
    for (String bookJson in downloadedBooksJson) {
      final book = jsonDecode(bookJson) as Map<String, dynamic>;
      final imagePath = book['localImagePath'];
      if (imagePath != null && await File(imagePath).exists()) {
        validBooks.add(book);
      }
    }

    // Update the list if some files were deleted
    if (validBooks.length != downloadedBooksJson.length) {
      final validBooksJson = validBooks.map((book) => jsonEncode(book)).toList();
      await prefs.setStringList('downloaded_books_$userId', validBooksJson);
    }

    setState(() {
      downloadedBooks = validBooks;
      isLoading = false;
    });
  }

  Future<void> _removeBook(String bookId) async {
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final downloadedBooksJson = prefs.getStringList('downloaded_books_$userId') ?? [];

    // Find the book to remove and delete its image file
    Map<String, dynamic>? bookToRemove;
    for (String bookJson in downloadedBooksJson) {
      final book = jsonDecode(bookJson) as Map<String, dynamic>;
      if (book['id'] == bookId) {
        bookToRemove = book;
        break;
      }
    }

    if (bookToRemove != null && bookToRemove['localImagePath'] != null) {
      final imageFile = File(bookToRemove['localImagePath']);
      if (await imageFile.exists()) {
        await imageFile.delete();
      }
    }

    // Remove from SharedPreferences
    downloadedBooksJson.removeWhere((bookJson) {
      final book = jsonDecode(bookJson);
      return book['id'] == bookId;
    });

    await prefs.setStringList('downloaded_books_$userId', downloadedBooksJson);

    // Update UI
    setState(() {
      downloadedBooks.removeWhere((book) => book['id'] == bookId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Book removed from downloads'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (downloadedBooks.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'Downloads',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${downloadedBooks.length} book${downloadedBooks.length != 1 ? 's' : ''} downloaded',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: downloadedBooks.length,
              itemBuilder: (context, index) {
                final book = downloadedBooks[index];
                return _buildBookCard(book);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCard(Map<String, dynamic> book) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Cover (Local Image)
          Container(
            width: 70.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: book['localImagePath'] != null
                  ? Image.file(
                File(book['localImagePath']),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.book,
                      size: 32.sp,
                      color: Colors.grey[600],
                    ),
                  );
                },
              )
                  : Container(
                color: Colors.grey[300],
                child: Icon(
                  Icons.book,
                  size: 32.sp,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Book Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book['title'] ?? 'Unknown Title',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                  book['author'] ?? 'Unknown Author',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Downloaded: ${book['downloadDate'] ?? 'Unknown'}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 6.h),
                // Offline indicator
                Row(
                  children: [
                    Icon(
                      Icons.offline_bolt,
                      size: 16.sp,
                      color: Colors.green,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Available offline',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Create offline Summary object
                          final offlineSummary = Summary(
                            id: book['id'],
                            title: book['title'] ?? 'Unknown Title',
                            author: book['author'] ?? 'Unknown Author',
                            content: book['content'] ?? 'No content available',
                            coverImagePath: book['localImagePath'] ?? '',
                            createdAt: book['createdAt'] ?? DateTime.now().toIso8601String(),
                            description: book['description'] ?? '',
                            language: book['language'] ?? '',
                            audioPath: book['audioPath'] ?? '',
                            category: Category(id: '', name: ''),
                          );

                          // Navigate to BookSummaryWidget with offline flag
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => BookSummaryWidget(
                                summary: offlineSummary,
                                isOffline: true, // Set to true for offline mode
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                        child: Text(
                          'Read Offline',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    IconButton(
                      onPressed: () {
                        _showRemoveDialog(book);
                      },
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/app_specific/download.jpg",
              width: 550.w,
              height: 550.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _showRemoveDialog(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Download'),
        content: Text('Are you sure you want to remove "${book['title']}" from your downloads? This will delete the offline content.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _removeBook(book['id']);
            },
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Helper class for downloading and storing books offline
class OfflineBookManager {
  static Future<void> downloadBook(Map<String, dynamic> bookData, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appDir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${appDir.path}/book_images');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Download and save image locally
      String? localImagePath;
      if (bookData['coverImagePath'] != null && bookData['coverImagePath'].isNotEmpty) {
        final imageFileName = '${bookData['id']}_cover.jpg';
        final imageFile = File('${downloadDir.path}/$imageFileName');

        // Download image from URL
        try {
          print('Downloading image from: ${bookData['coverImagePath']}');
          final response = await http.get(
            Uri.parse(bookData['coverImagePath']),
            headers: {
              'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            },
          );

          print('Response status: ${response.statusCode}');
          print('Response body length: ${response.bodyBytes.length}');

          if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
            await imageFile.writeAsBytes(response.bodyBytes);
            // Verify the file was written correctly
            if (await imageFile.exists() && await imageFile.length() > 0) {
              localImagePath = imageFile.path;
              print('Image downloaded successfully to: $localImagePath');
            } else {
              print('File was created but is empty');
              // Delete the empty file
              if (await imageFile.exists()) {
                await imageFile.delete();
              }
            }
          } else {
            print('Failed to download image: Status ${response.statusCode}');
          }
        } catch (e) {
          print('Error downloading image: $e');
          // Delete any partially created file
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        }
      }

      // Create offline book data
      final offlineBookData = {
        'id': bookData['id'],
        'title': bookData['title'],
        'author': bookData['author'],
        'content': bookData['content'],
        'description': bookData['description'] ?? '',
        'language': bookData['language'] ?? '',
        'audioPath': bookData['audioPath'] ?? '',
        'createdAt': bookData['createdAt'],
        'updatedAt': bookData['updatedAt'],
        'localImagePath': localImagePath,
        'downloadDate': DateTime.now().toIso8601String(),
      };

      // Save to SharedPreferences
      final downloadedBooksJson = prefs.getStringList('downloaded_books_$userId') ?? [];

      // Check if book already exists
      bool exists = false;
      for (int i = 0; i < downloadedBooksJson.length; i++) {
        final existingBook = jsonDecode(downloadedBooksJson[i]);
        if (existingBook['id'] == bookData['id']) {
          // Update existing book
          downloadedBooksJson[i] = jsonEncode(offlineBookData);
          exists = true;
          break;
        }
      }

      if (!exists) {
        downloadedBooksJson.add(jsonEncode(offlineBookData));
      }

      await prefs.setStringList('downloaded_books_$userId', downloadedBooksJson);

    } catch (e) {
      print('Error downloading book: $e');
      rethrow;
    }
  }

  // Helper method to download image from URL
  static Future<String?> downloadImageFromUrl(String imageUrl, String bookId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${appDir.path}/book_images');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final imageFileName = '${bookId}_cover.jpg';
      final imageFile = File('${downloadDir.path}/$imageFileName');

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        await imageFile.writeAsBytes(response.bodyBytes);
        return imageFile.path;
      }
    } catch (e) {
      print('Error downloading image: $e');
    }
    return null;
  }
}