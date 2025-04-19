import 'package:baseera_app/presentation/on_boarding_survey/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:baseera_app/presentation/on_boarding_survey/widgets.dart';

import '../shared/custom button.dart';
import 'helper.dart';

class OnboardingSurvey extends StatefulWidget {
  const OnboardingSurvey({super.key});

  @override
  State<OnboardingSurvey> createState() => _OnboardingSurveyState();
}

class _OnboardingSurveyState extends State<OnboardingSurvey> {
  int _currentStep = 0;
  double _progressValue = 1 / 5;
  SurveyData surveyAnswers = SurveyData();

  // Store user responses
  SurveyState? _surveyState;

  final List<String> _questions = [
    'Select your gender',
    'What is your age?',
    'Choose areas to improve',
    'What books are you interested in?',
    'Do you agree with this sentence?',
  ];

  final List<String> _subQuestions = [
    'Top once to select , tap twice to prioritize',
    'Choose at least 3 books for better \npersonalization'
  ];

  // Age ranges
  final List<String> _ageRanges = ['18-24', '25-34', '35-44', '45-54', '55+'];

  // Areas to improve
  final List<Map<String, IconData>> _areas = [
    {'Motivation': Icons.emoji_objects},
    {'Leadership': Icons.group},
    {'Planning': Icons.calendar_today},
    {'Management': Icons.business},
    {'Emotions': Icons.favorite},
    {'Habits': Icons.loop},
    {'Mindset': Icons.psychology},
  ];

  @override
  void initState() {
    _surveyState = SurveyState(surveyData: surveyAnswers);
    super.initState();
  }

  void _nextStep() {
    if (_currentStep < _questions.length - 1) {
      setState(() {
        _surveyState = SurveyState(surveyData: surveyAnswers);
        _currentStep++;
        _progressValue = (_currentStep + 1) * (1 / _questions.length);
      });
    }
    else
      {
        //temp remeber the stack
        Navigator.push(context, MaterialPageRoute(builder: (ctx)=> OnboardingSurvey()));
      }
  }

