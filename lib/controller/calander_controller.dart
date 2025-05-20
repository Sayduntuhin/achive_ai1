import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import '../model/task.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  final Logger _logger = Logger();
  var tasks = <Task>[].obs;
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var calendarFormat = CalendarFormat.week.obs;
  var calendarHeight = 100.h.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskJson = prefs.getString('tasks');
    if (taskJson != null) {
      final taskList = jsonDecode(taskJson) as List;
      tasks.value = taskList.map((e) => Task.fromJson(e)).toList();
      _logger.d('Loaded ${tasks.length} tasks');
    }
  }

  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString('tasks', taskJson);
    _logger.d('Saved ${tasks.length} tasks');
  }

  void addTask({
    required String title,
    required String description,
    required String goal,
    required String date,
    required String time,
    required String type,
  }) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final task = Task(
      id: id,
      title: title,
      description: description,
      date: date,
      time: time,
      type: type,
      completionDate: null,
    );
    tasks.add(task);
    saveTasks();
    _logger.i('Added goal: $title ($type)');
  }

  void toggleTaskCompletion(String taskId, String? completionDate) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      tasks[index] = Task(
        id: tasks[index].id,
        title: tasks[index].title,
        description: tasks[index].description,
        date: tasks[index].date,
        time: tasks[index].time,
        isCompleted: !tasks[index].isCompleted,
        type: tasks[index].type,
        completionDate: completionDate,
      );
      saveTasks();
    }
  }

  void scheduleTask(String taskId, String newDate, String newTime) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1 && tasks[index].type == "Any Time") {
      tasks[index] = Task(
        id: tasks[index].id,
        title: tasks[index].title,
        description: tasks[index].description,
        date: newDate,
        time: newTime,
        isCompleted: tasks[index].isCompleted,
        type: "Scheduled",
        completionDate: tasks[index].completionDate,
      );
      saveTasks();
      _logger.i('Scheduled goal: ${tasks[index].title} to $newDate $newTime');
    }
  }

  void cancelTask(String taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = tasks[index];
      tasks.removeAt(index);
      saveTasks();
      _logger.i('Canceled goal: ${task.title}');
    }
  }



  List<Task> getTasksForDate(String date) {
    return tasks.where((task) => task.date == date).toList();
  }

  String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
    final formattedDate = formatDate(selectedDay);
    _logger.d('Selected day: $formattedDate');
    update(); // Ensure UI refreshes
  }

  void toggleCalendarFormat() {
    calendarFormat.value = calendarFormat.value == CalendarFormat.month
        ? CalendarFormat.week
        : CalendarFormat.month;
    calendarHeight.value = calendarFormat.value == CalendarFormat.week ? 80.h : 350.h;
    _logger.d('Toggled calendar format to: ${calendarFormat.value}');
  }

  List<Task> getEventsForDay(DateTime day) {
    final date = formatDate(day);
    return getTasksForDate(date);
  }
}