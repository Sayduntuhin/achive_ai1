import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomSlideButton extends StatefulWidget {
  final VoidCallback onSlideComplete;

  const CustomSlideButton({super.key, required this.onSlideComplete});

  @override
  State<CustomSlideButton> createState() => _CustomSlideButtonState();
}

class _CustomSlideButtonState extends State<CustomSlideButton>
    with SingleTickerProviderStateMixin {
  double buttonPosition = 10.w; // Added left padding for button

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      buttonPosition += details.delta.dx;

      if (buttonPosition < 10.w) { // Maintain left padding
        buttonPosition = 10.w;
      } else if (buttonPosition > MediaQuery.of(context).size.width * 0.6) {
        buttonPosition = MediaQuery.of(context).size.width * 0.6;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (buttonPosition > MediaQuery.of(context).size.width * 0.5) {
      setState(() {
        buttonPosition = MediaQuery.of(context).size.width * 0.6;
      });
      widget.onSlideComplete();
    } else {
      setState(() {
        buttonPosition = 15.w; // Reset with left padding
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70.h,
      decoration: BoxDecoration(
        color: Color(0xFF496E7B),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// *** Centered "Let's Start" Text ***
          Align(
            alignment: Alignment.center,
            child: Text(
              "Let's Start",
              style: TextStyle(
                fontFamily: "Philosopher",
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          /// *** Right Arrows ***
          Positioned(
            right: 20.w,
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/arrow_one.svg', width: 10.w),
                SizedBox(width: 3.w),
                SvgPicture.asset('assets/svg/arrow_two.svg', width: 10.w),
                SizedBox(width: 3.w),
                SvgPicture.asset('assets/svg/arrow_three.svg', width: 10.w),
              ],
            ),
          ),

          /// *** Sliding Button with Left Padding ***
          Positioned(
            left: buttonPosition,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: buttonColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
