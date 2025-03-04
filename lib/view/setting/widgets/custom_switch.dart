import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({super.key});

  @override
  State<CustomSwitch> createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch> {
  bool isOn = false;

  @override
  Widget build(BuildContext context) {
    final double size = 24.h;
    return GestureDetector(
      onTap: () {
        setState(() {
          isOn = !isOn;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: size * 2,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
            )
          ],
          color: isOn ? buttonColor : Color(0xFF1C4A5A)  ,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Switch thumb
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              // Move thumb left/right
              right: isOn ? 0 : size,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white ,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                      )
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
