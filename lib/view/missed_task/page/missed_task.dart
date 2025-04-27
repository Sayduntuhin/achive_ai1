import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../themes/colors.dart';
import '../../setting/widgets/custom_app_bar.dart';
import '../../widgets/title_with_view_all.dart'; // Ensure you have the right theme setup


// Missed Task Page
class MissedTaskPage extends StatelessWidget {
   MissedTaskPage({super.key});

  // Simulating missed tasks
  final List<Map<String, dynamic>> missedTasks = [
    {
      'title': 'Team Meeting',
      'subtitle': 'Discuss Project Timeline',
      'time': '9am',
      'date': '02.10.2024',
      'completed': false,
    },
    {
      'title': 'Lunch With Sarah',
      'subtitle': 'At Cafe Milano',
      'time': '1pm',
      'date': '02.10.2024',
      'completed': false,
    },
    {
      'title': 'Evening Reflection',
      'subtitle': 'Journal About Your Day',
      'time': '8am',
      'date': '02.10.2024',
      'completed': true,
    },
  ];
   // Method to show the dialog
   void _openScheduleDialog(BuildContext context) {
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (BuildContext context) {
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
                   maxHeight: MediaQuery.of(context).size.height * 0.6, // Adjust max height
                 ),
                 child: Column(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     // Title of the Dialog
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
                           icon: Icon(Icons.close),
                           onPressed: () => Navigator.pop(context),
                           padding: EdgeInsets.zero,
                           constraints: BoxConstraints(),
                           color: Colors.black,
                         ),
                       ],
                     ),
                     SizedBox(height: 20.h),

                     // Date and Time Fields in a Row
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
                                 "New Time",
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
                                   contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                                   hintText: "--:--:--",
                                   hintStyle: TextStyle(color: primaryColor),
                                   suffixIcon: Icon(Icons.access_time, size: 20.sp, color: primaryColor),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ],
                     ),

                     SizedBox(height: 20.h),

                     // Add Task Button
                     Center(
                       child: Container(
                         width: 0.5.sw,
                         height: 0.05.sh,
                         child: ElevatedButton(
                           onPressed: () {
                             // Action when the Add button is pressed
                             Navigator.pop(context); // Close the dialog
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: primaryColor, // Using primary color here
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Missed Task',
          backgroundColor: backgroundColor,
          textColor: primaryColor,
          borderColor: Color(0xffD9D9D9),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Missed Tasks Schedule
            TitleWithViewAll(
              title: "Reschedule missed tasks(7 DAY’S)",
              titleFontSize: 16,
              showViewAll: false, // We don't need the "View All" button here
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView.builder(
                itemCount: missedTasks.length,
                itemBuilder: (context, index) {
                  final task = missedTasks[index];
                  return _buildScheduleCard(
                    task['title'],
                    task['subtitle'],
                    task['time'],
                    task['date'],
                    showOptions: true,
                    initialCompleted: task['completed'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build the missed task card
  Widget _buildScheduleCard(
      String title,
      String subtitle,
      String time,
      String date, {
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
                            } else if (value == 'cancel') {
                              print('Cancel task selected');
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              onTap: () {
                                _openScheduleDialog(context);
                              },
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
      },
    );
  }
}
