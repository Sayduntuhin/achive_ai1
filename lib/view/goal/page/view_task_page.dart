import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../setting/widgets/custom_app_bar.dart';

class ViewTaskPage extends StatefulWidget {
  @override
  _ViewTaskPageState createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage> {
  final String goalTitle = "Eat A Healthy Diet";
  final String goalSubtitle = "Goal: Lose 10 Lbs";
  double progress = 50.0;
  double consistency = 50.0;

  // Task completion status
  bool isDietPlanCompleted = true;
  bool isWorkoutsCompleted = false;
  bool isWaterCompleted = false;
  bool isCaloriesCompleted = false;
  bool isCaloriesLocked = true;

  void _updateProgress() {
    int completedTasks = 0;
    if (isDietPlanCompleted) completedTasks++;
    if (isWorkoutsCompleted) completedTasks++;
    if (isWaterCompleted) completedTasks++;
    if (isCaloriesCompleted) completedTasks++;

    setState(() {
      progress = (completedTasks / 4) * 100;

      // Unlock calories tracking when all other tasks are completed
      if (isDietPlanCompleted && isWorkoutsCompleted && isWaterCompleted) {
        isCaloriesLocked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color progressColor = progress == 100 ? greenColor : primaryColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: "View Task",
        backgroundColor: backgroundColor,
        textColor: titleColor,
        onBackPress: () => Get.back(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Title and Goal
            Text(
              goalTitle,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: 'Philosopher',
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Goal: Lose 10 Lbs",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 15.h),
            // Progress Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Progress",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: progressColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "${progress.toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontSize: 18.sp,
                    color: progressColor,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: progress / 100),
              duration: Duration(seconds: 1),
              builder: (context, value, _) => ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.white,
                  color: progressColor,
                  minHeight: 10.h,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Consistency
            Text(
              "Consistency: ${consistency.toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 20.h),

            // Task Checklist Items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // Diet Plan Task
                  TaskCard(
                    title: "Diet Plan",
                    showSubtitle: false,
                    isCompleted: isDietPlanCompleted,
                    onTap: () {
                      setState(() {
                        isDietPlanCompleted = !isDietPlanCompleted;
                        _updateProgress();
                      });
                    },
                  ),

                  // 100 Workouts Task
                  TaskCard(
                    title: "100 Workouts",
                    subtitle: "Remaining Repetitions: 72",
                    showSubtitle: false,
                    isCompleted: isWorkoutsCompleted,
                    showConsistency: true,
                    consistencyValue: 28,
                    onTap: () {
                      setState(() {
                        isWorkoutsCompleted = !isWorkoutsCompleted;
                        _updateProgress();
                      });
                    },
                  ),

                  // Water Task
                  TaskCard(
                    title: "Drink 8 Glasses Of Water",
                    showSubtitle: false,
                    isCompleted: isWaterCompleted,
                    onTap: () {
                      setState(() {
                        isWaterCompleted = !isWaterCompleted;
                        _updateProgress();
                      });
                    },
                  ),

                  // Calories Task (Locked until other tasks are completed)
                  TaskCard(
                    title: "Track Calories",
                    subtitle: "Complete Previous Tasks To Unlock",
                    showSubtitle: isCaloriesLocked,
                    isCompleted: isCaloriesCompleted,
                    isLocked: isCaloriesLocked,
                    onTap: () {
                      if (!isCaloriesLocked) {
                        setState(() {
                          isCaloriesCompleted = !isCaloriesCompleted;
                          _updateProgress();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final bool showSubtitle;
  final bool isCompleted;
  final bool isLocked;
  final bool showConsistency;
  final int consistencyValue;
  final VoidCallback onTap;

  const TaskCard({
    Key? key,
    required this.title,
    this.subtitle,
    this.showSubtitle = false,
    required this.isCompleted,
    this.isLocked = false,
    this.showConsistency = false,
    this.consistencyValue = 0,
    required this.onTap,
  }) : super(key: key);

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Start with animation completed if goal is completed
    if (widget.isCompleted) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted != oldWidget.isCompleted) {
      if (widget.isCompleted) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Task color based on status
    Color taskColor = widget.isCompleted ? greenColor :
    (widget.isLocked ? Color(0xFF727272): Colors.white);

    // Calculate dynamic height based on content
    double cardHeight = 70.h;  // Base height when no extra content

    if (widget.showSubtitle) {
      cardHeight += 10.h;
    }

    if (widget.showConsistency) {
      cardHeight += 25.h;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: 20.h),
          height: cardHeight,
          decoration: BoxDecoration(
            color: widget.isCompleted
                ? Colors.transparent
                : (widget.isLocked
                ? Color(0xFFB7B7B7)
                : primaryColor),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: widget.isCompleted
                  ? greenColor
                  : primaryColor,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Left colored indicator
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                width: 10.w,
                decoration: BoxDecoration(
                  color: widget.isCompleted
                      ? greenColor
                      : (widget.isLocked
                      ? backgroundColor
                      : backgroundColor),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          // Animated checkbox
                          AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Container(
                                width: 28.w,
                                height: 28.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.isLocked
                                      ? Color(0xFFB7B7B7)
                                      : Color.lerp(Colors.transparent, taskColor, _animation.value),
                                  border: Border.all(
                                    color: taskColor,
                                    width: 2,
                                  ),
                                ),
                                child: widget.isLocked
                                    ? Icon(Icons.lock, color: Colors.grey, size: 16.sp)
                                    : AnimatedOpacity(
                                  duration: Duration(milliseconds: 200),
                                  opacity: _animation.value,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(width: 16.w),
                          // Title
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.w600,
                                    color: widget.isCompleted
                                        ? greenColor
                                        : (widget.isLocked
                                        ? Color(0xFF727272)
                                        : titleColor2),
                                    fontFamily: 'Philosopher',
                                  ),
                                ),
                                if (widget.showSubtitle && widget.subtitle != null) ...[
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Text(
                                        widget.subtitle!,
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          color: widget.isCompleted
                                              ? Colors.transparent
                                              : (widget.isLocked
                                              ? Color(0xFF727272)
                                              : titleColor2),
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      // Optional consistency indicator
                      if (widget.showConsistency) ...[
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Spacer(),
                                      Text(
                                        widget.subtitle!,
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Spacer(flex: 2,),
                                      Text(
                                        "Consistency: ${widget.consistencyValue}",
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          color: Colors.black,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Padding(
                                    padding: EdgeInsets.only(left: 40.w),
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(begin: 0.0, end: widget.consistencyValue / 100),
                                      duration: Duration(seconds: 1),
                                      builder: (context, value, _) => ClipRRect(
                                        borderRadius: BorderRadius.circular(5.r),
                                        child: LinearProgressIndicator(
                                          value: value,
                                          backgroundColor: titleColor2,
                                          color: taskColor,
                                          minHeight: 5.h,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
