import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/goal_controller.dart';
import '../../widgets/title_with_view_all.dart';
import '../widgets/goal_card.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({super.key});

  Widget _buildShimmerGoalCard() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[300]!,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(width: 200.w, height: 22.sp, color: Colors.white),
              SizedBox(height: 4.h),
              Container(width: double.infinity, height: 10.sp, color: Colors.white),
              SizedBox(height: 2.h),
              Container(width: 250.w, height: 10.sp, color: Colors.white),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(width: 100.w, height: 12.sp, color: Colors.white),
                  Container(width: 50.w, height: 18.sp, color: Colors.white),
                ],
              ),
              SizedBox(height: 6.h),
              Container(width: double.infinity, height: 8.h, color: Colors.white),
              SizedBox(height: 10.h),
              Container(width: 150.w, height: 12.sp, color: Colors.white),
              SizedBox(height: 5.h),
              Container(width: double.infinity, height: 1.h, color: Colors.white),
              SizedBox(height: 10.h),
              Container(width: 80.w, height: 12.sp, color: Colors.white),
              SizedBox(height: 10.h),
              for (int i = 0; i < 2; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 150.w, height: 10.sp, color: Colors.white),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(width: 80.w, height: 8.sp, color: Colors.white),
                        Container(width: 60.w, height: 8.sp, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Container(width: double.infinity, height: 6.h, color: Colors.white),
                    SizedBox(height: 12.h),
                  ],
                ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(width: 80.w, height: 14.sp, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a tagged controller to ensure a single instance
    final GoalController controller = Get.put(GoalController(), tag: 'goalsPage');
    // Trigger fetchGoals only once per navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchGoals();
    });

    return Scaffold(
      backgroundColor: backgroundColor,
      body: GetX<GoalController>(
        tag: 'goalsPage',
        builder: (controller) {
          if (controller.isLoading.value) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TitleWithViewAll(
                        title: "Your Goals",
                        titleFontSize: 24,
                        showViewAll: false,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    for (int i = 0; i < 3; i++) _buildShimmerGoalCard(),
                  ],
                ),
              ),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                ),
              ),
            );
          }

          if (controller.goals.isEmpty) {
            return Center(
              child: Text(
                'No goals found',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Poppins',
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: TitleWithViewAll(
                      title: "Your Goals",
                      titleFontSize: 24,
                      showViewAll: false,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  ...controller.goals.map((goal) => Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: GoalCard(
                      goal: goal,
                      cardColor: primaryColor,
                      buttonColor: subTextColor2,
                    ),
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}