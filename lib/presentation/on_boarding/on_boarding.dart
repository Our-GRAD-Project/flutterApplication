import 'package:baseera_app/presentation/on_boarding_survey/on_boarding_survey.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/custom button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                carouselController: _carouselController,
                items: [
                  OnboardingPage(
                    imagePath: 'assets/images/app_specific/onboarding_1.png',
                    titleParts: [
                      TitlePart(text: 'Summarize', isHighlighted: true),
                      TitlePart(text: ' Your book\nin the Best Way', isHighlighted: false),
                    ],
                    subtitle: 'Achieve your Goal By Reading The\nWorld Best Idea.',
                    primaryButtonText: 'Continue',
                    secondaryButtonText: 'Skip',
                    onPrimaryButtonPressed: () {
                      _carouselController.nextPage();
                    },
                    onSecondaryButtonPressed: () {
                      // Handle skip
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => OnboardingSurvey(),));
                    },
                  ),
                  OnboardingPage(
                    imagePath: 'assets/images/app_specific/onboarding_2.png',
                    titleParts: [
                      TitlePart(text: 'Books in ', isHighlighted: false),
                      TitlePart(text: '15 Minutes', isHighlighted: true),
                    ],
                    subtitle: 'We read the best books, highlight key ideas\nand insights, and create summaries for \nyou',
                    primaryButtonText: 'Get Started',
                    onPrimaryButtonPressed: () {
                      // Handle get started
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => OnboardingSurvey(),));
                    },
                  ),
                ],
                options: CarouselOptions(
                  height: 1.sh,
                  viewportFraction: 1.0,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                      (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 22.h,
                    width: _currentPage == index ? 64.w : 32.w,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? Color(0xff0088FA) : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Title part model for highlighting specific text
class TitlePart {
  final String text;
  final bool isHighlighted;

  TitlePart({required this.text, required this.isHighlighted});
}

// External widget to be placed in a separate file
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
                      ? TextStyle(color: const Color(0xFF0088FA))
                      : null,
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

