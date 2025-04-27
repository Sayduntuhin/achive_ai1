import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/home/widgets/calander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/title_with_view_all.dart';
import '../../../controller/calander_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedGoal = ""; // To store the selected goal
  String _taskType = "Any Time"; // Default task type, can be removed if no longer needed.

  final List<String> goalOptions = [
    "Eat a Healthy Diet",
    "Exercise Daily",
    "Get Enough Sleep",
    "Complete a Course",
    // Add more goals as needed
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

  // Disclaimer Dialog Methods
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

  // Open Task Dialog
  void _openTaskDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Fetch the primary color from the theme
        Color primaryColor = Theme.of(context).primaryColor;

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
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(10.r),
                                isExpanded: true,
                                value: _selectedGoal.isEmpty ? null : _selectedGoal,
                                hint: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                                  child: Text("Eat a Healthy Diet", style: TextStyle(color: Colors.grey)),
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
                            // Date and Time Fields in a Row
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
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: primaryColor),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                                          hintText: "mm/dd/yy",
                                          hintStyle: TextStyle(color: primaryColor),

                                          suffixIcon: Icon(Icons.calendar_today, color: primaryColor, size: 20.sp),
                                        ),
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
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: primaryColor),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                                          hintText: "--:--:--",
                                          hintStyle: TextStyle(color: primaryColor),
                                          suffixIcon: Icon(Icons.access_time, size: 20.sp,color:primaryColor   ,),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Center(
                              child: Container(
                                width: 0.5.sw,
                                height: 0.05.sh,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor, // Using primary color here
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
  // Header
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

  // Task Card
  Widget _buildAnyTimeTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithViewAll(
          title: "Any Time Tasks",
          showViewAll: true,
          viewAllText: "Missed Task",
        ),
        SizedBox(height: 10.h),
        _buildTaskCard(
          title: "Read A Chapter Of Your Book",
          subtitle: "Personal Development",
          showOptions: false,
          initialCompleted: true,
        ),
        _buildTaskCard(
          title: "Drink 8 Glasses Of Water",
          subtitle: "Stay Hydrated",
          showOptions: true,
        ),
        _buildTaskCard(
          title: "Meditate For 10 Minutes",
          subtitle: "Focus On Breathing",
          showOptions: true,
        ),
      ],
    );
  }

  Widget _buildTaskCard({
    required String title,
    required String subtitle,
    bool showOptions = false,
    bool initialCompleted = false,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isCompleted = initialCompleted;
        final checkmarkColor = isCompleted ? const Color(0xFF088408) : Colors.transparent;
        final borderColor = isCompleted ? const Color(0xFF088408) : Colors.transparent;
        final titleTextColor = isCompleted ? const Color(0xFF088408) : const Color(0xff1C2A45);
        final subtitleTextColor = isCompleted ? const Color(0xFFAAAAAA) : Colors.white;

        return GestureDetector(
          onTap: () {
            setState(() {
              isCompleted = !isCompleted;
            });
          },
          child: Row(
            children: [
              Container(
                width: 10.w,
                height: 0.1.sh,
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: isCompleted ? borderColor2 : Colors.transparent,
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
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.only(bottom: 10.h),
                  height: 0.1.sh,
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
                        width: 30.w,
                        height: 30.w,
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
                              height: 0.035.sh,
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: titleTextColor,
                                  fontFamily: 'Philosopher',
                                ),
                              ),
                            ),
                            Text(
                              subtitle,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: subtitleTextColor,
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
                            if (value == 'schedule') {
                              print('Add to schedule selected');
                              // Add your schedule logic here
                            } else if (value == 'cancel') {
                              print('Cancel task selected');
                              // Add your cancel logic here
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
      },
    );
  }

  // Schedule Card
  Widget _buildTodaySchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithViewAll(
          title: "Today's Schedule",
          showViewAll: false,
        ),
        SizedBox(height: 10.h),
        _buildScheduleCard(
          title: "Team Meeting",
          subtitle: "Discuss Project Timeline",
          time: "9am",
          date: "02.10.2024",
          showOptions: false,
          initialCompleted: true,
        ),
        _buildScheduleCard(
          title: "Lunch With Sarah",
          subtitle: "At Cafe Milano",
          time: "1pm",
          date: "02.10.2024",
          showOptions: false,
          initialCompleted: true,
        ),
        _buildScheduleCard(
          title: "Evening Reflection",
          subtitle: "Journal About Your Day",
          time: "8pm",
          date: "02.10.2024",
          showOptions: true,
        ),
      ],
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required String subtitle,
    required String time,
    required String date,
    bool showOptions = false,
    bool initialCompleted = false,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isCompleted = initialCompleted;
        final checkmarkColor = isCompleted ? Color(0xFF088408) : Colors.transparent;
        final borderColor = isCompleted ? Color(0xFF088408) : Colors.transparent;
        final titleTextColor = isCompleted ? Color(0xFF088408) : Color(0xff1C2A45);
        final subtitleTextColor = isCompleted ? Color(0xFFAAAAAA) : Colors.white;

        return GestureDetector(
          onTap: () {
            setState(() {
              isCompleted = !isCompleted;
            });
          },
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 10.h, right: 10.w),
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xffF1F1F1),
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
                  color: isCompleted ? borderColor2 : Colors.transparent,
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
                                title,
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
                              subtitle,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: subtitleTextColor,
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
                            if (value == 'schedule') {
                              print('Add to schedule selected');
                              // Add your schedule logic here
                            } else if (value == 'cancel') {
                              print('Cancel task selected');
                              // Add your cancel logic here
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
      },
    );
  }

  // Today's Goal Card
  Widget _buildTodayGoalTask() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithViewAll(
          title: "Today's Goal Task",
          showViewAll: true,
        ),
        SizedBox(height: 10.h),
        _buildTodaysGoalCard(
          title: "Morning Workout",
          subtitle: "Goal: Lose 10 Lbs",
          time: "9:00 AM",
          showOptions: false,
          initialCompleted: true,
        ),
        _buildTodaysGoalCard(
          title: "Study Programming",
          subtitle: "Goal: Get A Tech Job",
          time: "1:00 PM",
          showOptions: false,
          initialCompleted: true,
        ),
        _buildTodaysGoalCard(
          title: "Meal Prep For The Week",
          subtitle: "Goal: Lose 10 Lbs",
          time: "8:00 PM",
          showOptions: true,
        ),
      ],
    );
  }

  Widget _buildTodaysGoalCard({
    required String title,
    required String subtitle,
    required String time,
    bool showOptions = false,
    bool initialCompleted = false,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isCompleted = initialCompleted;
        final checkmarkColor = isCompleted ? Color(0xFF088408) : Colors.transparent;
        final borderColor = isCompleted ? Color(0xFF088408) : Colors.transparent;
        final titleTextColor = isCompleted ? Color(0xFF088408) : Color(0xff1C2A45);
        final svgIconColor = isCompleted ? Color(0xFF088408) : Color(0xff1C2A45);
        final subtitleTextColor = isCompleted ? Color(0xFFAAAAAA) : Colors.white;

        return GestureDetector(
          onTap: () {
            setState(() {
              isCompleted = !isCompleted;
            });
          },
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.only(bottom: 10.h),
                width: 10.w,
                height: 0.12.sh,
                decoration: BoxDecoration(
                  color: isCompleted ? borderColor2 : Colors.transparent,
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
                  height: 0.12.sh,
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
                                title,
                                maxLines: 1,
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
                              subtitle,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: subtitleTextColor,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/time.svg",
                                  width: 14.w,
                                  height: 14.h,
                                  colorFilter: ColorFilter.mode(svgIconColor, BlendMode.srcIn),
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: subtitleTextColor,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (showOptions)
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.white, size: 24.sp),
                          onSelected: (value) {
                            if (value == 'cancel') {
                              print('Cancel task selected');
                              // Add your cancel logic here
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
      },
    );
  }

  // Daily Goals Card
  Widget _buildDailyGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithViewAll(
          title: "Goals Progress",
          showViewAll: true,
        ),
        SizedBox(height: 10.h),
        _buildGoalCard("Lose 10 Lbs", 70),
        _buildGoalCard("Get A Tech Job", 20),
      ],
    );
  }

  Widget _buildGoalCard(String title, double initialProgress) {
    return StatefulBuilder(
      builder: (context, setState) {
        double progress = initialProgress;
        return Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              margin: EdgeInsets.only(bottom: 10.h),
              width: 10.w,
              height: 0.13.sh,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
                border: Border.all(
                  color: borderColor,
                  width: 1,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 0.13.sh,
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 15.h),
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12.r),
                    bottomRight: Radius.circular(12.r),
                  ),
                  border: Border.all(
                    color: borderColor,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontFamily: 'Philosopher',
                          ),
                        ),
                        Spacer(),
                        Text(
                          "${progress.toInt()}%",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: progress),
                      duration: Duration(seconds: 1),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value / 100,
                          backgroundColor: Color(0xFF1C2A45),
                          color: Colors.white,
                          minHeight: 8.h,
                          borderRadius: BorderRadius.circular(10.r),
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Consistency: 80%",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Add action for viewing tasks
                          },
                          child: Text(
                            "View Tasks",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: subTextColor2,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Build Method
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
            const CalendarWidget(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildAnyTimeTasks(),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildTodaySchedule(),
            ),
     /*       SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildTodayGoalTask(),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildDailyGoals(),
            ),*/
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