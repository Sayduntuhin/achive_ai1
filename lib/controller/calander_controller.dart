import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import '../view/home/widgets/task.dart';
import 'package:intl/intl.dart';

class CalendarController extends GetxController {
  final Logger _logger = Logger();
  var tasks = <Task>[].obs;
  var selectedDay = DateTime.now().obs;
  var focusedDay = DateTime.now().obs;
  var calendarFormat = CalendarFormat.month.obs;
  var calendarHeight = 350.h.obs;
  var goals = <String, double>{
    "Lose 10 Lbs": 70.0,
    "Get A Tech Job": 20.0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    loadTasks();
  }

  // Load tasks from shared_preferences
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskJson = prefs.getString('tasks');
    if (taskJson != null) {
      final taskList = jsonDecode(taskJson) as List;
      tasks.value = taskList.map((e) => Task.fromJson(e)).toList();
      _logger.d('Loaded ${tasks.length} tasks');
    }
  }

  // Save tasks to shared_preferences
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskJson = jsonEncode(tasks.map((e) => e.toJson()).toList());
    await prefs.setString('tasks', taskJson);
    _logger.d('Saved ${tasks.length} tasks');
  }

  // Add a new task
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
      goal: goal,
      date: date,
      time: time,
      type: type,
    );
    tasks.add(task);
    saveTasks();
    updateGoalProgress(goal);
    _logger.i('Added task: $title ($type)');
  }

  // Toggle task completion
  void toggleTaskCompletion(String taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      tasks[index] = Task(
        id: tasks[index].id,
        title: tasks[index].title,
        description: tasks[index].description,
        goal: tasks[index].goal,
        date: tasks[index].date,
        time: tasks[index].time,
        isCompleted: !tasks[index].isCompleted,
        type: tasks[index].type,
      );
      saveTasks();
      updateGoalProgress(tasks[index].goal);
      _logger.d('Toggled completion for task: ${tasks[index].title}');
    }
  }

  // Schedule a task (move Any Time task to Scheduled)
  void scheduleTask(String taskId, String newDate, String newTime) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1 && tasks[index].type == "Any Time") {
      tasks[index] = Task(
        id: tasks[index].id,
        title: tasks[index].title,
        description: tasks[index].description,
        goal: tasks[index].goal,
        date: newDate,
        time: newTime,
        isCompleted: tasks[index].isCompleted,
        type: "Scheduled",
      );
      saveTasks();
      _logger.i('Scheduled task: ${tasks[index].title} to $newDate $newTime');
    }
  }

  // Cancel a task
  void cancelTask(String taskId) {
    final index = tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      final task = tasks[index];
      tasks.removeAt(index);
      saveTasks();
      updateGoalProgress(task.goal);
      _logger.i('Canceled task: ${task.title}');
    }
  }

  // Update goal progress based on completed tasks
  void updateGoalProgress(String goal) {
    final goalTasks = tasks.where((task) => task.goal == goal).toList();
    if (goalTasks.isEmpty) return;
    final completedTasks = goalTasks.where((task) => task.isCompleted).length;
    final progress = (completedTasks / goalTasks.length) * 100;
    goals[goal] = progress.clamp(0, 100);
    _logger.d('Updated progress for goal $goal: ${goals[goal]}%');
  }

  // Get tasks for a specific date
  List<Task> getTasksForDate(String date) {
    return tasks.where((task) => task.date == date).toList();
  }

  // Format DateTime to MM/DD/YYYY
  String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  // Select a day
  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    this.selectedDay.value = selectedDay;
    this.focusedDay.value = focusedDay;
    _logger.d('Selected day: ${formatDate(selectedDay)}');
  }

  // Toggle calendar format
  void toggleCalendarFormat() {
    calendarFormat.value = calendarFormat.value == CalendarFormat.month
        ? CalendarFormat.week
        : CalendarFormat.month;
    calendarHeight.value = calendarFormat.value == CalendarFormat.week ? 80.h : 350.h;
    _logger.d('Toggled calendar format to: ${calendarFormat.value}');
  }

  // Get events for a day (for calendar markers)
  List<Task> getEventsForDay(DateTime day) {
    final date = formatDate(day);
    return getTasksForDate(date);
  }
}