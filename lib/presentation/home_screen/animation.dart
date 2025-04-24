import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildFeaturedCard() {
  return Container(
    width: double.infinity,
    height: 184.h,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10.r),
    ),
    child: Stack(
      children: [
        // Animated gradient background
        _AnimatedGradientBackground(),

        // Content
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Free daily', style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),),
                    Text('Summary', style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),),
                    SizedBox(height: 5.h),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff0088FA),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 9.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      child: Text(
                        'Get it now',
                        style: TextStyle(fontSize: 14.sp),
                      ),)
                  ],
                ),
              ),
            ),

            // Animated floating books
            Expanded(
              flex: 2,
              child: Stack(
                clipBehavior: Clip.none, // Allows books to go outside bounds
                children: [
                  _FloatingBook('assets/images/temp_book.png', speed: 2.0, offset: 0.2),
                  _FloatingBook('assets/images/temp_book.png', speed: 2.5, offset: -0.1),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// Gradient animation helper
class _AnimatedGradientBackground extends StatefulWidget {
  @override
  State<_AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<_AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Color> colors = [Colors.red, Colors.blue, Colors.purple];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.lerp(colors[0], colors[0], _controller.value)!,
                Color.lerp(colors[1], colors[0], _controller.value)!,
                Color.lerp(colors[1], colors[2], _controller.value)!,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Floating book animation helper
class _FloatingBook extends StatefulWidget {
  final String assetPath;
  final double speed;
  final double offset;

  const _FloatingBook(this.assetPath, {required this.speed, required this.offset});

  @override
  State<_FloatingBook> createState() => _FloatingBookState();
}

class _FloatingBookState extends State<_FloatingBook> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: (10 / widget.speed).round()),
    )..repeat(reverse: true);

    // Random-like movement pattern
    _xAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: -15.w, end: 30.w), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 30.w, end: -15.w), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine));

    _yAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 15.h, end: 40.h), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 40.h, end: 15.h), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad));

    _rotateAnimation = Tween<double>(begin: -0.2, end: 0.2)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          right: _xAnimation.value,
          top: _yAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value + widget.offset,
            child: Image.asset(
              widget.assetPath,
              width: 90.w,
              height: 130.h,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}