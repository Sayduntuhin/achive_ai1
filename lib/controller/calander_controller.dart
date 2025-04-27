import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController {
  // Reactive variables
  var calendarFormat = CalendarFormat.week.obs;
  var calendarHeight = 0.15.sh.obs;
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;
  var isAnimating = false.obs; // Track animation state

  // Toggle calendar format and update height
  void toggleCalendarFormat() {
    if (isAnimating.value) return; // Prevent multiple toggles during animation

    isAnimating.value = true;

    // Toggle the format
    calendarFormat.value = calendarFormat.value == CalendarFormat.week
        ? CalendarFormat.month
        : CalendarFormat.week;

    // Update the height based on format
    calendarHeight.value = calendarFormat.value == CalendarFormat.week ? 0.15.sh : 0.45.sh;

    // Reset animation state after animation completes
    Future.delayed(const Duration(milliseconds: 300), () {
      isAnimating.value = false;
    });

    print('Toggled to ${calendarFormat.value}'); // Debug log
  }

  // Update selected day
  void selectDay(DateTime selected, DateTime focused) {
    if (selected != selectedDay.value) {
      selectedDay.value = selected;
      focusedDay.value = focused;
      print('Selected day: ${selected.toString()}'); // Debug log
    }
  }

  // Check if a specific day has events (you can implement this logic)
  bool hasEventsForDay(DateTime day) {
    // Implement your logic to check for events on a specific day
    // For now, returning false as placeholder
    return false;
  }

  // Initialize with today's date
  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    selectedDay.value = now;
    focusedDay.value = now;
  }
}
