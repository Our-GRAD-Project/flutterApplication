import 'package:baseera_app/presentation/book_detail_screen/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../shared/book_card.dart';
import 'animation.dart';


class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    List<String> todayImages = List.generate(10, (index) => 'assets/images/ss.png');
    List<String> topRatedImages = List.generate(10, (index) => 'assets/images/ss.png');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSearchBar(),
        SizedBox(height: 16.h),
        buildFeaturedCard(),
        SizedBox(height: 24.h),

        BookListSection(
          title: 'Today for you',
          subtitle: 'Similar summaries to the ones you like',
          imagePaths: List.generate(10, (index) => 'assets/images/ss.png'),
        ),


        SizedBox(height: 24.h),
        buildFeaturedCard(),

        BookListSection(
          title: 'Top Rated',
          subtitle: 'Most loved books by our clients',
          imagePaths: List.generate(10, (index) => 'assets/images/ss.png'),
        ),

        SizedBox(height: 24.h),
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



