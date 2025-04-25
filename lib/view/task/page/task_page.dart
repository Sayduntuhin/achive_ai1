import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../widgets/title_with_view_all.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  String _selectedTab = 'Active'; // Keeps track of the active/completed tab

  List<Map<String, dynamic>> tasks = [
    {
      'title': 'Study Programming',
      'goal': 'Goal: Get A Tech Job',
      'time': '6:00 AM',
      'completed': false,
    },
    {
      'title': 'Meal Prep For The Week',
      'goal': 'Goal: Lose 10 Lbs',
      'time': '6:00 AM',
      'completed': false,
    },
    {
      'title': 'Team Meeting',
      'goal': 'Discuss Project Timeline',
      'time': '6:00 AM',
      'completed': true,
    },
    {
      'title': 'Lunch With Sarah',
      'goal': 'At Cafe Milano',
      'time': '6:00 AM',
      'completed': true,
    },
  ];

  // Toggle between Active and Completed tasks
  void _toggleTab(String tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredTasks = tasks
        .where((task) =>
    (_selectedTab == 'Active' && !task['completed']) ||
        (_selectedTab == 'Completed' && task['completed']))
        .toList();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleWithViewAll(
              title: "Your Task",
              viewAllText: "View Goals",
              showViewAll: true, // Show the "View All" option
            ),
            SizedBox(height: 10.h),
            // Parent Container with changing border color
            Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _selectedTab == 'Active'
                      ? primaryColor
                      : borderColor2, // Change border color based on selected tab
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildTab('Active'),
                  _buildTab('Completed'),
                ],
              ),
            ),
            // Task List
            Expanded(
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return _buildTaskCard(
                    task['title'],
                    task['goal'],
                    task['time'],
                    task['completed'],
                    onChanged: (bool? value) {
                      setState(() {
                        task['completed'] = value ?? false;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

 ///-------------------------------------------build tab-----------------------------------
  Widget _buildTab(String tab) {
    bool isSelected = _selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => _toggleTab(tab),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? (tab == 'Active' ? primaryColor : borderColor2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected
                    ? (tab == 'Active' ?primaryColor : borderColor2)
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                tab,
                style: TextStyle(
                  color: Colors.white ,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  fontFamily: "Philosopher",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

 ///-------------------------------------------build task card------------------------------
  Widget _buildTaskCard(String title, String goal, String time, bool isCompleted,
      {required ValueChanged<bool?> onChanged}) {
    return StatefulBuilder(
      builder: (context, setState) {
        final checkmarkColor = isCompleted ? Color(0xFF088408) : Colors.transparent;
        final borderColor = isCompleted ? Color(0xFF088408) : Colors.transparent;
        final titleTextColor = isCompleted ? Color(0xFF088408) : Color(0xff1C2A45);
        final subtitleTextColor = isCompleted ? Color(0xFFAAAAAA) : Colors.white;
        final svgIconColor = isCompleted ? Color(0xFF088408) : Color(0xff1C2A45);

        return GestureDetector(
          onTap: () {
            setState(() {
              isCompleted = !isCompleted;
            });
            onChanged(isCompleted); // Update the state when clicked
          },
          child: Row(
            children: [
              // Left indicator Container (Checkbox)
              Container(
                padding: EdgeInsets.all(16.w),
                margin: EdgeInsets.only(bottom: 10.h),
                width: 10.w,
                height: 0.12.sh,
                decoration: BoxDecoration(
                  color: isCompleted ? borderColor : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.r),
                    bottomLeft: Radius.circular(12.r),
                  ),
                  border: Border.all(
                    color: isCompleted ? Colors.transparent : Colors.blue,
                    width: 1,
                  ),
                ),
              ),
              // Main Task Container
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
                              goal,
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
                      // Options icon (if any)
                      if (true) // This can be modified based on a condition for options
                        Builder(
                          builder: (context) => InkWell(
                            onTap: () {
                              // Action when options are tapped
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

}
