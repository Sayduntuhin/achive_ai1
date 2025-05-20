import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/home/widgets/calander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shimmer/shimmer.dart';
import '../../../api/api_service.dart';
import '../../../controller/any_time_task_controller.dart';
import '../../../controller/calander_controller.dart';
import '../../../controller/schedule_task_controller.dart';
import '../../../model/task.dart';
import '../../widgets/snackbar_helper.dart';
import '../../widgets/title_with_view_all.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedGoal = "";
  String _taskType = "Any Time";
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    Get.put(ApiService());
    Get.put(CalendarController());
    Get.put(ScheduleTaskController());
    Get.put(TaskController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDisclaimerDialog();
    });
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _checkAndShowDisclaimerDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownDisclaimer = prefs.getBool('hasShownDisclaimer') ?? false;

    if (!hasShownDisclaimer) {
      _showDisclaimerDialog(context);
      await prefs.setBool('hasShownDisclaimer', true);
    }
  }

  void _showDisclaimerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFD4EBEF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Disclaimer',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Philosopher',
                        fontWeight: FontWeight.w500,
                        color: titleColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MyPerfectLife AI is designed to provide guidance and suggestions to help you achieve your personal goals. However, please note the following:',
                        style: TextStyle(
                            fontSize: 10.sp,
                            fontFamily: 'Poppins',
                            color: Colors.black),
                      ),
                      SizedBox(height: 16),
                      _bulletPoint(
                        'Results may vary. The effectiveness of our suggestions depends on your commitment, consistency, and individual circumstances.',
                      ),
                      SizedBox(height: 10),
                      _bulletPoint(
                        'MyPerfectLife AI uses artificial intelligence to generate personalized recommendations, but these are based on the information you provide and general best practices.',
                      ),
                      SizedBox(height: 10),
                      _bulletPoint(
                        'For health-related goals, please consult with a healthcare professional before starting any new diet or exercise program.',
                      ),
                      SizedBox(height: 10),
                      _bulletPoint(
                        'Your data is processed according to our Privacy Policy. We take your privacy seriously and implement appropriate measures to protect your information.',
                      ),
                      SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                          ),
                          child: Text(
                            'I Understand, Continue',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
  Widget _bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7.0),
          child: SvgPicture.asset("assets/svg/bullet.svg",
              width: 5.w, height: 5.h),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: 10.sp, fontFamily: 'Poppins', color: Colors.black),
          ),
        ),
      ],
    );
  }


  void _openTaskDialog() {
    final calendarController = Get.find<CalendarController>();
    final taskController = Get.find<TaskController>();
    final scheduleController = Get.find<ScheduleTaskController>();
    _selectedDate = null;
    _selectedTime = null;
    _taskNameController.clear();
    _descriptionController.clear();

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
                padding: EdgeInsets.all(20),
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add New Task",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w500,
                            color: textColor, // Changed from primaryColor
                            fontFamily: 'Poppins',
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          color: Colors.black,
                        ),
                      ],
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15.h),
                            Text(
                              "Task Name",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: textColor,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 5.h),
                            TextField(
                              controller: _taskNameController,
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 15.h),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: textColor,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 5.h),
                            TextField(
                              controller: _descriptionController,
                              cursorColor: primaryColor,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: primaryColor),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 15.h),
                                hintText: "Add Details About Your Task",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              maxLines: 3,
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Select Date",
                                        style: TextStyle(
                                          fontSize: 12.sp,
                                          fontFamily: 'Poppins',
                                          color: textColor,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      TextField(
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10.r),
                                            borderSide:
                                            BorderSide(color: primaryColor),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide:
                                            BorderSide(color: primaryColor),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 10.h),
                                          hintText: _selectedDate != null
                                              ? calendarController
                                              .formatDate(_selectedDate!)
                                              : "mm/dd/yy",
                                          hintStyle:
                                          TextStyle(color:primaryColor),
                                          suffixIcon: Icon(Icons.calendar_today,
                                              color: primaryColor, size: 20.sp),
                                        ),
                                        onTap: () async {
                                          final pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate:
                                            _selectedDate ?? DateTime.now(),
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
                                              _selectedDate = pickedDate;
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
                                        "Select Time",
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
                                            borderRadius:
                                            BorderRadius.circular(10.r),
                                            borderSide:
                                            BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            borderSide:
                                            BorderSide(color: primaryColor),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 10.h),
                                          hintText: _selectedTime != null
                                              ? _selectedTime!.format(context)
                                              : "--:--:--",
                                          hintStyle:
                                          TextStyle(color: primaryColor),
                                          suffixIcon: Icon(Icons.access_time,
                                              color: primaryColor, size: 20.sp),
                                        ),
                                        onTap: () async {
                                          final pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime:
                                            _selectedTime ?? TimeOfDay.now(),
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
                                              _selectedTime = pickedTime;
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
                                    if (_taskNameController.text.isEmpty) {
                                      SnackbarHelper.showErrorSnackbar(
                                          "Task name is required");
                                      return;
                                    }
                                    if ((_selectedDate != null &&
                                        _selectedTime == null) ||
                                        (_selectedDate == null &&
                                            _selectedTime != null)) {
                                      SnackbarHelper.showErrorSnackbar(
                                          "Both date and time are required if scheduling");
                                      return;
                                    }

                                    String? scheduleTime;
                                    bool isScheduled = false;
                                    if (_selectedDate != null &&
                                        _selectedTime != null) {
                                      final dateTime = DateTime(
                                        _selectedDate!.year,
                                        _selectedDate!.month,
                                        _selectedDate!.day,
                                        _selectedTime!.hour,
                                        _selectedTime!.minute,
                                      );
                                      scheduleTime = DateFormat(
                                          "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                                          .format(dateTime.toUtc());
                                      isScheduled = true;
                                    }

                                    final response = await Get.find<ApiService>()
                                        .createTask(
                                      title: _taskNameController.text,
                                      description: _descriptionController.text,
                                      scheduleTime: scheduleTime,
                                    );

                                    if (response['success']) {
                                      final data = response['data'];
                                      final task = Task(
                                        id: data['id'].toString(),
                                        title: data['title'],
                                        description: data['description'],
                                        date: isScheduled
                                            ? calendarController
                                            .formatDate(_selectedDate!)
                                            : '',
                                        time: data['schedule_time'] != null
                                            ? DateFormat('hh:mm a').format(
                                            DateTime.parse(
                                                data['schedule_time'])
                                                .toLocal())
                                            : '',
                                        type: isScheduled ? 'Scheduled' : 'Any Time',
                                        isCompleted: data['status'] == 'done',
                                        completionDate:
                                        data['completed_on'] != null
                                            ? DateFormat('MM/dd/yyyy').format(
                                            DateTime.parse(
                                                data['completed_on'])
                                                .toLocal())
                                            : null,
                                      );

                                      if (!isScheduled) {
                                        taskController.anyTimeTasks.add(task);
                                        taskController.anyTimeTasks.refresh();
                                      } else {
                                        scheduleController.scheduledTasks
                                            .add(task);
                                        calendarController.tasks.add(task);
                                        calendarController.saveTasks();
                                        scheduleController
                                            .syncWithCalendarController();
                                      }

                                      SnackbarHelper.showSuccessSnackbar(
                                          "Task added successfully");
                                      Navigator.pop(context);
                                    } else {
                                      SnackbarHelper.showErrorSnackbar(
                                          response['message'] ??
                                              "Failed to add task");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: Text(
                                    "Add Task",
                                    style: TextStyle(
                                      color: Colors.black,
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
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 0.01.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/person.png"),
            radius: 20.w,
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hello Joshitha",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: textColor,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Philosopher',
                ),
              ),
              Text(
                "I am worth of love and respect",
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white70,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          Spacer(),
          SvgPicture.asset(
            "assets/svg/calander.svg",
            width: 25.w,
            height: 25.h,
            colorFilter: ColorFilter.mode(
              primaryColor,
              BlendMode.srcIn,
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_none_outlined,
                  color: primaryColor, size: 25.sp),
              Positioned(
                right: -1,
                top: -4,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12.w,
                    minHeight: 12.w,
                  ),
                  child: Center(
                    child: Text(
                      "3",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerTaskCard() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 0.1.sh,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 0.1.sh,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150.w,
                          height: 18.h,
                          color: Colors.white,
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 100.w,
                          height: 12.h,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnyTimeTasks() {
    final taskController = Get.find<TaskController>();
    final calendarController = Get.find<CalendarController>();
    final Logger _logger = Logger();
    return Obx(() {
      final selectedDate =
      calendarController.formatDate(calendarController.selectedDay.value);
      _logger.d('Building Any Time Tasks for date: $selectedDate');
      final tasks = taskController.getTasksForDate(selectedDate);

      if (taskController.isLoading.value) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWithViewAll(
              title: "Any Time Tasks",
              showViewAll: true,
              viewAllText: "Missed Task",
            ),
            SizedBox(height: 10.h),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: List.generate(3, (index) => _buildShimmerTaskCard()),
              ),
            ),
          ],
        );
      }

      if (taskController.errorMessage.value.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWithViewAll(
              title: "Any Time Tasks",
              showViewAll: true,
              viewAllText: "Missed Task",
            ),
            SizedBox(height: 10.h),
            Text(
              taskController.errorMessage.value,
              style: TextStyle(
                  color: Colors.red, fontSize: 14.sp, fontFamily: 'Poppins'),
            ),
          ],
        );
      }

      if (tasks.isEmpty) {
        _logger.d('No Any Time Tasks for $selectedDate');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWithViewAll(
              title: "Any Time Tasks",
              showViewAll: true,
              viewAllText: "Missed Task",
            ),
            SizedBox(height: 10.h),
            Text(
              "No Any Time Tasks",
              style: TextStyle(
                  color: Colors.white, fontSize: 14.sp, fontFamily: 'Poppins'),
            ),
          ],
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithViewAll(
            title: "Any Time Tasks",
            showViewAll: true,
            viewAllText: "Missed Task",
          ),
          SizedBox(height: 10.h),
          ...tasks.map((task) => _buildTaskCard(
            task: task,
            showOptions: !task.isCompleted,
          )),
        ],
      );
    });
  }

  Widget _buildTaskCard({
    required Task task,
    bool showOptions = false,
  }) {
    final taskController = Get.find<TaskController>();
    final calendarController = Get.find<CalendarController>();
    final scheduleController = Get.find<ScheduleTaskController>();
    final Logger _logger = Logger();

    // Don't show the options menu for completed tasks
    final shouldShowOptions = showOptions && !task.isCompleted;

    _logger.d(
        'Rendering task card for task ${task.id}: ${task.title}, type=${task.type}, completed=${task.isCompleted}');
    return GestureDetector(
      onTap: task.isCompleted || (taskController.taskLoading[task.id] ?? false)
          ? null
          : () async {
        _logger.d('Marking task ${task.id} as complete');
        final response = await taskController.toggleTaskCompletion(task.id);
        if (response['success']) {
          _logger.i('Completed task: ${task.title}');
          _showCompletionDialog(task.title);
        } else {
          SnackbarHelper.showErrorSnackbar(
              response['message'] ?? 'Failed to mark task as complete');
        }
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 10.w,
            height: 0.1.sh,
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: task.isCompleted ? greenColor : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              border: Border.all(
                color: task.isCompleted ? greenColor : buttonColor,
                width: 1,
              ),
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(16.w),
              margin: EdgeInsets.only(bottom: 10.h),
              height: 0.1.sh,
              decoration: BoxDecoration(
                color: task.isCompleted ? Colors.transparent : buttonColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                border: Border.all(
                  color:
                  task.isCompleted ? greenColor : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Obx(() {
                    final isTaskLoading =
                        taskController.taskLoading[task.id] ?? false;
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: task.isCompleted
                            ? greenColor
                            : Colors.transparent,
                        border: Border.all(
                          color: task.isCompleted || isTaskLoading
                              ? Colors.transparent
                              : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: isTaskLoading
                            ? CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        )
                            : AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          opacity: task.isCompleted ? 1.0 : 0.0,
                          child: Icon(Icons.check,
                              color: Colors.white, size: 16.sp),
                        ),
                      ),
                    );
                  }),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 1.sw,
                          height: 0.035.sh,
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: task.isCompleted
                                  ? greenColor
                                  : Color(0xff1C2A45),
                              fontFamily: 'Philosopher',
                            ),
                          ),
                        ),
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: task.isCompleted
                                ? Color(0xFFAAAAAA)
                                : Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (shouldShowOptions)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                      onSelected: (value) async {
                        if (value == 'schedule') {
                          _logger.d('Scheduling task ${task.id}');
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
                              final localDateTime = DateTime(
                                pickedDate.year,
                                pickedDate.month,
                                pickedDate.day,
                                pickedTime.hour,
                                pickedTime.minute,
                              );
                              final utcDateTime = localDateTime.toUtc();
                              final scheduleTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(utcDateTime);

                              final response = await Get.find<ApiService>().rescheduleTask(
                                taskId: task.id,
                                scheduleTime: scheduleTime,
                              );

                              if (response['success']) {
                                final data = response['data'];
                                final updatedTask = Task(
                                  id: data['id'].toString(),
                                  title: data['title'],
                                  description: data['description'],
                                  date: Get.find<CalendarController>().formatDate(pickedDate),
                                  time: pickedTime.format(context),
                                  type: 'Scheduled',
                                  isCompleted: data['status'] == 'done',
                                  completionDate: data['completed_on'] != null
                                      ? DateFormat('MM/dd/yyyy').format(DateTime.parse(data['completed_on']).toLocal())
                                      : null,
                                );

                                // Remove from any time tasks
                                Get.find<TaskController>().anyTimeTasks.removeWhere((t) => t.id == task.id);

                                // Add to scheduled tasks
                                Get.find<ScheduleTaskController>().scheduledTasks.add(updatedTask);
                                Get.find<CalendarController>().tasks.add(updatedTask);
                                Get.find<CalendarController>().saveTasks();
                                Get.find<ScheduleTaskController>().syncWithCalendarController();

                                // Refresh the lists
                                Get.find<TaskController>().anyTimeTasks.refresh();
                                Get.find<ScheduleTaskController>().scheduledTasks.refresh();

                                SnackbarHelper.showSuccessSnackbar('Task scheduled successfully');
                              } else {
                                SnackbarHelper.showErrorSnackbar(response['message'] ?? 'Failed to schedule task');
                              }
                            }
                          }
                        } else if (value == 'cancel') {
                          _logger.d('Canceling task ${task.id}');
                          final response = await Get.find<TaskController>().cancelTask(task.id);
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
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                          height: 40.h,
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: textColor, size: 18.sp),
                              SizedBox(width: 5.w),
                              Text(
                                "Add To Schedule",
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
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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
          )
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    final scheduleController = Get.find<ScheduleTaskController>();
    final calendarController = Get.find<CalendarController>();
    final Logger _logger = Logger();
    return Obx(() {
      final selectedDate =
          calendarController.formatDate(calendarController.selectedDay.value);
      _logger.d('Building Today Schedule for date: $selectedDate');
      final tasks = scheduleController.getTasksForDate(selectedDate);

      if (scheduleController.isLoading.value) {
        _logger.d('Schedule is loading');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWithViewAll(
              title:
                  "${isSameDay(calendarController.selectedDay.value, DateTime.now()) ? 'Today\'s' : calendarController.formatDate(calendarController.selectedDay.value)} Schedule",
              showViewAll: false,
            ),
            SizedBox(height: 10.h),
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: List.generate(3, (index) => _buildShimmerTaskCard()),
              ),
            ),
          ],
        );
      }

      if (tasks.isEmpty) {
        _logger.d('No tasks for $selectedDate');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWithViewAll(
              title:
                  "${isSameDay(calendarController.selectedDay.value, DateTime.now()) ? 'Today\'s' : calendarController.formatDate(calendarController.selectedDay.value)} Schedule",
              showViewAll: false,
            ),
            SizedBox(height: 10.h),
            Text(
              "No Scheduled Tasks",
              style: TextStyle(
                  color: Colors.white, fontSize: 14.sp, fontFamily: 'Poppins'),
            ),
          ],
        );
      }

      _logger.d('Rendering ${tasks.length} tasks for $selectedDate');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithViewAll(
            title:
                "${isSameDay(calendarController.selectedDay.value, DateTime.now()) ? 'Today\'s' : calendarController.formatDate(calendarController.selectedDay.value)} Schedule",
            showViewAll: false,
          ),
          SizedBox(height: 10.h),
          ...tasks.map((task) => _buildScheduleCard(
                task: task,
                showOptions: !task.isCompleted,
              )),
        ],
      );
    });
  }

  Widget _buildScheduleCard({
    required Task task,
    bool showOptions = false,
  }) {
    final scheduleController = Get.find<ScheduleTaskController>();
    final Logger _logger = Logger();
    _logger.d(
        'Rendering schedule card for goal ${task.id}: ${task.title}, date=${task.date}, time=${task.time}');
    return GestureDetector(
      onTap: () async{
        final response = await scheduleController.markTaskComplete(task.id);
        if (response['success']) {
          _showCompletionDialog(task.title);
        } else {
          SnackbarHelper.showErrorSnackbar(
              response['message'] ?? 'Failed to mark task as complete');
        }
        _logger.d('Marking goal ${task.id} as complete');
        scheduleController.markTaskComplete(task.id);

      },
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.h, right: 10.w),
            child: Text(
              task.time,
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xffF1F1F1),
                fontFamily: 'Philosopher',
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 10.w,
            height: 0.09.sh,
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: task.isCompleted ? greenColor: Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              border: Border.all(
                color: task.isCompleted ? greenColor: buttonColor,
                width: 1,
              ),
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.all(10.w),
              margin: EdgeInsets.only(bottom: 10.h),
              height: 0.09.sh,
              decoration: BoxDecoration(
                color: task.isCompleted ? Colors.transparent : buttonColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12.r),
                  bottomRight: Radius.circular(12.r),
                ),
                border: Border.all(
                  color:
                      task.isCompleted ? greenColor: Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.isCompleted
                          ? greenColor
                          : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted
                            ? Colors.transparent
                            : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: task.isCompleted ? 1.0 : 0.0,
                        child:
                            Icon(Icons.check, color: Colors.white, size: 16.sp),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 1.sw,
                          height: 0.03.sh,
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: task.isCompleted
                                  ? greenColor
                                  : Color(0xff1C2A45),
                              fontFamily: 'Philosopher',
                            ),
                          ),
                        ),
                        Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: task.isCompleted
                                ? Color(0xFFAAAAAA)
                                : Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showOptions)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                      onSelected: (value) async {
                        if (value == 'cancel') {
                          _logger.d('Canceling task ${task.id}');
                          final response = await Get.find<ScheduleTaskController>().cancelTask(task.id);
                          if (response['success']) {
                            SnackbarHelper.showSuccessSnackbar('Task canceled successfully');
                          } else {
                            SnackbarHelper.showErrorSnackbar(response['message'] ?? 'Failed to cancel task');
                          }
                        }
                      },
                      itemBuilder: (BuildContext context) => [
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
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: _buildHeader(),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: CalendarWidget(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildAnyTimeTasks(),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildTodaySchedule(),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.r),
        ),
        backgroundColor: flortingButtonColor,
        onPressed: () {
          _openTaskDialog();
        },
        child: Icon(Icons.add, color: Colors.white, size: 30.sp),
      ),
    );
  }
}
