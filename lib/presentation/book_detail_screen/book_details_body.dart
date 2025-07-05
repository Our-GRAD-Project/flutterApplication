import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:baseera_app/core/models/summary_model.dart';

class BookDetailsBody extends StatelessWidget {
  final Summary summary;

  const BookDetailsBody({super.key, required this.summary});

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
                      summary.coverImagePath,
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
                        summary.title,
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        summary.author,
                        style: TextStyle(color: Colors.blue, fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        'Released: ${summary.createdAt}', // or a more proper format
                        style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                      ),
                      SizedBox(height: 40.h),
                      SizedBox(
                        height: 35,
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
                  summary.description,
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
