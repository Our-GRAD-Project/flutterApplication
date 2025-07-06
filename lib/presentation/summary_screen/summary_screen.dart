import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import '../../core/models/summary_model.dart';

class BookSummaryWidget extends StatelessWidget {
  final Summary summary;
  final bool isOffline; // Add this parameter to indicate offline mode

  const BookSummaryWidget({
    Key? key,
    required this.summary,
    this.isOffline = false, // Default to false for backward compatibility
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 22.sp),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          summary.title,
          style: GoogleFonts.lato(
            fontSize: 21.sp,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          if (isOffline)
            Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: Icon(
                Icons.offline_bolt,
                color: Colors.green,
                size: 24.sp,
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 20.h),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Book cover - Handle both network and file images
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(14.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: _buildBookCover(),
              ),
            ),
            SizedBox(height: 20.h),

            // Title
            Text(
              summary.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 21.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h),

            // Author tag
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFD0E8FF),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                "By ${summary.author}",
                style: TextStyle(
                  fontSize: 14.5.sp,
                  color: const Color(0xFF1565C0),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 26.h),

            // Summary content
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: _buildBeautifulText(summary.content),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCover() {
    // If offline mode and we have a local image path, use File
    if (isOffline && summary.coverImagePath.isNotEmpty) {
      return Image.file(
        File(summary.coverImagePath),
        width: 180.w,
        height: 250.h,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackCover();
        },
      );
    }

    // Otherwise, use network image
    return Image.network(
      summary.coverImagePath,
      width: 180.w,
      height: 250.h,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackCover();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: 180.w,
          height: 250.h,
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackCover() {
    return Container(
      width: 180.w,
      height: 250.h,
      color: Colors.grey[300],
      child: Icon(
        Icons.book,
        size: 64.sp,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildBeautifulText(String content) {
    final paragraphs = content
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((para) {
        return Padding(
          padding: EdgeInsets.only(bottom: 22.h),
          child: Text(
            para,
            style: GoogleFonts.merriweather(
              fontSize: 16.5.sp,
              height: 2.0,
              color: Colors.grey.shade900,
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.justify,
          ),
        );
      }).toList(),
    );
  }
}