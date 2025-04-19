import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../shared/custom button.dart';
import 'on_boarding.dart';

class OnboardingPage extends StatelessWidget {
  final String imagePath;
  final List<TitlePart> titleParts;
  final String? subtitle;
  final String primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback onPrimaryButtonPressed;
  final VoidCallback? onSecondaryButtonPressed;

  const OnboardingPage({
    Key? key,
    required this.imagePath,
    required this.titleParts,
    this.subtitle,
    required this.primaryButtonText,
    this.secondaryButtonText,
    required this.onPrimaryButtonPressed,
    this.onSecondaryButtonPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      // padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 0.4.sh,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 32.h),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.w400,
                height: 40.sp / 32.sp,
                letterSpacing: 0,
                color: Colors.black,
              ),
              children: titleParts.map((part) {
                return TextSpan(
                  text: part.text,
                  style: part.isHighlighted
                      ? GoogleFonts.changaOne(color: const Color(0xFF0088FA),)
                      : GoogleFonts.changaOne(),
                );
              }).toList(),
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 24.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 48.h),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomButton(
              text: primaryButtonText,
              blue: true,
              onPressed: onPrimaryButtonPressed,
            ),
          ),
          if (secondaryButtonText != null) ...[
            SizedBox(height: 16.h),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomButton(
                text: secondaryButtonText!,
                blue: false,
                onPressed: onSecondaryButtonPressed ?? () {},
              ),
            ),
          ],
        ],
      ),
    );
  }
}