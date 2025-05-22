import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/view_task_controller.dart';
import '../../setting/widgets/custom_app_bar.dart';
import '../../widgets/snackbar_helper.dart';

class ViewTaskPage extends StatelessWidget {
  const ViewTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ViewTaskController());

    return GetX<ViewTaskController>(
      builder: (controller) {
        if (controller.errorMessage.value.isNotEmpty &&
            !controller.errorMessage.value.contains('Invalid navigation arguments')) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackbarHelper.showErrorSnackbar(controller.errorMessage.value);
            controller.errorMessage.value = '';
          });
        }

        if (controller.errorMessage.value.contains('Invalid navigation arguments')) {
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: CustomAppBar(
              title: "View Tasks",
              backgroundColor: backgroundColor,
              textColor: titleColor,
              onBackPress: () => Get.back(),
            ),
            body: Center(
              child: Text(
                controller.errorMessage.value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.red,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          );
        }

        Color progressColor = controller.progress.value >= 100 ? greenColor : primaryColor;

        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: CustomAppBar(
            title: "View Tasks",
            backgroundColor: backgroundColor,
            textColor: titleColor,
            onBackPress: () => Get.back(),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.goal.name.isNotEmpty ? controller.goal.name : 'Tasks',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Philosopher',
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Goal: ${controller.goal.name.isNotEmpty ? controller.goal.name : 'Unnamed Goal'}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 15.h),
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
                      "${controller.progress.value.toStringAsFixed(0)}%",
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
                  tween: Tween<double>(begin: 0.0, end: controller.progress.value / 100),
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
                Text(
                  "Consistency: ${controller.consistency.value.toStringAsFixed(0)}%",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: controller.allSubtasks.isEmpty
                      ? Center(
                    child: Text(
                      "No subtasks found",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  )
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: controller.allSubtasks.length,
                    itemBuilder: (context, index) {
                      final subtask = controller.allSubtasks[index];
                      final isLocked = controller.isSubtaskLocked(subtask);
                      final isCompleted = subtask.progress >= 100.0;
                      return TaskCard(
                        title: subtask.name,
                        subtitle: isLocked ? "Complete Previous Tasks To Unlock" : subtask.description,
                        showSubtitle: isLocked || subtask.description.isNotEmpty,
                        isCompleted: isCompleted,
                        isLocked: isLocked,
                        showConsistency: subtask.recurrence > 1,
                        consistencyValue: subtask.progress.toInt(),
                        onTap: () {
                          if (!isLocked) {
                            controller.toggleSubtaskCompletion(subtask);
                          } else {
                            controller.errorMessage.value =
                            'This task is locked. Complete dependent tasks first.';
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
    super.key,
    required this.title,
    this.subtitle,
    this.showSubtitle = false,
    required this.isCompleted,
    this.isLocked = false,
    this.showConsistency = false,
    this.consistencyValue = 0,
    required this.onTap,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
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
    Color taskColor = widget.isCompleted
        ? greenColor
        : (widget.isLocked ? Color(0xFF727272) : Colors.white);

    return GestureDetector(
      onTap: widget.isLocked ? null : widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: 20.h),
          decoration: BoxDecoration(
            color: widget.isCompleted
                ? Colors.transparent
                : (widget.isLocked ? Color(0xFFB7B7B7) : primaryColor),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: widget.isCompleted ? greenColor : primaryColor,
              width: 1,
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: 15.w,
                  decoration: BoxDecoration(
                    color: widget.isCompleted
                        ? greenColor
                        : (widget.isLocked ? backgroundColor : backgroundColor),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.r),
                      bottomLeft: Radius.circular(10.r),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
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
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600,
                                      color: widget.isCompleted
                                          ? greenColor
                                          : (widget.isLocked ? Color(0xFF727272) : titleColor2),
                                      fontFamily: 'Philosopher',
                                    ),
                                  ),
                                  if (widget.showSubtitle && widget.subtitle != null) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      widget.subtitle!,
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                        color: widget.isCompleted
                                            ? Colors.white
                                            : (widget.isLocked ? Color(0xFF727272) : titleColor2),
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (widget.showConsistency) ...[
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Consistency: ${widget.consistencyValue}%",
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: widget.isCompleted ? Colors.white : Colors.black,
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
      ),
    );
  }
}