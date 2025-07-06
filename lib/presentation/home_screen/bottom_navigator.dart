import 'package:baseera_app/presentation/home_screen/home_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons/hugeicons.dart';

import '../Download_screen/Download_screen.dart';
import '../notification_screen/notification_screen.dart';
import '../profile_screen/profile_screen.dart';
import 'animation.dart';
import 'library_body.dart';

class HomeNavigator extends StatefulWidget {
  const HomeNavigator({Key? key}) : super(key: key);

  @override
  State<HomeNavigator> createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  int _currentIndex = 1;
  List bodys = [DownloadScreen(), HomeBody(), LibraryScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 16.h,
            ),
            _currentIndex == 1? _buildAppBar(context): buildAppBarNotHome(),
            Divider(
              color: Color(0xffC3B9B9),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: bodys[_currentIndex]),
              ),
            ),
            _buildBottomNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Stack(
      children: [
        Container(
          width: 430.w,
          height: 109.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, -1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildBottomNavItem(
                  HugeIcons.strokeRoundedInboxDownload, 'Downloads', 0),
              buildBottomNavItem(HugeIcons.strokeRoundedHome02, 'Home', 1),
              buildBottomNavItem(
                  HugeIcons.strokeRoundedBookOpen01, 'Library', 2),
            ],
          ),
        ),

        // Improved inner shadow
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.w),
            topRight: Radius.circular(40.w),
          ),
          child: Container(
            width: 430.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(55.w),
                topRight: Radius.circular(55.w),
              ),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.1], // Adjust stops to control fade
                colors: [
                  Colors.black.withOpacity(0.15),
                  // Increased opacity for stronger shadow
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );

  }

  Widget buildBottomNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFF0088FA) : Colors.black;

    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HugeIcon(
              icon: icon,
              color: color,
              size: 35.sp,
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              style: TextStyle(
                  color: color,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: "roboto"),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildAppBarNotHome() {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            icon: Icon(
              Icons.arrow_back,
              size: 35.sp,
              color: Colors.black,
            ),
          ),
          Image.asset(
            "assets/images/app_specific/book-open-svgrepo-com 1.png",
            width: 80.w,
            height: 70.h,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 24.w, top: 5.h, bottom: 2.h),
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
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=> NotificationScreen()));
                },
                icon: Icon(
                  Icons.notifications_none,
                  size: 35.sp,
                  color: Colors.redAccent,
                  weight: 0.5,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen()));
                },
                icon: Icon(
                  Icons.person_outline_rounded,
                  size: 35.sp,
                  color: Color(0xff0088FA),
                ),
              ),
            ],
          ),
        ],
      ),
    );}
}






