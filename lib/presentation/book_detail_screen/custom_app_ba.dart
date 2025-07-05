import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../notification_screen/notification_screen.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 24.w, top: 15.h, bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            "assets/images/app_specific/book-open-svgrepo-com 1.png",
            width: 100.w,
            height: 70.h,
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotificationScreen()));
                },
                icon: Icon(Icons.notifications_none, size: 35.sp, color: Colors.redAccent),
              ),
              SizedBox(width: 5.w),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.person_outline_rounded, size: 35.sp, color: const Color(0xff0088FA)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
