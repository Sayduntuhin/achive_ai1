import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:achive_ai/themes/colors.dart';

class UpgradedDialog extends StatefulWidget {
  const UpgradedDialog({super.key});

  @override
  State<UpgradedDialog> createState() => _UpgradedDialogState();
}

class _UpgradedDialogState extends State<UpgradedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize Animation Controller
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Scale Animation with easeOutBack curve
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );

    // Start animation after a slight delay
    Future.delayed(Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      elevation: 10,
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated SVG Icon
                ScaleTransition(
                  scale: _animation,
                  child: SvgPicture.asset(
                    'assets/svg/congress.svg',
                    height: 50.h,
                    width: 50.w,
                  ),
                ),
                SizedBox(height: 15.h),
                // Title
                Text(
                  'Upgraded MyPerfectLife',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Philosopher',
                  ),
                ),
                SizedBox(height: 10.h),
                // Message
                Text(
                  'Congratulations! You\'ve successfully upgraded to Achieve AI Pro. Enjoy enhanced features.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: textColor2,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 20.h), // Keep spacing consistent
              ],
            ),
          ),
          // Cross Button in Top-Right Corner
          Positioned(
            top: 10.h,
            right: 10.w,
            child: IconButton(
              icon: Icon(
                Icons.close,
                size: 24.sp,
                color: Colors.grey,
              ),
              onPressed: () => Navigator.pop(context), // Same action as Close button
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(), // Minimize padding
            ),
          ),
        ],
      ),
    );
  }
}