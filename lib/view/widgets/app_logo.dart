import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../themes/colors.dart';

class AppLogo extends StatelessWidget {
  final double logoSize;
  final String title;
  final double titleFontSize;

  const AppLogo({
    super.key,
    this.logoSize = 0.2, // Default 20% of screen width/height
    this.title = "Achieve Ai",
    this.titleFontSize = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// *** Logo ***
        SvgPicture.asset(
          'assets/svg/logo.svg',
          width: logoSize.sw,
          height: logoSize.sh,
        ),

        /// *** App Name ***
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Philosopher",
            fontSize: titleFontSize.sp,
            fontWeight: FontWeight.w700,
            color: titleColor,
          ),
        ),
      ],
    );
  }
}
