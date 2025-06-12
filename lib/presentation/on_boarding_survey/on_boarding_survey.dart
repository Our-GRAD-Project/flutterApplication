import 'package:baseera_app/presentation/home_screen/bottom_navigator.dart';
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
  double _progressValue = 1 / 8;
  SurveyData surveyAnswers = SurveyData();

  // Store user responses
  SurveyState? _surveyState;

  final List<String> _questions = [
    'Select your gender',
    'What is your age?',
    'What is your main goal in reading books?',
    'What type of content do you prefer?',
    'What skills or topics would you like to improve?',
    'What books are you interested in?',
    'Do you agree with this sentence?',
    'What time do you have available each day for reading or learning?',
  ];

  final List<String> _subQuestions = [
    'Top once to select , tap twice to prioritize',
    'Choose at least 3 books for better \npersonalization'
  ];

  // Age ranges
  final List<String> _ageRanges = ['18-24', '25-34', '35-44', '45-54', '55+'];

  // Areas to improve
  final List<Map<String, IconData>> _areas = [
    {'Personal Development': Icons.emoji_objects},
    {'Strengthening Relationships': Icons.group},
    {'Productivity Enhancement': Icons.calendar_today},
    {'Career Success': Icons.business},
    {'Confidence': Icons.star_half_sharp},
    {'Habit Improvement': Icons.loop},
    {'Building Self': Icons.psychology},
  ];

  // Content types
  final List<String> _contentTypes = [
    'Real-Life Stories',
    'Practical Steps',
    'Inspiration and Motivation'
  ];

  // Skills to improve
  final List<String> _skillsToImprove = [
    'Leadership',
    'Time Management',
    'Emotional Intelligence',
    'Critical Thinking',
    'Finance and Investment',
    'Happiness and Well-Being'
  ];

  // Available time options
  final List<String> _availableTime = [
    '5 minutes',
    '10 minutes',
    '15+ minutes'
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
      //  showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text('Survey Results'),
      //       content: SingleChildScrollView(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisSize: MainAxisSize.min,
      //           children: [
      //             Text('Gender: ${surveyAnswers.gender}'),
      //             SizedBox(height: 8),
      //             Text('Age Range: ${surveyAnswers.ageRange}'),
      //             SizedBox(height: 8),
      //             Text('Areas to Improve: ${surveyAnswers.areasToImprove?.join(", ")}'),
      //             SizedBox(height: 8),
      //             Text('Selected Books: ${surveyAnswers.selectedBooks?.join(", ")}'),
      //             SizedBox(height: 8),
      //             Text('Agreement Response: ${surveyAnswers.agreementResponse}'),
      //             SizedBox(height: 8),
      //             Text('Content Type: ${surveyAnswers.contentType}'),
      //             SizedBox(height: 8),
      //             Text('Skills to Improve: ${surveyAnswers.skillsToImprove?.join(", ")}'),
      //             SizedBox(height: 8),
      //             Text('Available Time: ${surveyAnswers.availableTime}'),
      //           ],
      //         ),
      //       ),
      //       actions: [
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text('OK'),
      //         ),
      //       ],
      //     );
      //   },
      // );
       Navigator.push(context, MaterialPageRoute(builder: (ctx) => HomeNavigator()));

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
            font: 32,
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
              size: 20.sp,
              color: isSelected ? const Color(0xff0088FA) : Colors.black,
            ),
            SizedBox(height: 8.h),
            Text(
              areaName,
              style: TextStyle(
                  fontSize: 13.sp,
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
          """What doesn't kill us makes us stronger""",
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
          font: 32,
          text: 'Yes',
          isSelected: surveyAnswers.agreementResponse == true,
          onTap: () => setState(() {
            surveyAnswers.agreementResponse = true;
            _surveyState = SurveyState(surveyData: surveyAnswers);
          }),
        ),
        AnswerOptions(
          font: 32,
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

  Widget _buildContentTypeSelection() {
    return Column(
      children: [
        SizedBox(height: 24.h),
        for (var contentType in _contentTypes) ...[
          AnswerOptions(
            font: 20,
            text: contentType,
            isSelected: surveyAnswers.contentType == contentType,
            onTap: () => setState(() {
              surveyAnswers.contentType = contentType;
              _surveyState = SurveyState(surveyData: surveyAnswers);
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildSkillsSelection() {
    return Column(
      children: [
        SizedBox(height: 24.h),
        for (var skill in _skillsToImprove) ...[
          AnswerOptions(
            font: 20,
            text: skill,
            isSelected: surveyAnswers.skillsToImprove!.contains(skill),
            onTap: () => setState(() {
              if (surveyAnswers.skillsToImprove!.contains(skill)) {
                surveyAnswers.skillsToImprove!.remove(skill);
              } else {
                surveyAnswers.skillsToImprove!.add(skill);
              }
              _surveyState = SurveyState(surveyData: surveyAnswers);
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeSelection() {
    return Column(
      children: [
        SizedBox(height: 24.h),
        for (var time in _availableTime) ...[
          AnswerOptions(
            font: 20,
            text: time,
            isSelected: surveyAnswers.availableTime == time,
            onTap: () => setState(() {
              surveyAnswers.availableTime = time;
              _surveyState = SurveyState(surveyData: surveyAnswers);
            }),
          ),
        ],
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
        return _buildContentTypeSelection();
      case 4:
        return _buildSkillsSelection();
      case 5:
        return _buildBookSelection();
      case 6:
        return _buildAgreement();
      case 7:
        return _buildTimeSelection();
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
              _currentStep == 5
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