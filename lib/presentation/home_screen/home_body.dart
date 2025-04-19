import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../summary_screen/summary_screen.dart';
import 'animation.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return   Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchBar(),
          SizedBox(height: 16.h),
          buildFeaturedCard(),
          SizedBox(height: 24.h),
          _buildSectionTitle('Today for you'),
          SizedBox(height: 8.h),
          _buildSectionSubtitle('Similar summaries to the ones you like'),
          SizedBox(height: 16.h),
          _buildHorizontalBookList(),
          SizedBox(height: 24.h),
          buildFeaturedCard(), // Duplicated as shown in the image
        ],
      );

  }
}

Widget _buildSearchBar() {
  return Container(
    height: 48.h,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(24.r),
    ),
    child: TextField(
      decoration: InputDecoration(
        hintText: 'Type title, author, keyword',
        hintStyle: TextStyle(
          fontSize: 14.sp,
          color: Colors.grey.shade600,
        ),
        prefixIcon: HugeIcon(icon: HugeIcons.strokeRoundedSearch01, color: Colors.grey.shade600),
        
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 12.h),
      ),
    ),
  );
}



Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  );
}

Widget _buildSectionSubtitle(String subtitle) {
  return Text(
    subtitle,
    style: TextStyle(
      fontSize: 18.sp,
      color: Colors.black,
      fontFamily: "roboto"
    ),
  );
}

Widget _buildHorizontalBookList() {
  List<String> bookImages = List.generate(6, (index) => 'assets/images/temp_book.png');

  return SizedBox(
    height: 200.h,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: bookImages.length,
      itemBuilder: (context, index) {
        String imagePath = bookImages[index];

        return Padding(
          padding: EdgeInsets.only(right: 12.w),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx)=> BookSummaryWidget()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.asset(
                  imagePath,
                  width: 115.w,
                  height: 200.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
