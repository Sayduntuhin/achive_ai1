import 'package:achive_ai/themes/colors.dart';
import 'package:achive_ai/view/home/widgets/calander.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorMain,
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

 /* /// ✅ Date Selector Row (Hides on Scroll)
  Widget _buildDateSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          bool isSelected = index == 6; // Highlight current day
          return Column(
            children: [
              Text(
                ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][index],
                style: TextStyle(color: Colors.white70, fontSize: 12.sp),
              ),
              SizedBox(height: 5.h),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: isSelected ? buttonColor : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: isSelected ? buttonColor : Colors.white70),
                ),
                child: Text(
                  "${16 + index}",
                  style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 14.sp),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }*/

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
          Icon(Icons.more_horiz, color: Colors.black),
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

