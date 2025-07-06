import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baseera_app/core/models/summary_model.dart';
import '../../core/services/jwt_decoder.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
// Add to pubspec.yaml: http: ^1.1.0
// import 'package:http/http.dart' as http;

class BookDetailsBody extends StatefulWidget {
  final Summary summary;

  const BookDetailsBody({super.key, required this.summary});

  @override
  State<BookDetailsBody> createState() => _BookDetailsBodyState();
}

class _BookDetailsBodyState extends State<BookDetailsBody> {
  bool isSaved = false;
  bool isDownloaded = false;
  bool isDownloading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) {
      _checkIfSaved();
      _checkIfDownloaded();
    });
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token != null) {
        final decoded = decodeJwt(token);
        setState(() {
          userId = decoded['id'];
        });
        print('User ID loaded: $userId'); // Debug print
      } else {
        print('No auth token found'); // Debug print
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _checkIfSaved() async {
    if (userId == null) {
      print('Cannot check if saved - userId is null');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBooks = prefs.getStringList('saved_books_$userId') ?? [];
      print('Found ${savedBooks.length} saved books for user $userId'); // Debug print

      setState(() {
        isSaved = savedBooks.any((bookJson) {
          final book = jsonDecode(bookJson);
          return book['id'] == widget.summary.id;
        });
      });
      print('Book "${widget.summary.title}" is saved: $isSaved'); // Debug print
    } catch (e) {
      print('Error checking if book is saved: $e');
    }
  }

  Future<void> _checkIfDownloaded() async {
    if (userId == null) {
      print('Cannot check if downloaded - userId is null');
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadedBooks = prefs.getStringList('downloaded_books_$userId') ?? [];

      setState(() {
        isDownloaded = downloadedBooks.any((bookJson) {
          final book = jsonDecode(bookJson);
          return book['id'] == widget.summary.id;
        });
      });
      print('Book "${widget.summary.title}" is downloaded: $isDownloaded'); // Debug print
    } catch (e) {
      print('Error checking if book is downloaded: $e');
    }
  }

  Future<void> _toggleSaveBook() async {
    if (userId == null) {
      print('Cannot save book - userId is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to save books')),
      );
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedBooks = prefs.getStringList('saved_books_$userId') ?? [];

      final bookData = {
        'title': widget.summary.title,
        'author': widget.summary.author,
        'coverImagePath': widget.summary.coverImagePath,
        'description': widget.summary.description,
        'createdAt': widget.summary.createdAt,
        'savedAt': DateTime.now().toIso8601String(),
        'id': widget.summary.id
      };

      if (isSaved) {
        // Remove from saved books
        savedBooks.removeWhere((bookJson) {
          final book = jsonDecode(bookJson);
          return book['id'] == widget.summary.id;
        });
        print('Book removed from library'); // Debug print
      } else {
        // Add to saved books
        savedBooks.add(jsonEncode(bookData));
        print('Book added to library'); // Debug print
      }

      await prefs.setStringList('saved_books_$userId', savedBooks);
      print('Saved ${savedBooks.length} books for user $userId'); // Debug print

      setState(() {
        isSaved = !isSaved;
      });

      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isSaved ? 'Book saved to library' : 'Book removed from library'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      print('Error toggling save book: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error saving book')),
      );
    }
  }

  Future<void> _downloadBook() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to download books')),
      );
      return;
    }

    if (isDownloaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book already downloaded')),
      );
      return;
    }

    setState(() {
      isDownloading = true;
    });

    try {
      await OfflineBookManager.downloadBook(widget.summary, userId!);

      setState(() {
        isDownloaded = true;
        isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Book downloaded successfully! Available in Downloads tab'),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      setState(() {
        isDownloading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, size: 35.sp, color: Colors.black),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150.w,
                  height: 250.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.black26, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Image.network(
                      widget.summary.coverImagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.summary.title,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        widget.summary.author,
                        style: TextStyle(color: Colors.blue, fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        'Released: ${widget.summary.createdAt}',
                        style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                      ),
                      SizedBox(height: 20.h),
                      // Download Summary Button
                      SizedBox(
                        height: 35,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isDownloading ? null : _downloadBook,
                          icon: isDownloading
                              ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                            ),
                          )
                              : Icon(
                            isDownloaded
                                ? Icons.download_done
                                : HugeIcons.strokeRoundedInboxDownload,
                            size: 25.sp,
                            color: Colors.black,
                          ),
                          label: Text(
                            isDownloading
                                ? "Downloading..."
                                : isDownloaded
                                ? "Downloaded"
                                : "Download Summary",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDownloaded
                                ? Colors.green.withOpacity(0.3)
                                : const Color(0x8AA19D9D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // Save to Library Button
                      SizedBox(
                        height: 35,
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _toggleSaveBook,
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            size: 25.sp,
                            color: isSaved ? Colors.white : Colors.black,
                          ),
                          label: Text(
                            isSaved ? "Saved to Library" : "Save to Library",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: isSaved ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSaved ? Colors.blue : const Color(0x8AA19D9D),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoItem('⭐ 4.9', '6.4k reviews'),
              _buildInfoItem('5.6 MB', 'Size'),
              _buildInfoItem('24', 'Pages'),
              _buildInfoItem('50M+', 'Downloads'),
            ],
          ),
          SizedBox(height: 30.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("About Ebook", style: TextStyle(fontSize: 25.sp)),
                SizedBox(height: 12.h),
                Text(
                  widget.summary.description,
                  style: TextStyle(fontSize: 14.sp, height: 1.6, color: Colors.grey),
                ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 20.sp)),
        SizedBox(height: 4.h),
        Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
      ],
    );
  }
}

// Helper class for downloading and storing books offline
class OfflineBookManager {
  static Future<void> downloadBook(Summary summary, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final appDir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${appDir.path}/book_images');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Download and save image locally
      String? localImagePath;
      if (summary.coverImagePath.isNotEmpty) {
        final imageFileName = '${summary.id}_cover.jpg';
        final imageFile = File('${downloadDir.path}/$imageFileName');

        // Download image from URL
        await _downloadImageFromUrl(summary.coverImagePath, imageFile);
        localImagePath = imageFile.path;
      }

      // Create offline book data
      final offlineBookData = {
        'id': summary.id,
        'title': summary.title,
        'author': summary.author,
        'content': summary.content,
        'createdAt': summary.createdAt,
        'localImagePath': localImagePath,
        'downloadDate': DateTime.now().toIso8601String(),
      };

      // Save to SharedPreferences
      final downloadedBooksJson = prefs.getStringList('downloaded_books_$userId') ?? [];

      // Check if book already exists
      bool exists = false;
      for (int i = 0; i < downloadedBooksJson.length; i++) {
        final existingBook = jsonDecode(downloadedBooksJson[i]);
        if (existingBook['id'] == summary.id) {
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

  static Future<void> _downloadImageFromUrl(String imageUrl, File imageFile) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        await imageFile.writeAsBytes(response.bodyBytes);
      } else {
        throw Exception('Failed to download image: status ${response.statusCode}');
      }
    } catch (e) {
      if (await imageFile.exists()) {
        await imageFile.delete(); // Delete empty/broken file
      }
      print('Error downloading image: $e');
      rethrow;
    }
  }

  static Future<bool> isBookDownloaded(String bookId, String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final downloadedBooksJson = prefs.getStringList('downloaded_books_$userId') ?? [];

      return downloadedBooksJson.any((bookJson) {
        final book = jsonDecode(bookJson);
        return book['id'] == bookId;
      });
    } catch (e) {
      print('Error checking if book is downloaded: $e');
      return false;
    }
  }
}