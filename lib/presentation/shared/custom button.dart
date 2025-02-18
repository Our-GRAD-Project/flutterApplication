import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool blue;
  final double height;
  final double? width;
  final double fontSize;
  final bool disabled;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.blue = true,
    this.height = 64,
    this.width = double.infinity,
    this.fontSize = 36,
    this.disabled = false,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final isBlueTheme = widget.blue;

    return SizedBox(
      width: widget.width?.w ?? double.infinity,
      height: widget.height.h,
      child: ElevatedButton(
        onPressed: widget.disabled ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isBlueTheme
              ? const Color(0xff0088FA)
              : Colors.white,
          foregroundColor: isBlueTheme
              ? Colors.white
              : const Color(0xff0088FA),
          disabledBackgroundColor: Colors.grey[300],
          disabledForegroundColor: Colors.grey[500],
          elevation: isBlueTheme ? 0 : 6, // Increased elevation for white buttons
          shadowColor: isBlueTheme ? Colors.transparent : Colors.black.withOpacity(0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: isBlueTheme
                ? BorderSide.none
                : BorderSide(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w), // Added padding for text
          child: FittedBox(
            fit: BoxFit.scaleDown, // Ensures text scales down if too large
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: widget.fontSize.sp,
                fontWeight: FontWeight.w500,
                color: widget.disabled
                    ? Colors.grey[500]
                    : (isBlueTheme ? Colors.white : const Color(0xff0088FA)),
              ),
              maxLines: 1,
              overflow: TextOverflow.visible, // Allow text to be visible
            ),
          ),
        ),
      ),
    );
  }
}

// Example usage:
// 1. Blue theme (primary) button
// CustomButton(
//   text: 'Continue',
//   onPressed: () => print('Pressed'),
//   theme: ButtonTheme.blue,
// )
//
// 2. White theme (secondary) button
// CustomButton(
//   text: 'Skip',
//   onPressed: () => print('Skipped'),
//   theme: ButtonTheme.white,
//   height: 56,
//   fontSize: 16,
// )
//
// 3. Disabled button
// CustomButton(
//   text: 'Submit',
//   onPressed: null,
//   disabled: true,
// )