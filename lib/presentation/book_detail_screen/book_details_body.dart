import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

class BookDetailsBody extends StatelessWidget {
  const BookDetailsBody({super.key});

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Image.asset(
                    'assets/images/temp_book.png',
                    width: 150.w,
                    height: 250.h,
                    fit:BoxFit.cover,
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Swim for health in pure pools keep us...',
                        style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 25.h),
                      Text(
                        'J.K. Rowling',
                        style: TextStyle(color: Colors.blue, fontSize: 16.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        'Released: Dec 2015',
                        style: TextStyle(color: Colors.grey, fontSize: 15.sp),
                      ),
                      SizedBox(height: 40.h),
                      SizedBox(
                        height: 35,
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: Icon(HugeIcons.strokeRoundedInboxDownload, size: 25.sp, color: Colors.black),
                          label: Text(
                            "Download Summary",
                            style: TextStyle(fontSize: 14.sp, color: Colors.black,fontWeight: FontWeight.bold, fontFamily: "roboto"),
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
              _buildInfoItem('   ⭐   4.9', '6.4k reviews'),
              _buildInfoItem('5.6 MB', '    Size'),
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
                  "Swimming is good for the body because it makes it stronger and makes me look in shape. I learned to swim when I was two years old. I am very thankful that my father taught me at a young age.",
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
        Text(title, style: TextStyle( fontSize: 20.sp,)),
        SizedBox(height: 4.h),
        Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
      ],
    );
  }
}
