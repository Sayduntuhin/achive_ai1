import 'package:achive_ai/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay; // Default to today
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      color: backgroundColor,
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarFormat: CalendarFormat.week,
        startingDayOfWeek: StartingDayOfWeek.sunday, // ✅ Start week from Sunday

        headerVisible: false,

        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Colors.white, fontSize: 13.sp,fontFamily: "Poppins"),
          weekendStyle: TextStyle(color: Colors.white, fontSize: 13.sp,fontFamily: "Poppins"),
        ),

        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(color: Colors.white, fontSize: 14.sp,fontFamily: ""),
          weekendTextStyle: TextStyle(color: Colors.white, fontSize: 14.sp),

          /// ✅ Ensure every day has a circle
          defaultDecoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white),
          ),
          weekendDecoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white),
          ),
          todayDecoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white),
          ),
          selectedDecoration: BoxDecoration(
            color: buttonColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
