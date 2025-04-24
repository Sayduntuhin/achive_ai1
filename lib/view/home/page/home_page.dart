import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/home/widgets/calander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Show disclaimer dialog when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDisclaimerDialog(context);
    });
  }
  Future<void> _checkAndShowDisclaimerDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final hasShownDisclaimer = prefs.getBool('hasShownDisclaimer') ?? false;

    if (!hasShownDisclaimer) {
      // Show dialog if it hasn't been shown before
      _showDisclaimerDialog(context);
      // Set flag to true to prevent showing again
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
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title section with light blue background
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Color(0xFFD4EBEF), // Light blue color from the image
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
                        color: titleColor, // Teal-blue color for the title
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MyPerfectLife AI is designed to provide guidance and suggestions to help you achieve your personal goals. However, please note the following:',
                        style: TextStyle(fontSize: 10.sp,fontFamily: 'Poppins', color: Colors.black),
                      ),
                      SizedBox(height: 16),
                      // Bullet points with better formatting
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

                      // Button centered at the bottom
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4A8F9F), // Teal-blue button color
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

// Helper widget for formatted bullet points
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

            style: TextStyle(fontSize: 10.sp,fontFamily: 'Poppins', color: Colors.black),
          ),
        ),
      ],
    );
  }

  // Show popup menu when three dots are clicked
  void _showOptionsMenu(BuildContext context, Offset position) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          position.dx,
          position.dy,
          position.dx + 1,
          position.dy + 1
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      color: Colors.white,
      items: [
        // Add to Schedule Option
        PopupMenuItem(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          height: 48.h,
          child: Row(
            children: [
              Icon(Icons.access_time, color: Color(0xFF4A9FB5), size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                "Add To Schedule",
                style: TextStyle(
                  color: Color(0xFF4A9FB5),
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          onTap: () {
            // Add your logic for adding to schedule
          },
        ),

        // Divider
        PopupMenuItem(
          enabled: false,
          height: 1,
          padding: EdgeInsets.zero,
          child: Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.2)),
        ),

        // Cancel Task Option
        PopupMenuItem(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          height: 48.h,
          child: Row(
            children: [
              Icon(Icons.delete_outline, color: Color(0xFFFF5A5A), size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                "Cancel Task",
                style: TextStyle(
                  color: Color(0xFFFF5A5A),
                  fontSize: 16.sp,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          /// ✅ SliverAppBar with Header (Pinned)
          SliverAppBar(
            title: _buildHeader(),
            backgroundColor: backgroundColor,
            expandedHeight: 0.08.sh,
            // Adjust height for styling
            floating: false,
            pinned: true,
            // ✅ Keeps header visible at all times
            automaticallyImplyLeading: false, // Removes default back button
          ),

          /// ✅ Date Selector (Hides on Scroll)
          SliverPersistentHeader(
            pinned: false, // ✅ Hides when scrolling
            delegate: _SliverDateSelectorDelegate(
              child: CalendarWidget(),
              height: 100.h,
            ),
          ),

          /// ✅ Scrollable Content Below
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Added Task Lists from the image
                    _buildAnyTimeTasks(),
                    SizedBox(height: 20.h),
                    _buildTodaySchedule(),
                    SizedBox(height: 20.h),
                    _buildDailyGoals(),
                    SizedBox(height: 20.h),
                    _buildDailyTasks(),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  /// Any Time Tasks Section (From Image 1)
  Widget _buildAnyTimeTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Any Time Tasks",
          style: TextStyle(
            fontSize: 24.sp,
            color: Color(0xFF4A9FB5), // Teal blue from image
            fontWeight: FontWeight.w700,
            fontFamily: 'Philosopher',
          ),
        ),
        SizedBox(height: 10.h),

        // Task 1 - Completed
        _buildTaskCard(
          isCompleted: true,
          title: "Read A Chapter Of Your Book",
          subtitle: "Personal Development",
          showOptions: false,
        ),

        // Task 2
        _buildTaskCard(
          isCompleted: false,
          title: "Drink 8 Glasses Of Water",
          subtitle: "Stay Hydrated",
          showOptions: true,
        ),

        // Task 3
        _buildTaskCard(
          isCompleted: false,
          title: "Meditate For 10 Minutes",
          subtitle: "Focus On Breathing",
          showOptions: true,
        ),
      ],
    );
  }

  /// Today's Schedule Section (From Image 1)
  Widget _buildTodaySchedule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Schedule",
          style: TextStyle(
            fontSize: 24.sp,
            color: Color(0xFF4A9FB5), // Teal blue from image
            fontWeight: FontWeight.w700,
            fontFamily: 'Philosopher',
          ),
        ),
        SizedBox(height: 10.h),

        // Meeting - Completed
        _buildScheduleCard(
          isCompleted: true,
          title: "Team Meeting",
          subtitle: "Discuss Project Timeline",
          time: "9:00 AM",
          date: "02.10.2024",
          showOptions: false,
        ),

        // Lunch - Completed
        _buildScheduleCard(
          isCompleted: true,
          title: "Lunch With Sarah",
          subtitle: "At Cafe Milano",
          time: "1:00 PM",
          date: "02.10.2024",
          showOptions: false,
        ),

        // Evening Reflection
        _buildScheduleCard(
          isCompleted: false,
          title: "Evening Reflection",
          subtitle: "Journal About Your Day",
          time: "8:00 PM",
          date: "02.10.2024",
          showOptions: true,
        ),
      ],
    );
  }

  /// Task Card for Any Time Tasks
  Widget _buildTaskCard({
    required bool isCompleted,
    required String title,
    required String subtitle,
    bool showOptions = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: isCompleted
            ? Color(0xFF1E3B24) // Dark green for completed tasks
            : Color(0xFF4A9FB5).withOpacity(0.3), // Light blue for pending tasks
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCompleted
              ? Color(0xFF4CAF50) // Green border for completed
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Checkbox or circle
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Color(0xFF4CAF50) : Colors.transparent,
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? Color(0xFF4CAF50) : Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),

          // Options icon (three dots)
          if (showOptions)
            InkWell(
              onTap: () {
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final position = renderBox.localToGlobal(Offset.zero);
                _showOptionsMenu(context, position);
              },
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 24.sp,
              ),
            ),
        ],
      ),
    );
  }

  /// Schedule Card for Today's Schedule
  Widget _buildScheduleCard({
    required bool isCompleted,
    required String title,
    required String subtitle,
    required String time,
    required String date,
    bool showOptions = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: isCompleted
            ? Color(0xFF1E3B24) // Dark green for completed tasks
            : Color(0xFF4A9FB5).withOpacity(0.3), // Light blue for pending tasks
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isCompleted
              ? Color(0xFF4CAF50) // Green border for completed
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Checkbox or circle
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Color(0xFF4CAF50) : Colors.transparent,
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: isCompleted ? Color(0xFF4CAF50) : Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white70,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white70, size: 12.sp),
                    SizedBox(width: 4.w),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white70,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(Icons.calendar_today, color: Colors.white70, size: 12.sp),
                    SizedBox(width: 4.w),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white70,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Options icon (three dots)
          if (showOptions)
            Builder(
              builder: (context) => InkWell(
                onTap: () {
                  final RenderBox renderBox = context.findRenderObject() as RenderBox;
                  final offset = renderBox.localToGlobal(Offset.zero);
                  _showOptionsMenu(
                      context,
                      Offset(offset.dx, offset.dy + 24.h)
                  );
                },
                child: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ✅ Header inside AppBar (Always Visible)
  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: 0.01.sh),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// ✅ Profile Section
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/person.png"),
            radius: 20.w, // ✅ User Profile Image
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

          /// ✅ Icons (Lightning & Notification with Badge)
          InkWell(
              onTap: (){
                Get.toNamed("/upgradePlan");
              },
              child: Icon(Icons.bolt, color: buttonColor, size: 30.sp)), // ⚡ Icon

          /// ✅ Notification Icon with Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.notifications_none_outlined,
                  color: Colors.white, size: 30.sp), // 🔔 Icon

              /// ✅ Notification Badge
              Positioned(
                right: -1, // Adjust position
                top: -4,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.red, // Notification Badge Color
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 15.w,
                    minHeight: 15.w,
                  ),
                  child: Center(
                    child: Text(
                      "3", // ✅ Dynamic Notification Count
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

  /// ✅ Daily Goals Section
  Widget _buildDailyGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Daily Goals",
            style: TextStyle(
                fontSize: 24.sp,
                color: textColor,
                fontWeight: FontWeight.w700,
                fontFamily: 'Philosopher')),
        SizedBox(height: 10.h),
        _buildGoalCard("Daily Meditation", 70),
        _buildGoalCard("Daily Workout", 50),
        _buildGoalCard("Reading", 60),
      ],
    );
  }

  Widget _buildGoalCard(String title, double initialProgress) {
    return StatefulBuilder(
      builder: (context, setState) {
        double progress = initialProgress;
        return Container(
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 10.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
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
                        fontFamily: 'Philosopher'),
                  ),
                  Spacer(),
                  Text(
                    "${progress.toInt()}%",
                    style: TextStyle(
                        color: textColor,
                        fontSize: 16.sp,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                "30 Days",
                style: TextStyle(
                    fontSize: 10.sp,
                    color: const Color(0xffAAAAAA),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 8.h),

              /// ✅ Slider instead of LinearProgressIndicator
              LinearProgressIndicator(
                borderRadius: BorderRadius.circular(10.r),
                value: progress / 100,
                backgroundColor: Colors.white30,
                color: titleColor,
                minHeight: 8.h,
              ),
              // Slider(value: progress, onChanged: (value) {}),
              /* Slider(
                value: progress,
                min: 0,
                max: 100,
                activeColor: titleColor,
                inactiveColor: Colors.white30,
                onChanged: (value) {
                  setState(() {
                    progress = value;
                  });
                },
              ),*/

            ],
          ),
        );
      },
    );
  }

  /// ✅ AI Daily Tasks Section
  Widget _buildDailyTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AI Daily Task",
            style: TextStyle(
                fontSize: 24.sp,
                color: textColor,
                fontWeight: FontWeight.w700,
                fontFamily: 'Philosopher')),
        SizedBox(height: 10.h),
        _buildTaskItem("Breakfast", "08:00 AM"),
        _buildTaskItem("Workout", "06:00 PM"),
        _buildTaskItem("Marketing", "02:00 PM"),
      ],
    );
  }

  Widget _buildTaskItem(String title, String time) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.radio_button_checked,
                  color: buttonColor, size: 18.sp),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(fontSize: 14.sp, color: Colors.black)),
                  Text(time,
                      style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
                ],
              ),
            ],
          ),
          Builder(
            builder: (context) => InkWell(
              onTap: () {
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final offset = renderBox.localToGlobal(Offset.zero);
                _showOptionsMenu(
                    context,
                    Offset(offset.dx, offset.dy + 24.h)
                );
              },
              child: Icon(Icons.more_horiz, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ Persistent Header Delegate for Date Selector (Hides on Scroll)
class _SliverDateSelectorDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  _SliverDateSelectorDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: backgroundColor,
      elevation: shrinkOffset > 0 ? 2.0 : 0.0,
      child: child,
    );
  }
/*  @override
  bool shouldRebuild(_SliverDateSelectorDelegate oldDelegate) => false;*/

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true; // Rebuild if the delegate changes
  }
}