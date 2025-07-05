import 'package:baseera_app/presentation/register/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/jwt_decoder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      final decoded = decodeJwt(token);
      setState(() {
        userName = decoded['userName'] ?? 'Unknown User';
        isLoading = false;
      });
    } else {
      setState(() {
        userName = 'Unknown User';
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(top: 10), // push AppBar down by 10px
          child: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, size: 35.sp),
            ),
            title: Text(
              "Profile",
              style: TextStyle(fontSize: 24.sp),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Profile Header
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.r,
                    backgroundImage: AssetImage("assets/images/male.png"),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName!,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "+20 1018930499",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.edit,
                    size: 24.sp,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),

            // Menu Items
            Expanded(
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.settings,
                    title: "Settings",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.star_border,
                    title: "Rate Us",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.share,
                    title: "Share the App",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: "About Us",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.contact_support_outlined,
                    title: "Contact Us",
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: "Logout",
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=>SignInScreen()));
                    },
                    isLogout: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Column(
      children: [

        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 26.h),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 24.sp,
                  color: isLogout ? Colors.blue : Colors.black,
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: isLogout ? Colors.blue : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 24.sp,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        Container(
          width: 389.w,
          height: 1.h,
          color: Colors.black,
        ),
      ],
    );
  }
}