import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookSummaryWidget extends StatelessWidget {
  const BookSummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(  ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Image.asset(
                    "assets/images/temp_book.png",
                    width: 170.w,
                    height: 231.h,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  _getBookSummary(),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFFA19D9D),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getBookSummary() {
    return '''My favourite hobby is swimming. I like swimming because I like to go to the beach on summer days. Swimming is good for the body because it makes it stronger and makes me look in shape.

I learned to swim when I was two years old. I don't remember if I was afraid or not. I am very thankful that my father taught me at a young age.

My favourite hobby is swimming. I like swimming because I like to go to the beach on summer days. Swimming is good for the body because it makes it stronger and makes me look in shape.

I learned to swim when I was two years old. I don't remember if I was afraid or not. I am very thankful that my father taught me at a young age.

My favourite hobby is swimming. I like swimming because I like to go to the beach on summer days. Swimming is good for the body because it makes it stronger and makes me look in shape.

Swimming has many health benefits. It's a full-body workout that improves cardiovascular health and builds muscle strength without putting stress on your joints. The water provides natural resistance, making swimming an effective way to build endurance and muscle tone.

Besides the physical benefits, swimming is also excellent for mental health. The rhythmic motion of swimming can be meditative, helping to reduce stress and anxiety. Many swimmers report feeling a sense of calm and clarity after spending time in the water.

Swimming is also a life skill that can help keep you safe around water. Being comfortable in water environments opens up many recreational opportunities like snorkeling, surfing, and diving.

I try to swim at least three times a week, either at my local pool or at the beach during summer. I find that consistent swimming helps maintain my fitness level and keeps me energized throughout the week.

If you've never tried swimming or haven't swum in a while, I highly recommend giving it a try. Start with basic strokes and gradually build your confidence and technique. Swimming is a skill that, once learned, stays with you for life.
''';
  }
}