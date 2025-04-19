import 'package:baseera_app/presentation/home_screen/bottom_navigator.dart';
import 'package:baseera_app/presentation/on_boarding/on_boarding.dart';
import 'package:baseera_app/presentation/on_boarding_survey/on_boarding_survey.dart';
import 'package:baseera_app/presentation/register/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(430, 932),
    minTextAdapt: true,
    splitScreenMode: true,
    // Use builder only if you need to use library outside ScreenUtilInit context
    builder: (_ , child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        textTheme: GoogleFonts.changaOneTextTheme(),
      ),
      home: HomeNavigator(),
    );
  });
}
}


