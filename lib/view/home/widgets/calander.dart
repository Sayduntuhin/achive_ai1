import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controller/calander_controller.dart';
import 'package:achive_ai/themes/colors.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CalendarController controller = Get.find<CalendarController>();

    return Obx(
          () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: controller.calendarHeight.value,
        color: backgroundColor,
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TableCalendar(
                key: ValueKey(controller.calendarFormat.value),
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) => isSameDay(controller.selectedDay.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  controller.selectDay(selectedDay, focusedDay);
                },
                calendarFormat: controller.calendarFormat.value,
                onFormatChanged: (format) {
                  controller.calendarFormat.value = format;
                  controller.calendarHeight.value = format == CalendarFormat.week ? 150.h : 500.h; // Increased month view height
                },
                onCalendarCreated: (pageController) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    print('TableCalendar height (${controller.calendarFormat.value}): ${context.size?.height}');
                  });
                },
                startingDayOfWeek: StartingDayOfWeek.sunday,
                eventLoader: controller.getEventsForDay,
                headerVisible: controller.calendarFormat.value == CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp, // Reduced header text size
                    fontFamily: "Poppins",
                  ),
                  leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white, size: 24.sp),
                  rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white, size: 24.sp),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: "Poppins",
                  ),
                  weekendStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontFamily: "Poppins",
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontFamily: "Poppins",
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontFamily: "Poppins",
                  ),
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
                  markerDecoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.toggleCalendarFormat();
                print('Dropdown clicked');
              },
              child: Icon(
                controller.calendarFormat.value == CalendarFormat.week
                    ? Icons.keyboard_arrow_down
                    : Icons.keyboard_arrow_up,
                color: Colors.cyan,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}