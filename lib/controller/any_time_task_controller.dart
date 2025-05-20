import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../api/api_service.dart';
import '../model/task.dart';
import 'calander_controller.dart';
import 'schedule_task_controller.dart';
import 'package:intl/intl.dart';

class TaskController extends GetxController {
  final ApiService _apiService = ApiService();
  final RxList<Task> anyTimeTasks = <Task>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxMap<String, bool> taskLoading = <String, bool>{}.obs;
  final Logger _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    fetchAnyTimeTasks();
  }

  Future<void> fetchAnyTimeTasks() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _apiService.getAnyTimeTasks();
      if (response['success']) {
        final List<dynamic> taskData = response['data'];
        anyTimeTasks.assignAll(taskData.map((task) {
          final isCompleted = task['status'] != 'on';
          String? completionDate;
          if (isCompleted && task['completed_on'] != null) {
            try {
              final completedOn = DateTime.parse(task['completed_on']);
              completionDate = DateFormat('MM/dd/yyyy').format(completedOn);
            } catch (e) {
              _logger.w('Failed to parse completed_on for task ${task['id']}: ${task['completed_on']}');
              completionDate = null;
            }
          }
          return Task(
            id: task['id'].toString(),
            title: task['title'] ?? 'Unknown Title',
            description: task['description'] ?? 'No Description',
            date: '',
            time: task['schedule_time'] ?? '00:00',
            type: 'Any Time',
            isCompleted: isCompleted,
            completionDate: completionDate,
          );
        }).toList());
        _logger.d('Fetched ${anyTimeTasks.length} Any Time Tasks: ${anyTimeTasks.map((t) => t.toJson())}');
      } else {
        errorMessage.value = response['message'] ?? 'Failed to fetch tasks';
      }
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';
      _logger.e('Error fetching tasks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Task> getTasksForDate(String date) {
    // Only return incomplete tasks or tasks that were completed today
    final tasks = anyTimeTasks.where((task) {
      // Only show incomplete tasks
      if (!task.isCompleted) {
        _logger.d('Task ${task.title} (incomplete) -> Show: true');
        return true;
      }

      // For completed tasks, only show if they were completed on the selected date
      final showCompleted = task.completionDate == date;
      _logger.d('Task ${task.title} (completed on ${task.completionDate}) for date $date -> Show: $showCompleted');
      return showCompleted;
    }).toList();

    _logger.d('Tasks for $date: ${tasks.length} tasks');
    return tasks;
  }

  Future<Map<String, dynamic>> toggleTaskCompletion(String id) async {
    final index = anyTimeTasks.indexWhere((task) => task.id == id);
    if (index == -1) {
      _logger.w('Task with id $id not found');
      return {'success': false, 'message': 'Task not found'};
    }

    taskLoading[id] = true;
    taskLoading.refresh();

    try {
      final response = await _apiService.markTaskComplete(id);
      if (response['success']) {
        final data = response['data'];
        final calendarController = Get.find<CalendarController>();
        String? completionDate;
        if (data['status'] == 'done' && data['completed_on'] != null) {
          try {
            final completedOn = DateTime.parse(data['completed_on']);
            completionDate = DateFormat('MM/dd/yyyy').format(completedOn);
          } catch (e) {
            _logger.w('Failed to parse completed_on for task $id: ${data['completed_on']}');
            completionDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
          }
        }

        _logger.d('Updating task $id: status=${data['status']}, completionDate=$completionDate');

        // Update the task in anyTimeTasks list
        anyTimeTasks[index] = Task(
          id: data['id'].toString(),
          title: data['title'] ?? anyTimeTasks[index].title,
          description: data['description'] ?? anyTimeTasks[index].description,
          date: anyTimeTasks[index].date,
          time: data['schedule_time'] ?? anyTimeTasks[index].time,
          type: anyTimeTasks[index].type,
          isCompleted: data['status'] == 'done',
          completionDate: completionDate,
        );

        anyTimeTasks.refresh();
      }
      return response;
    } catch (e) {
      _logger.e('Error toggling task $id: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred',
      };
    } finally {
      taskLoading[id] = false;
      taskLoading.refresh();
    }
  }

  Future<Map<String, dynamic>> cancelTask(String taskId) async {
    try {
      taskLoading[taskId] = true;
      taskLoading.refresh();

      final response = await _apiService.deleteTask(taskId);

      if (response['success']) {
        _logger.i('Task $taskId deleted successfully');
        anyTimeTasks.removeWhere((task) => task.id == taskId);
        anyTimeTasks.refresh();

        // Sync with CalendarController
        final calendarController = Get.find<CalendarController>();
        calendarController.tasks.removeWhere((task) => task.id == taskId);
        calendarController.saveTasks();

        return {'success': true};
      } else {
        _logger.e('Failed to delete task: ${response['message']}');
        return {
          'success': false,
          'message': response['message'] ?? 'Failed to cancel task',
        };
      }
    } catch (e) {
      _logger.e('Error canceling task: $e');
      return {'success': false, 'message': 'Error canceling task: $e'};
    } finally {
      taskLoading[taskId] = false;
      taskLoading.refresh();
    }
  }
}