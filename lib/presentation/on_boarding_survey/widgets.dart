import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


//gender card widget
Widget genderCard(String label, Image image, bool isSelected, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 181.w,
      height: 227.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? const Color(0xff0088FA) : Color(0xff444444),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          image,
          SizedBox(height: 10.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 32.sp,
              color: isSelected ? const Color(0xff0088FA) :Colors.black,
              fontWeight:  FontWeight.w400,
                fontFamily: 'Roboto'
            ),
          ),
        ],
      ),
    ),
  );
}



// for age ranges and yes or no
class AnswerOptions extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;


  const AnswerOptions({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 64.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? const Color(0xff0088FA) : Color(0xff444444),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 32.sp,
                color: isSelected ? const Color(0xff0088FA) : Colors.black,
                fontWeight: FontWeight.w400,
                fontFamily: 'roboto'
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// progress bar
class SurveyProgressBar extends StatelessWidget {
  final double progress;

  const SurveyProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Container(
            height: 15.h,
            width: double.infinity,
            color: const Color(0xffD9D9D9),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 15.h,
            width: (MediaQuery.of(context).size.width - 48.w) * progress , // Adjust subtraction if needed
            decoration: const BoxDecoration(
              color: Color(0xff0088FA),
            ),
          ),

        ],
      ),
    );
  }
}