  Widget _buildGenderSelection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        genderCard(
          'Female',
          Image.asset(
            "assets/images/female.png",
          ),
          surveyAnswers.gender == 'Female',
          () => setState(() {
            surveyAnswers.gender = 'Female';
            _surveyState = SurveyState(surveyData: surveyAnswers);
          }),
        ),
        SizedBox(width: 20.w),
        genderCard(
          'Male',
          Image.asset(
            "assets/images/male.png",
          ),
          surveyAnswers.gender == 'Male',
          () => setState(() {
            surveyAnswers.gender = 'Male';
            _surveyState = SurveyState(surveyData: surveyAnswers);
          }),
        ),
      ],
    );
  }

  Widget _buildAgeSelection() {
    return Column(
      children: [
        SizedBox(height: 24.h),
        for (var range in _ageRanges) ...[
          AnswerOptions(
            text: range,
            isSelected: surveyAnswers.ageRange == range,
            onTap: () => setState(() {
              surveyAnswers.ageRange = range;
              _surveyState = SurveyState(surveyData: surveyAnswers);
            }),
          ),
          // Spacing between items
        ],
      ],
    );
  }

  Widget _buildAreasToImprove() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // First row with 2 items
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAreaItem(_areas[0].keys.first, _areas[0].values.first),
            SizedBox(width: 11.w,),
            _buildAreaItem(_areas[1].keys.first, _areas[1].values.first),
          ],
        ),

        // Second row with 3 items
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAreaItem(_areas[2].keys.first, _areas[2].values.first),
            SizedBox(width: 11.w),
                _buildAreaItem(_areas[3].keys.first, _areas[3].values.first),
            SizedBox(width: 11.w,),

            _buildAreaItem(_areas[4].keys.first, _areas[4].values.first),
          ],
        ),

        // Third row with 2 items
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAreaItem(_areas[5].keys.first, _areas[5].values.first),
            SizedBox(width: 11.w,),

            _buildAreaItem(_areas[6].keys.first, _areas[6].values.first),
          ],
        ),
      ],
    );
  }

  Widget _buildAreaItem(String areaName, IconData icon) {
    bool isSelected = surveyAnswers.areasToImprove!.contains(areaName);

    return GestureDetector(
      onTap: () => setState(() {
        if (isSelected) {
          surveyAnswers.areasToImprove!.remove(areaName);
        } else {
          surveyAnswers.areasToImprove!.add(areaName);
        }
        _surveyState = SurveyState(surveyData: surveyAnswers);
      }),
      child: Container(
        width: 120.h,
        height: 120.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xff0088FA) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30.sp,
              color: isSelected ? const Color(0xff0088FA) : Colors.black,
            ),
            SizedBox(height: 8.h),
            Text(
              areaName,
              style: TextStyle(
                fontSize: 16.sp,
                color: isSelected ? const Color(0xff0088FA) : Colors.black,
                fontFamily: 'roboto'
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildBookSelection() {
    List<String> bookPaths = List.generate(9, (index) => 'assets/images/temp_book.png');
    List<String> bookNames = [
      'Self Help', 'Business', 'Psychology', 'Leadership', 'Motivation',
      'Personal Growth', 'Fiction', 'Science', 'History'
    ];

    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 11.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 115.w / 200.h,
      ),
      itemCount: bookPaths.length,
      itemBuilder: (context, index) {
        String bookName = bookNames[index];
        String imagePath = bookPaths[index];
        bool isSelected = surveyAnswers.selectedBooks!.contains(bookName);

        return GestureDetector(
          onTap: () => setState(() {
            if (isSelected) {
              surveyAnswers.selectedBooks!.remove(bookName);
            } else {
              surveyAnswers.selectedBooks!.add(bookName);
            }
            _surveyState = SurveyState(surveyData: surveyAnswers);
          }),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSelected ? const Color(0xff0088FA) : Colors.transparent,
                width: 5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Image.asset(
                imagePath,
                width: 115.w,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildAgreement() {
    return Column(
      children: [
        SizedBox(
          height: 30.h,
        ),
        Text(
          "“What doesn't kill us makes us stronger”",
          style: TextStyle(
            fontSize: 32.sp,
            color: Colors.black,
            fontFamily: "roboto"
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 30.h,
        ),
        AnswerOptions(
          text: 'Yes',
          isSelected: surveyAnswers.agreementResponse == true,
          onTap: () => setState(() {
            surveyAnswers.agreementResponse = true;
            _surveyState = SurveyState(surveyData: surveyAnswers);
          }),
        ),
        AnswerOptions(
          text: 'No',
          isSelected: surveyAnswers.agreementResponse == false,
          onTap: () => setState(() {
            surveyAnswers.agreementResponse = false;
            _surveyState = SurveyState(surveyData: surveyAnswers);
          }),
        ),
      ],
    );
  }

  Widget agreementButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() {
        surveyAnswers.agreementResponse = label == 'Yes';
        _surveyState = SurveyState(surveyData: surveyAnswers);
      }),
      child: Container(
        width: 140.w,
        height: 60.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xff0088FA) : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 18.sp,
              color: isSelected ? const Color(0xff0088FA) : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicBody() {
    switch (_currentStep) {
      case 0:
        return _buildGenderSelection();
      case 1:
        return _buildAgeSelection();
      case 2:
        return _buildAreasToImprove();
      case 3:
        return _buildBookSelection();
      case 4:
        return _buildAgreement();
      default:
        return const SizedBox();
    }
  }

  Widget _buildQuestionText() {
    return Text(
      _questions[_currentStep],
      style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w400),
      textAlign: TextAlign.center,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 46.h),
              Image.asset(
                "assets/images/app_specific/book-open-svgrepo-com 1.png",
                width: 80.w,
                height: 80.h,
              ),
              SizedBox(height: 20.h),
              SurveyProgressBar(
                progress: _progressValue,
              ),
              SizedBox(height: 28.h),
              _buildQuestionText(),
              _currentStep == 2
                  ? Text(
                      _subQuestions[0],
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(),
              _currentStep == 3
                  ? Text(
                      _subQuestions[1],
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    )
                  : SizedBox(),
              Expanded(
                child: Center(
                  child: _buildDynamicBody(),
                ),
              ),
              SizedBox(
                height: 24.h,
              ),
              CustomButton(text: "Continue",onPressed: _surveyState!.isStepValid(_currentStep)
                  ? _nextStep
                  : null ,
                blue: true,

              ),

              SizedBox(height: 38.h),
            ],
          ),
        ),
      ),
    );
  }
}
