import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/models/summary_model.dart';

class BookSummaryWidget extends StatelessWidget {
  final Summary summary;

  const BookSummaryWidget({Key? key, required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28.sp, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          summary.title,
          style: TextStyle(
            fontSize: 18.sp,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.network(
                  summary.coverImagePath,
                  width: 180.w,
                  height: 250.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "By ${summary.author}",
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20.h),
            Divider(),
            SizedBox(height: 10.h),
            Text(
              summary.content,
              style: TextStyle(
                fontSize: 14.5.sp,
                height: 1.7,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
