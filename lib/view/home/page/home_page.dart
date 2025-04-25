import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/home/widgets/calander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widgets/title_with_view_all.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  // Variables for task inputs
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _taskType = 'Any Time'; // Default task type
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowDisclaimerDialog();
    });
  }
  ///--------------------------------- Disclaimer Dialog ---------------------------------------
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
  ///--------------------------------- Options Menu ---------------------------------------
  void _showOptionsMenu(BuildContext context, Offset position, Size size) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy+ 10.h,
        position.dx - 0.75.sw,
        position.dy ,

      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: Colors.white,
      constraints: BoxConstraints(minWidth: 140.w, maxWidth: 140.w),
      items: [
        PopupMenuItem(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          height: 0.04.sh,
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
          onTap: () {
            // Add your logic for adding to schedule
          },
        ),
        PopupMenuItem(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          height: 0.04.sh,
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Color(0xFFFF5A5A), size: 18.sp),
              SizedBox(width: 5.w),
              Text(
                "Cancel Task",
                style: TextStyle(
                  color: Color(0xFFFF5A5A),
                  fontSize: 10.sp,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          onTap: () {
            // Add your logic for canceling task
          },
        ),
      ],
    );
  }
  void _showOptionsMenuForGoal(BuildContext context, Offset position, Size size) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy+ 10.h,
        position.dx - 0.75.sw,
        position.dy ,

      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: Colors.white,
      constraints: BoxConstraints(minWidth: 140.w, maxWidth: 140.w),
      items: [
        PopupMenuItem(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          height: 0.04.sh,
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Color(0xFFFF5A5A), size: 18.sp),
              SizedBox(width: 5.w),
              Text(
                "Cancel Task",
                style: TextStyle(
                  color: Color(0xFFFF5A5A),
                  fontSize: 10.sp,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          onTap: () {
            // Add your logic for canceling task
          },
        ),
      ],
    );
  }
  ///--------------------------------- Open Task Dialog ---------------------------------------
  void _openTaskDialog() {
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
                    // Header and close button
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

                    // Make the rest of the content scrollable
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 15.h),

                            // Task Name
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

                            // Description
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
                                  borderSide: BorderSide(color: Colors.grey),
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

                            // Task Type
                            Text(
                              "Task Type",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: primaryColor,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              children: [
                                Radio(
                                  value: "Any Time",
                                  groupValue: _taskType,
                                  onChanged: (value) {
                                    setState(() {
                                      _taskType = value.toString();
                                    });
                                  },
                                  activeColor: Color(0xFF4BAFDA),
                                ),
                                Text("Any Time"),
                                SizedBox(width: 20.w),
                                Radio(
                                  value: "Scheduled Task",
                                  groupValue: _taskType,
                                  onChanged: (value) {
                                    setState(() {
                                      _taskType = value.toString();
                                    });
                                  },
                                  activeColor: Color(0xFF4BAFDA),
                                ),
                                Text("Scheduled Task"),
                              ],
                            ),
                            SizedBox(height: 15.h),

                            // Date fields for Scheduled Task
                            if (_taskType == "Scheduled Task")
                              Column(
                                children: [
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
                                                color: Color(0xFF4BAFDA),
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
                                                suffixIcon: Icon(Icons.calendar_today, size: 20.sp),
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
                                                color: Color(0xFF4BAFDA),
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
                                                suffixIcon: Icon(Icons.access_time, size: 20.sp),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            SizedBox(height: 20.h),

                            // Add Task button
                            Center(
                              child: Container(
                                width: 0.5.sw,
                                height: 0.05.sh,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle task addition logic here
                                    Navigator.pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:primaryColor,
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
  ///--------------------------------- Build Method ---------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: _buildHeader(),
            backgroundColor: backgroundColor,
            expandedHeight: 0.08.sh,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
          ),
          SliverPersistentHeader(
            pinned: false,
            delegate: _SliverDateSelectorDelegate(
              child: CalendarWidget(),
              height: 80.h,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAnyTimeTasks(),
                    SizedBox(height: 20.h),
                    _buildTodaySchedule(),
                    SizedBox(height: 20.h),
                    _buildTodayGoalTask(),
                    SizedBox(height: 20.h),
                    _buildDailyGoals(),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),
            ]),
          ),
        ],
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
  ///--------------------------------- Header ---------------------------------------
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
  ///--------------------------------- Task Card ---------------------------------------
  Widget _buildAnyTimeTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithViewAll(
          title: "Any Time Tasks",
          showViewAll: false, // Show the "View All" option
        ),
        SizedBox(height: 10.h),
        _buildTaskCard(
          title: "Read A Chapter Of Your Book",
          subtitle: "Personal Development",
          showOptions: false,
          initialCompleted: true, // Ensure true branch is reachable
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
              // Left indicator Container
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
              // Main Container
              Expanded( // Take remaining width
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
                      // Checkbox Container
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
                      // Task details
                      Expanded( // Push options to the right
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
                      // Options icon at the end
                      if (showOptions)
                        Builder(
                          builder: (context) => InkWell(
                            onTap: () {
                              final RenderBox renderBox = context.findRenderObject() as RenderBox;
                              final position = renderBox.localToGlobal(Offset.zero);
                              final size = renderBox.size;
                              _showOptionsMenu(context, position, size);
                            },
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
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
  ///--------------------------------- Schedule Card ---------------------------------------
  Widget _buildTodaySchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithViewAll(
          title: "Today's Schedule",
          showViewAll: false, // Show the "View All" option
        ),
        SizedBox(height: 10.h),
        _buildScheduleCard(
          title: "Team Meeting",
          subtitle: "Discuss Project Timeline",
          time: "9:00 AM",
          date: "02.10.2024",
          showOptions: false,
          initialCompleted: true, // Ensure true branch is reachable
        ),
        _buildScheduleCard(
          title: "Lunch With Sarah",
          subtitle: "At Cafe Milano",
          time: "1:00 PM",
          date: "02.10.2024",
          showOptions: false,
          initialCompleted: true, // Ensure true branch is reachable
        ),
        _buildScheduleCard(
          title: "Evening Reflection",
          subtitle: "Journal About Your Day",
          time: "8:00 PM",
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
              // Left indicator Container
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
              // Main Container
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
                      // Checkbox Container
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
                      // Task details
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
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                SvgPicture.asset("assets/svg/time.svg", width: 14.w, height: 14.h,colorFilter: ColorFilter.mode(svgIconColor, BlendMode.srcIn),),
                                SizedBox(width: 4.w),
                                Text(
                                  time,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: subtitleTextColor,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                SvgPicture.asset("assets/svg/calander.svg", width: 14.w, height: 14.h,colorFilter: ColorFilter.mode(svgIconColor, BlendMode.srcIn),),
                                SizedBox(width: 4.w),
                                Text(
                                  date,
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
                      // Options icon at the end
                      if (showOptions)
                        Builder(
                          builder: (context) => InkWell(
                            onTap: () {
                              final RenderBox renderBox = context.findRenderObject() as RenderBox;
                              final position = renderBox.localToGlobal(Offset.zero);
                              final size = renderBox.size;
                              _showOptionsMenu(context, position, size);
                            },
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
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
  ///--------------------------------- Today's Goal Card ---------------------------------------
  Widget _buildTodayGoalTask() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithViewAll(
          title: "Today's Goal Task",
          showViewAll: true, // Show the "View All" option
        ),
        SizedBox(height: 10.h),
        _buildTodaysGoalCard(
          title: "Morning Workout",
          subtitle: "Goal : Lose 10 Lbs",
          time: "9:00 AM",
          showOptions: false,
          initialCompleted: true, // Ensure true branch is reachable
        ),
        _buildTodaysGoalCard(
          title: "Study Programming",
          subtitle: "Goal : Get A Tech Job",
          time: "1:00 PM",
          showOptions: false,
          initialCompleted: true, // Ensure true branch is reachable
        ),
        _buildTodaysGoalCard(
          title: "Meal Prep For The Week",
          subtitle: "Goal : Lose 10 Lbs",
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
              // Left indicator Container
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
              // Main Container
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
                      // Checkbox Container
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
                      // Task details
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
                                SvgPicture.asset("assets/svg/time.svg", width: 14.w, height: 14.h,colorFilter: ColorFilter.mode(svgIconColor, BlendMode.srcIn),),
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
                      // Options icon at the end
                      if (showOptions)
                        Builder(
                          builder: (context) => InkWell(
                            onTap: () {
                              final RenderBox renderBox = context.findRenderObject() as RenderBox;
                              final position = renderBox.localToGlobal(Offset.zero);
                              final size = renderBox.size;
                              _showOptionsMenuForGoal(context, position, size);
                            },
                            child: Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
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
///--------------------------------- Daily Goals Card ---------------------------------------
  Widget _buildDailyGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleWithViewAll(
          title: "Goals Progress",
          showViewAll: true, // Show the "View All" option
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
                color:  Colors.transparent ,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  bottomLeft: Radius.circular(12.r),
                ),
                border: Border.all(
                  color:  borderColor,
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
                    // Animated Progress Bar
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: progress),
                      duration: Duration(seconds: 1),
                      builder: (context, value, child) {
                        return LinearProgressIndicator(
                          value: value / 100,
                          backgroundColor: Color(0xFF1C2A45), // Light blue background color
                          color: Colors.white, // Dark blue progress color
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
                              fontWeight: FontWeight.w600,// Light purple color
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
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
}
///--------------------------------- Sliver Date Selector Delegate ---------------------------------------
class _SliverDateSelectorDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverDateSelectorDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: backgroundColor,
      elevation: shrinkOffset > 0 ? 2.0 : 0.0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}