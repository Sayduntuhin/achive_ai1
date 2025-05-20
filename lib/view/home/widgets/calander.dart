import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          () => AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: Container(
          color: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Calendar - will resize automatically based on content
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: 0.0,
                      child: child,
                    ),
                  );
                },
                child: TableCalendar(
                  key: ValueKey(controller.calendarFormat.value),
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: controller.focusedDay.value,
                  selectedDayPredicate: (day) => isSameDay(controller.selectedDay.value, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    controller.selectDay(selectedDay, focusedDay);
                    HapticFeedback.lightImpact();
                  },
                  calendarFormat: controller.calendarFormat.value,
                  onFormatChanged: (format) {
                    controller.calendarFormat.value = format;
                  },
                  startingDayOfWeek: StartingDayOfWeek.sunday,
                  eventLoader: controller.getEventsForDay,
                  headerVisible: controller.calendarFormat.value == CalendarFormat.month,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Poppins",
                    ),
                    leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white, size: 24.sp),
                    rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white, size: 24.sp),
                    titleCentered: true,
                    headerPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
                    headerMargin: EdgeInsets.only(bottom: 8.h),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                    weekendStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.2), width: 1)),
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
                    outsideTextStyle: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13.sp,
                      fontFamily: "Poppins",
                    ),
                    defaultDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    weekendDecoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: buttonColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: buttonColor.withOpacity(0.4),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    markerDecoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    markersMaxCount: 3,
                    cellMargin: EdgeInsets.all(4.w),
                    isTodayHighlighted: true,
                    cellPadding: EdgeInsets.all(5.w),
                  ),
                  // Adaptive row height based on format
                  rowHeight: MediaQuery.of(context).size.height *
                      (controller.calendarFormat.value == CalendarFormat.week ? 0.08 : 0.06),
                  availableCalendarFormats: const {
                    CalendarFormat.month: 'Month',
                    CalendarFormat.week: 'Week',
                  },
                  // Enhanced selected date display
                  calendarBuilders: CalendarBuilders(
                    selectedBuilder: (context, date, events) {
                      return TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.8, end: 1.0),
                        duration: const Duration(milliseconds: 200),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              margin: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: buttonColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: buttonColor.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Toggle button with improved animation
              Container(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      controller.toggleCalendarFormat();
                    },
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.calendarFormat.value == CalendarFormat.week ? "Show Month" : "Show Week",
                            style: TextStyle(
                              color: Colors.cyan,
                              fontSize: 14.sp,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          AnimatedRotation(
                            turns: controller.calendarFormat.value == CalendarFormat.week ? 0.0 : 0.5,
                            duration: const Duration(milliseconds: 250),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.cyan,
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}