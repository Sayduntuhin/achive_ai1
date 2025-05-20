import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/missed_task_controller.dart';
import '../../../model/task.dart';
import '../../../themes/colors.dart';
import '../../home/page/home_page.dart';
import '../../setting/widgets/custom_app_bar.dart';
import '../../widgets/snackbar_helper.dart';
import '../../widgets/title_with_view_all.dart';

class MissedTaskPage extends StatefulWidget {
  const MissedTaskPage({super.key});

  @override
  State<MissedTaskPage> createState() => _MissedTaskPageState();
}

class _MissedTaskPageState extends State<MissedTaskPage> {
  final MissedTaskController missedTaskController = Get.put(MissedTaskController());

  void _openScheduleDialog(BuildContext context, Task task) {
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: Colors.white,
              child: Container(
                padding: EdgeInsets.all(20.w),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Set Time/Date",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: primaryColor,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.black,
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "New Date",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  color: primaryColor,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                  hintText: selectedDate != null
                                      ? DateFormat('MM/dd/yyyy').format(selectedDate!)
                                      : "mm/dd/yy",
                                  hintStyle: TextStyle(color: primaryColor),
                                  suffixIcon: Icon(Icons.calendar_today, color: primaryColor, size: 20.sp),
                                ),
                                onTap: () async {
                                  final pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: primaryColor,
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                          dialogBackgroundColor: Colors.white,
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedDate != null) {
                                    setState(() {
                                      selectedDate = pickedDate;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "New Time",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: 'Poppins',
                                  color: primaryColor,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: const BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.r),
                                    borderSide: BorderSide(color: primaryColor),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                  hintText: selectedTime != null
                                      ? selectedTime!.format(context)
                                      : "--:--:--",
                                  hintStyle: TextStyle(color: primaryColor),
                                  suffixIcon: Icon(Icons.access_time, size: 20.sp, color: primaryColor),
                                ),
                                onTap: () async {
                                  final pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                    builder: (context, child) {
                                      return Theme(
                                        data: Theme.of(context).copyWith(
                                          colorScheme: ColorScheme.light(
                                            primary: primaryColor,
                                            onPrimary: Colors.white,
                                            surface: Colors.white,
                                            onSurface: Colors.black,
                                          ),
                                          dialogBackgroundColor: Colors.white,
                                        ),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (pickedTime != null) {
                                    setState(() {
                                      selectedTime = pickedTime;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Center(
                      child: SizedBox(
                        width: 0.5.sw,
                        height: 0.05.sh,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (selectedDate == null || selectedTime == null) {
                              SnackbarHelper.showErrorSnackbar("Please select both date and time");
                              return;
                            }
                            final localDateTime = DateTime(
                              selectedDate!.year,
                              selectedDate!.month,
                              selectedDate!.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );
                            final utcDateTime = localDateTime.toUtc();
                            final scheduleTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(utcDateTime);

                            final response = await missedTaskController.rescheduleTask(task.id, scheduleTime);
                            if (response['success']) {
                              SnackbarHelper.showSuccessSnackbar('Task rescheduled successfully');
                              Navigator.pop(context);
                            } else {
                              SnackbarHelper.showErrorSnackbar(response['message'] ?? 'Failed to reschedule task');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                          ),
                          child: Text(
                            "Add",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  void _showCompletionDialog(String taskTitle) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: Colors.white,
          child: Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Checkmark
                Lottie.asset(
                  'assets/lottie/checkmark.json',
                  width: 100.w,
                  height: 100.h,
                  fit: BoxFit.contain,
                  repeat: false, // Play animation once
                ),
                SizedBox(height: 16.h),
                // Title
                Text(
                  'Great Job',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C2A45),
                    fontFamily: 'Philosopher',
                  ),
                ),
                SizedBox(height: 8.h),
                // Subtitle
                Text(
                  "You've completed $taskTitle\nKeep up the good work and stay consistent.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.grey[600],
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 24.h),
                // Complete Button
                SizedBox(
                  width: 0.5.sw,
                  height: 0.05.sh,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      'Complete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildScheduleCard(Task task, {bool showOptions = false}) {
    bool isCompleted = task.isCompleted;
    final checkmarkColor = isCompleted ? greenColor : Colors.transparent;
    final borderColor = isCompleted ? greenColor : Colors.transparent;
    final titleTextColor = isCompleted ? greenColor : const Color(0xff1C2A45);
    final subtitleTextColor = isCompleted ? const Color(0xFFAAAAAA) : Colors.white;

    return GestureDetector(
      onTap: () async {
        if (!isCompleted) {
          final response = await missedTaskController.markTaskComplete(task.id);
          if (response['success']) {
            _showCompletionDialog(task.title);
            setState(() {
              isCompleted = true;
            });
            SnackbarHelper.showSuccessSnackbar('Task marked as complete');
          } else {
            SnackbarHelper.showErrorSnackbar(response['message'] ?? 'Failed to mark task as complete');
          }
        }
      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.h, right: 10.w),
            child: Text(
              task.time,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xffF1F1F1),
                fontFamily: 'Philosopher',
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.only(bottom: 10.h),
            width: 10.w,
            height: 0.09.sh,
            decoration: BoxDecoration(
              color: isCompleted ? borderColor : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              border: Border.all(
                color: isCompleted ? Colors.transparent : buttonColor,
                width: 1,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.w),
              margin: EdgeInsets.only(bottom: 10.h),
              height: 0.09.sh,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.transparent : buttonColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: checkmarkColor,
                      border: Border.all(
                        color: isCompleted ? Colors.transparent : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: isCompleted
                        ? Icon(Icons.check, color: Colors.white, size: 16.sp)
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 1.sw,
                          height: 0.03.sh,
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: titleTextColor,
                              fontFamily: 'Philosopher',
                            ),
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: subtitleTextColor,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showOptions && !isCompleted)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                      onSelected: (value) async {
                        if (value == 'schedule') {
                          _openScheduleDialog(context, task);
                        } else if (value == 'cancel') {
                          final response = await missedTaskController.cancelTask(task.id);
                          if (response['success']) {
                            SnackbarHelper.showSuccessSnackbar('Task canceled successfully');
                          } else {
                            SnackbarHelper.showErrorSnackbar(response['message'] ?? 'Failed to cancel task');
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'schedule',
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          height: 40.h,
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: textColor, size: 18.sp),
                              SizedBox(width: 5.w),
                              Text(
                                "Reschedule",
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 10.sp,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'cancel',
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          height: 40.h,
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: const Color(0xFFFF5A5A), size: 18.sp),
                              SizedBox(width: 5.w),
                              Text(
                                "Cancel Task",
                                style: TextStyle(
                                  color: const Color(0xFFFF5A5A),
                                  fontSize: 10.sp,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      color: Colors.white,
                      constraints: BoxConstraints(minWidth: 140.w, maxWidth: 140.w),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Missed Task',
          backgroundColor: backgroundColor,
          textColor: primaryColor,
          borderColor: const Color(0xffD9D9D9),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Obx(() {
          if (missedTaskController.isLoading.value) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWithViewAll(
                  title: "Reschedule missed tasks (7 DAY’S)",
                  titleFontSize: 16,
                  showViewAll: false,
                ),
                SizedBox(height: 20.h),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Column(
                    children: List.generate(
                      3,
                          (index) => Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        height: 0.09.sh,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (missedTaskController.errorMessage.value.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWithViewAll(
                  title: "Reschedule missed tasks (7 DAY’S)",
                  titleFontSize: 16,
                  showViewAll: false,
                ),
                SizedBox(height: 20.h),
                Text(
                  missedTaskController.errorMessage.value,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            );
          }

          if (missedTaskController.missedTasks.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleWithViewAll(
                  title: "Reschedule missed tasks (7 DAY’S)",
                  titleFontSize: 16,
                  showViewAll: false,
                ),
                SizedBox(height: 20.h),
                Text(
                  "No missed tasks",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleWithViewAll(
                title: "Reschedule missed tasks (7 DAY’S)",
                titleFontSize: 16,
                showViewAll: false,
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: ListView.builder(
                  itemCount: missedTaskController.missedTasks.length,
                  itemBuilder: (context, index) {
                    final task = missedTaskController.missedTasks[index];
                    return _buildScheduleCard(
                      task,
                      showOptions: true,
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}