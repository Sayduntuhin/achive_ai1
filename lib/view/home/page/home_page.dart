import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/home/widgets/calander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../widgets/title_with_view_all.dart';
import '../../../controller/calander_controller.dart';
import '../widgets/task.dart';

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

  final List<String> goalOptions = [
    "Lose 10 Lbs",
    "Get A Tech Job",
    "Eat a Healthy Diet",
    "Exercise Daily",
    "Get Enough Sleep",
    "Complete a Course",
  ];

  @override
  void initState() {
    super.initState();
    Get.put(CalendarController());
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
                        style: TextStyle(fontSize: 10.sp, fontFamily: 'Poppins', color: Colors.black),
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
                            backgroundColor: Color(0xFF4A8F9F),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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

  Widget _bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7.0),
          child: SvgPicture.asset("assets/svg/bullet.svg", width: 5.w, height: 5.h),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 10.sp, fontFamily: 'Poppins', color: Colors.black),
          ),
        ),
      ],
    );
  }

  void _openTaskDialog() {
    final controller = Get.find<CalendarController>();
    _selectedGoal = goalOptions.first;
    _selectedDate = controller.selectedDay.value;
    _selectedTime = TimeOfDay.now();
    _taskType = "Any Time";
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
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
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
                            color: primaryColor,
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
                                color: primaryColor,
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
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              "Description",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: primaryColor,
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
                                contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                                hintText: "Add Details About Your Task",
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              maxLines: 3,
                            ),
                            SizedBox(height: 15.h),
                            Text(
                              "Related Goal",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: primaryColor,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(10.r),
                                isExpanded: true,
                                value: _selectedGoal,
                                hint: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Text("Select a Goal", style: TextStyle(color: Colors.grey)),
                                ),
                                items: goalOptions.map((String goal) {
                                  return DropdownMenuItem<String>(
                                    value: goal,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                                      child: Text(goal),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedGoal = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date Of Task",
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
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: primaryColor),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                          hintText: _selectedDate != null
                                              ? controller.formatDate(_selectedDate!)
                                              : "mm/dd/yy",
                                          hintStyle: TextStyle(color: primaryColor),
                                          suffixIcon: Icon(Icons.calendar_today, color: primaryColor, size: 20.sp),
                                        ),
                                        onTap: () async {
                                          final pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: _selectedDate ?? DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
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
                                        "Time Of Task",
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
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: primaryColor),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                          hintText: _selectedTime != null
                                              ? _selectedTime!.format(context)
                                              : "--:--:--",
                                          hintStyle: TextStyle(color: primaryColor),
                                          suffixIcon: Icon(Icons.access_time, color: primaryColor, size: 20.sp),
                                        ),
                                        onTap: () async {
                                          final pickedTime = await showTimePicker(
                                            context: context,
                                            initialTime: _selectedTime ?? TimeOfDay.now(),
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
                            SizedBox(height: 15.h),
                            Text(
                              "Task Type",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: primaryColor,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(10.r),
                                isExpanded: true,
                                value: _taskType,
                                items: ["Any Time", "Scheduled", "Goal"].map((String type) {
                                  return DropdownMenuItem<String>(
                                    value: type,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                                      child: Text(type),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _taskType = newValue!;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Center(
                              child: Container(
                                width: 0.5.sw,
                                height: 0.05.sh,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_taskNameController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Task name is required")),
                                      );
                                      return;
                                    }
                                    if (_selectedDate == null) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Task date is required")),
                                      );
                                      return;
                                    }
                                    final date = controller.formatDate(_selectedDate!);
                                    final time = _taskType == "Any Time"
                                        ? ""
                                        : _selectedTime?.format(context) ?? "";
                                    controller.addTask(
                                      title: _taskNameController.text,
                                      description: _descriptionController.text,
                                      goal: _selectedGoal,
                                      date: date,
                                      time: time,
                                      type: _taskType,
                                    );
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: Text(
                                    "Add Task",
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
              Icon(Icons.notifications_none_outlined, color: primaryColor, size: 25.sp),
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

  Widget _buildAnyTimeTasks() {
    final controller = Get.find<CalendarController>();
    return Obx(() {
      final selectedDate = controller.formatDate(controller.selectedDay.value);
      final tasks = controller.getTasksForDate(selectedDate).where((task) => task.type == "Any Time").toList();
      if (tasks.isEmpty) {
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
              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Poppins'),
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
            showOptions: true,
          )),
        ],
      );
    });
  }

  Widget _buildTaskCard({
    required Task task,
    bool showOptions = false,
  }) {
    final controller = Get.find<CalendarController>();
    return GestureDetector(
      onTap: () {
        controller.toggleTaskCompletion(task.id);
      },
      child: Row(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 10.w,
            height: 0.1.sh,
            margin: EdgeInsets.only(bottom: 10.h),
            decoration: BoxDecoration(
              color: task.isCompleted ? Color(0xFF088408) : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              border: Border.all(
                color: task.isCompleted ? Color(0xFF088408) : buttonColor,
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
                  color: task.isCompleted ? Color(0xFF088408) : Colors.transparent,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: task.isCompleted ? Color(0xFF088408) : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted ? Colors.transparent : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: task.isCompleted ? 1.0 : 0.0,
                        child: Icon(Icons.check, color: Colors.white, size: 16.sp),
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
                          height: 0.035.sh,
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: task.isCompleted ? Color(0xFF088408) : Color(0xff1C2A45),
                              fontFamily: 'Philosopher',
                            ),
                          ),
                        ),
                        Text(
                          task.goal,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: task.isCompleted ? Color(0xFFAAAAAA) : Colors.white,
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
                        if (value == 'schedule') {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              controller.scheduleTask(
                                task.id,
                                controller.formatDate(pickedDate),
                                pickedTime.format(context),
                              );
                            }
                          }
                        } else if (value == 'cancel') {
                          controller.cancelTask(task.id);
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

  Widget _buildTodaySchedule() {
    final controller = Get.find<CalendarController>();
    return Obx(() {
      final selectedDate = controller.formatDate(controller.selectedDay.value);
      final tasks = controller.getTasksForDate(selectedDate).where((task) => task.type == "Scheduled").toList();
      if (tasks.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWithViewAll(
              title: "${isSameDay(controller.selectedDay.value, DateTime.now()) ? 'Today\'s' : controller.formatDate(controller.selectedDay.value)} Schedule",
              showViewAll: false,
            ),
            SizedBox(height: 10.h),
            Text(
              "No Scheduled Tasks",
              style: TextStyle(color: Colors.white, fontSize: 14.sp, fontFamily: 'Poppins'),
            ),
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWithViewAll(
            title: "${isSameDay(controller.selectedDay.value, DateTime.now()) ? 'Today\'s' : controller.formatDate(controller.selectedDay.value)} Schedule",
            showViewAll: false,
          ),
          SizedBox(height: 10.h),
          ...tasks.map((task) => _buildScheduleCard(
            task: task,
            showOptions: true,
          )),
        ],
      );
    });
  }

  Widget _buildScheduleCard({
    required Task task,
    bool showOptions = false,
  }) {
    final controller = Get.find<CalendarController>();
    return GestureDetector(
      onTap: () {
        controller.toggleTaskCompletion(task.id);
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
              color: task.isCompleted ? Color(0xFF088408) : Colors.transparent,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
              border: Border.all(
                color: task.isCompleted ? Color(0xFF088408) : buttonColor,
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
                  color: task.isCompleted ? Color(0xFF088408) : Colors.transparent,
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
                      color: task.isCompleted ? Color(0xFF088408) : Colors.transparent,
                      border: Border.all(
                        color: task.isCompleted ? Colors.transparent : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: task.isCompleted ? 1.0 : 0.0,
                        child: Icon(Icons.check, color: Colors.white, size: 16.sp),
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
                              color: task.isCompleted ? Color(0xFF088408) : Color(0xff1C2A45),
                              fontFamily: 'Philosopher',
                            ),
                          ),
                        ),
                        Text(
                          task.goal,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: task.isCompleted ? Color(0xFFAAAAAA) : Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showOptions)
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                      onSelected: (value) {
                        if (value == 'cancel') {
                          controller.cancelTask(task.id);
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