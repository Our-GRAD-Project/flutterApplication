import 'package:baseera_app/presentation/on_boarding/widget.dart';
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



