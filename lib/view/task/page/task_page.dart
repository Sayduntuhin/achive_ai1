import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../widgets/title_with_view_all.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using the same blue color for all cards as in the original image
    final Color cardColor = primaryColor;
    final Color buttonColor = subTextColor2;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
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

              GoalCard(
                title: "Lose 10 Lbs",
                description: "Get Healthier And More Fit By Losing Weight",
                overallProgress: 70,
                consistency: 30,
                tasks: [
                  TaskInfo(
                    name: "Eat A Healthy Diet",
                    remainingRepetitions: 72,
                    consistency: 28,
                  ),
                  TaskInfo(
                    name: "Work Out 3 Times",
                    remainingRepetitions: 72,
                    consistency: 28,
                  ),
                ],
                cardColor: cardColor,
                buttonColor: buttonColor,
              ),
              SizedBox(height: 16.h),

              // Career goal card
              GoalCard(
                title: "Get A Tech Job",
                description: "Work Towards Securing A Developer Position",
                overallProgress: 45,
                consistency: 65,
                tasks: [
                  TaskInfo(
                    name: "Complete Flutter Course",
                    remainingRepetitions: 5,
                    consistency: 85,
                  ),
                  TaskInfo(
                    name: "Build Portfolio Projects",
                    remainingRepetitions: 3,
                    consistency: 40,
                  ),
                ],
                cardColor: cardColor,
                buttonColor: buttonColor,
              ),
              SizedBox(height: 16.h),

              // Savings goal card
              GoalCard(
                title: "Save \$5,000",
                description: "Build Financial Security For The Future",
                overallProgress: 25,
                consistency: 80,
                tasks: [
                  TaskInfo(
                    name: "Monthly Budget Review",
                    remainingRepetitions: 8,
                    consistency: 90,
                  ),
                  TaskInfo(
                    name: "Deposit to Savings",
                    remainingRepetitions: 36,
                    consistency: 75,
                  ),
                ],
                cardColor: cardColor,
                buttonColor: buttonColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Task information model
class TaskInfo {
  final String name;
  final int remainingRepetitions;
  final int consistency;

  TaskInfo({
    required this.name,
    required this.remainingRepetitions,
    required this.consistency,
  });
}

class GoalCard extends StatefulWidget {
  final String title;
  final String description;
  final int overallProgress;
  final int consistency;
  final List<TaskInfo> tasks;
  final Color cardColor;
  final Color buttonColor;

  const GoalCard({
    Key? key,
    required this.title,
    required this.description,
    required this.overallProgress,
    required this.consistency,
    required this.tasks,
    required this.cardColor,
    required this.buttonColor,
  }) : super(key: key);

  @override
  _GoalCardState createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  late List<Animation<double>> _taskAnimations;

  @override
  void initState() {
    super.initState();

    // Set up animations
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    // Main progress animation
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.overallProgress / 100,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.65, curve: Curves.easeInOut),
      ),
    );

    // Task animations with staggered effect - fixed to ensure end <= 1.0
    _taskAnimations = [];
    for (int i = 0; i < widget.tasks.length; i++) {
      final task = widget.tasks[i];
      // Make sure we don't exceed 1.0 for the interval
      double startTime = 0.3 + (i * 0.15);
      // Cap end time to 1.0
      double endTime = min(startTime + 0.5, 1.0);

      _taskAnimations.add(
          Tween<double>(
            begin: 0.0,
            end: task.consistency / 100,
          ).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(startTime, endTime, curve: Curves.easeInOut),
            ),
          )
      );
    }

    // Start the animation after a short delay
    Future.delayed(Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  // Helper method to ensure the value is within bounds
  double min(double a, double b) {
    return a < b ? a : b;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: widget.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: widget.cardColor.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Goal Title with scale animation
              Transform.scale(
                scale: Curves.easeInOut.transform(_animationController.value),
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontFamily: "Philosopher",
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: titleColor2,
                  ),
                ),
              ),
              SizedBox(height: 4.h),

              // Goal Description with fade animation
              Opacity(
                opacity: _animationController.value,
                child: Text(
                  widget.description,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              SizedBox(height: 10.h),

              // Overall Progress
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Over All Progress",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: titleColor2,
                      fontFamily: "Poppins",
                    ),
                  ),
                  Text(
                    "${widget.overallProgress}%",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),

              // Animated Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: _progressAnimation.value,
                  backgroundColor: backgroundColor,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 8.h,
                ),
              ),
              SizedBox(height: 10.h),

              // Consistency
              Text(
                "Consistency: ${widget.consistency}%",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 5.h),

              // Divider with animation
              Transform.scale(
                scale: _animationController.value,
                alignment: Alignment.centerLeft,
                child: Divider(color: Colors.black, thickness: 1),
              ),

              // Task Label
              Text(
                "Task:",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 10.h),

              // Task list with animations - fixed to avoid crashes
              for (int index = 0; index < widget.tasks.length; index++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tasks[index].name,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: titleColor2,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Remaining Repetitions: ${widget.tasks[index].remainingRepetitions}",
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.white,
                            fontFamily: "Poppins",

                          ),
                        ),
                        Text(
                          "Consistency: ${widget.tasks[index].consistency}",
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.black,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: LinearProgressIndicator(
                        value: _taskAnimations[index].value,
                        backgroundColor: backgroundColor,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        minHeight: 6.h,
                      ),
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),

              // View Tasks Button with slide animation
              Transform.translate(
                offset: Offset(
                  (1.0 - _animationController.value) * 50.0,
                  0.0,
                ),
                child: Opacity(
                  opacity: _animationController.value,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                       Get.toNamed("/viewTask");
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(50, 30),
                      ),
                      child: Text(
                        "View Tasks",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: widget.buttonColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}