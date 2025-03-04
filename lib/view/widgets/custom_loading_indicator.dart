import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../themes/colors.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final double size;

  // Constructor for customization
  const CustomLoadingIndicator({
    super.key,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.halfTriangleDot(
        color: loadingIndicatorColor,
        size: size,
      ),
    );
  }
}
