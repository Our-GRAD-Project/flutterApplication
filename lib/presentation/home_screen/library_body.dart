import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyLibraryScreen extends StatelessWidget {
  const EmptyLibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30.h,),
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

      );
  }

}