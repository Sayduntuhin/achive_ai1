import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          /// ✅ SliverAppBar with Header (Pinned)
          SliverAppBar(
            title: _buildHeader(),
            backgroundColor: backgroundColor,
            expandedHeight: 70.h, // Adjust height for styling
          //  floating: false,
            pinned: true, // ✅ Keeps header visible at all times
            automaticallyImplyLeading: false, // Removes default back button
          ),

          /// ✅ Date Selector (Hides on Scroll)
          SliverPersistentHeader(
            pinned: false, // ✅ Hides when scrolling
            delegate: _SliverDateSelectorDelegate(
              child: _buildDateSelector(),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/images/person.png"), // ✅ Add user image
              radius: 20.w,
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5.h),
                Text(
                  "Hello Joshitha",
                  style: TextStyle(fontSize: 16.sp, color: textColor, fontWeight: FontWeight.w700,fontFamily: 'Philosopher'),
                ),
                Text(
                  "I am worth of love and respect",
                  style: TextStyle(fontSize: 12.sp, color: Colors.white70,fontFamily: 'Poppins'),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Icon(Icons.bolt, color: Colors.orangeAccent, size: 24.sp), // ⚡ Icon
            SizedBox(width: 10.w),
            Icon(Icons.notifications_none_outlined   , color: Colors.white, size: 24.sp), // 🔔 Icon
          ],
        ),
      ],
    );
  }

  /// ✅ Date Selector Row (Hides on Scroll)
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
                  color: isSelected ? Colors.orangeAccent : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? Colors.orangeAccent : Colors.white70),
                ),
                child: Text(
                  "${16 + index}",
                  style: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 14.sp),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// ✅ Daily Goals Section
  Widget _buildDailyGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Daily Goals", style: TextStyle(fontSize: 24.sp, color: textColor , fontWeight: FontWeight.w700,fontFamily: 'Philosopher')),
        SizedBox(height: 10.h),
        _buildGoalCard("Daily Meditation", 70),
        _buildGoalCard("Daily Workout", 50),
        _buildGoalCard("Reading", 60),
      ],
    );
  }

  Widget _buildGoalCard(String title, double progress) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14.sp, color: Colors.white)),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.white30,
            color: Colors.orange,
            minHeight: 6.h,
          ),
          SizedBox(height: 8.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text("${progress.toInt()}%", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// ✅ AI Daily Tasks Section
  Widget _buildDailyTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AI Daily Task", style: TextStyle(fontSize: 16.sp, color: Colors.black, fontWeight: FontWeight.bold)),
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
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.radio_button_checked, color: Colors.orangeAccent, size: 18.sp),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontSize: 14.sp, color: Colors.black)),
                  Text(time, style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
                ],
              ),
            ],
          ),
          Icon(Icons.more_vert, color: Colors.black),
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
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Material(
      color: backgroundColor,
      elevation: shrinkOffset > 0 ? 2.0 : 0.0,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverDateSelectorDelegate oldDelegate) => false;
}
