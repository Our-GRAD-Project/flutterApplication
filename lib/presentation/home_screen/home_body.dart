import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../shared/AnimatedCategoryCard.dart';
import '../shared/book_card.dart';
import 'animation.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

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
          imagePaths: todayImages,
        ),
        SizedBox(height: 24.h),
        buildFeaturedCard(),
        SizedBox(height: 24.h),
        buildCategorySection(context),
        SizedBox(height: 24.h),
        BookListSection(
          title: 'Top Rated',
          subtitle: 'Most loved books by our clients',
          imagePaths: topRatedImages,
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

Widget buildCategorySection(BuildContext context) {
  final categories = [
    {'icon': '📈', 'title': 'Business'},
    {'icon': '🧠', 'title': 'Productivity'},
    {'icon': '🔬', 'title': 'Science'},
    {'icon': '💪', 'title': 'Health'},
    {'icon': '📖', 'title': 'Fiction'},
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Categories',
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      SizedBox(height: 16.h),
      SizedBox(
        height: 80.h,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (_, __) => SizedBox(width: 16.w),
          itemBuilder: (context, index) {
            final category = categories[index];
            final title = category['title']!;
            final icon = category['icon']!;

            return AnimatedCategoryCard(
              title: title,
              icon: icon,
              delay: Duration(milliseconds: index * 150),
            );
          },
        ),
      ),
    ],
  );
}