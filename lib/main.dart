import 'package:baseera_app/presentation/home_screen/bottom_navigator.dart';
import 'package:baseera_app/presentation/home_screen/home_body.dart';
import 'package:baseera_app/presentation/on_boarding/on_boarding.dart';
import 'package:baseera_app/presentation/on_boarding_survey/on_boarding_survey.dart';
import 'package:baseera_app/presentation/register/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import your cubit and service files
// Add this import
import 'package:baseera_app/core/services/auth_service.dart';

import 'core/cubits/auth/auth_cubit.dart';
import 'core/cubits/auth/reset_password_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubit(AuthService()),
        ),
        // Add the ResetPasswordCubit provider here
        BlocProvider(
          create: (context) => ResetPasswordCubit(AuthService()),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(430, 932),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.changaOneTextTheme(),
            ),
            home: const OnboardingScreen(), // Default starting screen
          );
        },
      ),
    );
  }
}