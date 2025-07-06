import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baseera_app/core/models/summary_model.dart';
import '../../core/services/jwt_decoder.dart';
import 'dart:convert';

class BookDetailsBody extends StatefulWidget {
  final Summary summary;

  const BookDetailsBody({super.key, required this.summary});

  @override
  State<BookDetailsBody> createState() => _BookDetailsBodyState();
}

class _BookDetailsBodyState extends State<BookDetailsBody> {
  bool isSaved = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserData().then((_) {
      _checkIfSaved();
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
          return book['title'] == widget.summary.title; // Using title as identifier for now
        });
      });
      print('Book "${widget.summary.title}" is saved: $isSaved'); // Debug print
    } catch (e) {
      print('Error checking if book is saved: $e');
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
        'id':widget.summary.id
      };

      if (isSaved) {
        // Remove from saved books
        savedBooks.removeWhere((bookJson) {
          final book = jsonDecode(bookJson);
          return book['title'] == widget.summary.title;
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
                          onPressed: () {
                            // download summary logic
                          },
                          icon: Icon(HugeIcons.strokeRoundedInboxDownload, size: 25.sp, color: Colors.black),
                          label: Text(
                            "Download Summary",
                            style: TextStyle(fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0x8AA19D9D),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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