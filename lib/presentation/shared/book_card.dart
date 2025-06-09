import 'package:baseera_app/presentation/book_detail_screen/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookListSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> imagePaths;

  const BookListSection({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.imagePaths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        SizedBox(height: 8.h),
        _buildSectionSubtitle(subtitle),
        SizedBox(height: 16.h),
        SizedBox(
          height: 270.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (ctx) => BookDetailsScreen()),
                    );
                  },
                  child: Container(
                    width: 160.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: Colors.black.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFDF6EC),
                          Color(0xFFECE4D9),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14.r),
                      child: Stack(
                        children: [
                          Image.asset(
                            imagePaths[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.15),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
        fontFamily: "roboto",
      ),
    );
  }
}
