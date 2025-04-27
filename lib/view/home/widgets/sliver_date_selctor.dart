import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:achive_ai/themes/colors.dart';

import '../../../controller/calander_controller.dart';

class SliverDateSelectorDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double minHeight;

  SliverDateSelectorDelegate({
    required this.child,
    required this.minHeight,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent {
    final controller = Get.find<CalendarController>();
    return controller.calendarHeight.value;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: backgroundColor,
      elevation: shrinkOffset > 0 ? 2.0 : 0.0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverDateSelectorDelegate oldDelegate) {
    return oldDelegate.minHeight != minHeight || oldDelegate.child != child;
  }
}