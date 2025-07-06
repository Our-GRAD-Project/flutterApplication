import 'package:baseera_app/core/services/summary_service.dart';
import 'package:baseera_app/presentation/book_detail_screen/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/jwt_decoder.dart';
import 'dart:convert';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  List<Map<String, dynamic>> savedBooks = [];
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
      await _loadSavedBooks();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadSavedBooks() async {
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final savedBooksJson = prefs.getStringList('saved_books_$userId') ?? [];

    setState(() {
      savedBooks = savedBooksJson.map((bookJson) => jsonDecode(bookJson) as Map<String, dynamic>).toList();
      isLoading = false;
    });
  }

  Future<void> _removeBook(String bookId) async {
    if (userId == null) return;

    final prefs = await SharedPreferences.getInstance();
    final savedBooksJson = prefs.getStringList('saved_books_$userId') ?? [];

    savedBooksJson.removeWhere((bookJson) {
      final book = jsonDecode(bookJson);
      return book['id'] == bookId;
    });

    await prefs.setStringList('saved_books_$userId', savedBooksJson);

    setState(() {
      savedBooks.removeWhere((book) => book['id'] == bookId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Book removed from library'),
        duration: Duration(seconds: 2),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (savedBooks.isEmpty) {
      return _buildEmptyState();
    }

    // Fix: Use SingleChildScrollView with Column instead of Column with Expanded
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Text(
              'My Library',
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${savedBooks.length} book${savedBooks.length != 1 ? 's' : ''} saved',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.h),
            // Fix: Use ListView.builder with shrinkWrap and physics instead of Expanded
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: savedBooks.length,
              itemBuilder: (context, index) {
                final book = savedBooks[index];
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
          // Book Cover
          Container(
            width: 70.w,
            height: 100.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.black12, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                book['coverImagePath'] ?? '',
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
                  'Released: ${book['createdAt'] ?? 'Unknown'}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {

                            final summary = await SummaryService().getOneSummary(id: book['id']);
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => BookDetailsScreen(summary: summary),
                                ),
                              );

                          }
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
                          'Read',
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
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h),
                Image.asset(
                  "assets/images/app_specific/empty_library.png",
                  width: 240.w,
                  height: 240.h,
                ),
                SizedBox(height: 20.h),
                Text(
                  "Easy to find",
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffA19D9D),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Stories, novel, and",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Color(0xffA19D9D),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "nonfiction materials will",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "be here",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Book'),
        content: Text('Are you sure you want to remove "${book['title']}" from your library?'),
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