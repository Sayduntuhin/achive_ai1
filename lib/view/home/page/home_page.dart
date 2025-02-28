import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DailyTasksScreen extends StatelessWidget {
  const DailyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF123B4E),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Section
                _buildHeader(),
                SizedBox(height: 20.h),
          
                /// Date Selector
                _buildDateSelector(),
                SizedBox(height: 20.h),
          
                /// Daily Goals
                _buildDailyGoals(),
                SizedBox(height: 20.h),
          
                /// AI Daily Task Section
                _buildDailyTasks(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Header with Profile Info
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              radius: 25.w,
              child: Icon(Icons.person, color: Colors.grey.shade700),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello Joshitha",
                  style: TextStyle(fontSize: 18.sp, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                Text(
                  "I am your AI assistant",
                  style: TextStyle(fontSize: 12.sp, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        Icon(Icons.notifications, color: Colors.white, size: 26.sp),
      ],
    );
  }

  /// Date Selector Row
  Widget _buildDateSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
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
                color: index == 6 ? Colors.orangeAccent : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white70),
              ),
              child: Text(
                "${18 + index}",
                style: TextStyle(color: Colors.white, fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      }),
    );
  }

  /// Daily Goals Section
  Widget _buildDailyGoals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Daily Goals", style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 10.h),
        _buildGoalCard("Daily Meditation", 70),
        _buildGoalCard("Daily Workout", 50),
      ],
    );
  }

  Widget _buildGoalCard(String title, double progress) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(color: Colors.teal.shade800, borderRadius: BorderRadius.circular(12.r)),
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

  /// AI Daily Tasks Section
  Widget _buildDailyTasks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("AI Daily Task", style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold)),
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
                  Text(title, style: TextStyle(fontSize: 14.sp, color: Colors.white)),
                  Text(time, style: TextStyle(fontSize: 12.sp, color: Colors.white70)),
                ],
              ),
            ],
          ),
          Icon(Icons.more_vert, color: Colors.white),
        ],
      ),
    );
  }



}
