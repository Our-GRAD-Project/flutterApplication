import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/VerticalBookCard.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String categoryTitle;
  final String categoryIcon;

  const CategoryDetailScreen({
    Key? key,
    required this.categoryTitle,
    required this.categoryIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> bookImages = List.generate(8, (index) => 'assets/images/ss.png');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.9),
                Colors.blue.shade600,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 40.h, left: 15.w, right: 15.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 35.sp, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$categoryIcon $categoryTitle',
                      style: TextStyle(
                        fontSize: 25.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: GridView.builder(
          itemCount: bookImages.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 25.h,
            childAspectRatio: 0.63,
          ),
          itemBuilder: (context, index) {
            return VerticalBookCard(
              imagePath: bookImages[index],
              title: '${categoryTitle} Book ${index + 1}',
            );
          },
        ),
      ),
    );
  }
}
