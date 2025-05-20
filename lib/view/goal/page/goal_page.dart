import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/goal_controller.dart';
import '../../../model/goal.dart';
import '../../widgets/title_with_view_all.dart';

class GoalsPage extends StatelessWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize GoalController
    Get.put(GoalController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: GetX<GoalController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
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

class GoalCard extends StatefulWidget {
  final Goal goal;
  final Color cardColor;
  final Color buttonColor;

  const GoalCard({
    Key? key,
    required this.goal,
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
      end: widget.goal.progress / 100,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.65, curve: Curves.easeInOut),
      ),
    );

    // Task animations with staggered effect
    _taskAnimations = [];
    for (int i = 0; i < widget.goal.tasks.length; i++) {
      final task = widget.goal.tasks[i];
      double startTime = 0.3 + (i * 0.15);
      double endTime = startTime + 0.5 > 1.0 ? 1.0 : startTime + 0.5;

      _taskAnimations.add(
        Tween<double>(
          begin: 0.0,
          end: task.progress / 100,
        ).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(startTime, endTime, curve: Curves.easeInOut),
          ),
        ),
      );
    }

    // Start the animation after a short delay
    Future.delayed(Duration(milliseconds: 200), () {
      _animationController.forward();
    });
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
                  widget.goal.name,
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
                  widget.goal.description,
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
                    "Overall Progress",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: titleColor2,
                      fontFamily: "Poppins",
                    ),
                  ),
                  Text(
                    "${widget.goal.progress.toStringAsFixed(2)}%",
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

              // Consistency (assuming consistency is derived from tasks' average progress)
              Text(
                "Consistency: ${(widget.goal.tasks.isNotEmpty ? widget.goal.tasks.map((t) => t.progress).reduce((a, b) => a + b) / widget.goal.tasks.length : 0).toStringAsFixed(2)}%",
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
                "Tasks:",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontFamily: "Poppins",
                ),
              ),
              SizedBox(height: 10.h),

              // Task list with subtasks
              for (int index = 0; index < widget.goal.tasks.length; index++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.goal.tasks[index].name,
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
                          "Progress: ${widget.goal.tasks[index].progress.toStringAsFixed(2)}%",
                          style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.white,
                            fontFamily: "Poppins",
                          ),
                        ),
                        Text(
                          "Subtasks: ${widget.goal.tasks[index].subtasks.length}",
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
                    SizedBox(height: 8.h),
                    // Subtasks
                    if (widget.goal.tasks[index].subtasks.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(left: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: widget.goal.tasks[index].subtasks.map((subtask) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subtask.name,
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Colors.white,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Progress: ${subtask.progress.toStringAsFixed(2)}%",
                                  style: TextStyle(
                                    fontSize: 8.sp,
                                    color: Colors.white70,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: LinearProgressIndicator(
                                    value: subtask.progress / 100,
                                    backgroundColor: backgroundColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    minHeight: 4.h,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                              ],
                            );
                          }).toList(),
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
                        Get.toNamed("/viewTask", arguments: widget.goal);
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