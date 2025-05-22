import 'dart:async';
import 'package:achive_ai/controller/schedule_task_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import '../model/task.dart';
import '../api/api_service.dart';

class MissedTaskController extends GetxController {
  final Logger _logger = Logger();

  // Reactive variables
  RxList<Task> missedTasks = <Task>[].obs;
  RxBool isLoading = true.obs;
  RxString errorMessage = ''.obs;

  final ApiService apiService = Get.find<ApiService>();

  @override
  void onInit() {
    super.onInit();
    fetchMissedTasks();
  }

  Future<void> fetchMissedTasks() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await ApiService().getMissedTasks();
      if (response['success']) {
        missedTasks.clear();
        for (var taskData in response['data']) {
          final task = Task(
            id: taskData['id'].toString(),
            title: taskData['title'],
            description: taskData['description'],
            date: DateFormat('MM/dd/yyyy').format(DateTime.parse(taskData['schedule_time']).toLocal()),
            time: DateFormat('hh:mm a').format(DateTime.parse(taskData['schedule_time']).toLocal()),
            type: 'Scheduled',
            isCompleted: taskData['status'] == 'done',
            completionDate: taskData['completed_on'] != null
                ? DateFormat('MM/dd/yyyy').format(DateTime.parse(taskData['completed_on']).toLocal())
                : null,
          );
          missedTasks.add(task);
        }
      } else {
        errorMessage.value = response['message'] ?? 'Failed to fetch missed tasks';
      }
    } catch (e) {
      _logger.e('Error fetching missed tasks: $e');
      errorMessage.value = 'Error fetching missed tasks: $e';
    } finally {
      isLoading.value = false;
    }
  }


  Future<Map<String, dynamic>> rescheduleTask(String taskId, String scheduleTime) async {
    try {
      final response = await apiService.rescheduleTask(taskId: taskId, scheduleTime: scheduleTime);
      if (response['success']) {
        final data = response['data'];
        final updatedTask = Task(
          id: data['id'].toString(),
          title: data['title'],
          description: data['description'],
          date: DateFormat('MM/dd/yyyy').format(DateTime.parse(data['schedule_time']).toLocal()),
          time: DateFormat('hh:mm a').format(DateTime.parse(data['schedule_time']).toLocal()),
          type: 'Scheduled',
          isCompleted: data['status'] == 'done',
          completionDate: data['completed_on'] != null
              ? DateFormat('MM/dd/yyyy').format(DateTime.parse(data['completed_on']).toLocal())
              : null,
        );
        missedTasks.removeWhere((task) => task.id == taskId);
        Get.find<ScheduleTaskController>().scheduledTasks.add(updatedTask);
        Get.find<ScheduleTaskController>().syncWithCalendarController();
        missedTasks.refresh();
      }
      return response;
    } catch (e) {
      _logger.e('Error rescheduling task: $e');
      return {
        'success': false,
        'message': 'Error rescheduling task: $e',
      };
    }
  }

  Future<Map<String, dynamic>> markTaskComplete(String taskId) async {
    try {
      final response = await apiService.markTaskComplete(taskId);
      if (response['success']) {
        final task = missedTasks.firstWhere((t) => t.id == taskId);
        task.isCompleted = true;
        missedTasks.refresh();
      }
      return response;
    } catch (e) {
      _logger.e('Error marking task complete: $e');
      return {
        'success': false,
        'message': 'Error marking task as complete: $e',
      };
    }
  }

  Future<Map<String, dynamic>> cancelTask(String taskId) async {
    try {
      final response = await apiService.deleteTask(taskId);
      if (response['success']) {
        missedTasks.removeWhere((task) => task.id == taskId);
        missedTasks.refresh();
      }
      return response;
    } catch (e) {
      _logger.e('Error canceling task: $e');
      return {
        'success': false,
        'message': 'Error canceling task: $e',
      };
    }
  }
}