import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';
import '../model/task.dart';
import '../api/api_service.dart';
import '../view/widgets/snackbar_helper.dart';
import 'calander_controller.dart';

class ScheduleTaskController extends GetxController {
  final Logger _logger = Logger();
  var scheduledTasks = <Task>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var taskLoading = <String, bool>{}.obs;
  final ApiService apiService = Get.find<ApiService>();
  final CalendarController calendarController = Get.find<CalendarController>();

  @override
  void onInit() {
    super.onInit();
    fetchScheduledTasks();
    calendarController.selectedDay.listen((_) {
      _logger.d('Calendar date changed, refreshing tasks');
      fetchScheduledTasks();
    });
  }

  Future<void> fetchScheduledTasks() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      scheduledTasks.clear();

      // Fetch regular scheduled tasks
      final taskResponse = await apiService.getScheduledTasks();
      _logger.d('Fetch Scheduled Tasks response: $taskResponse');

      // Fetch goal subtasks
      final subtaskResponse = await apiService.getGoalSubtasks();
      _logger.d('Fetch Goal Subtasks response: $subtaskResponse');

      // Process regular tasks
      if (taskResponse['success']) {
        final List<dynamic> taskData = taskResponse['data'];
        scheduledTasks.addAll(taskData.map((taskJson) {
          String date = '';
          String time = '';
          String type = 'Any Time';
          final scheduleTime = taskJson['schedule_time'];
          if (scheduleTime != null) {
            try {
              final dateTime = DateTime.parse(scheduleTime).toLocal();
              date = DateFormat('MM/dd/yyyy').format(dateTime);
              time = DateFormat('hh:mm a').format(dateTime);
              type = 'Scheduled';
              _logger.d('Parsed task ${taskJson['id']}: date=$date, time=$time, type=$type');
            } catch (e) {
              _logger.e('Failed to parse schedule_time for task ${taskJson['id']}: $scheduleTime, error: $e');
              date = '';
              time = '';
              type = 'Any Time';
            }
          }
          return Task(
            id: taskJson['id'].toString(),
            title: taskJson['title'] ?? 'Unknown Title',
            description: taskJson['description'] ?? 'No Description',
            date: date,
            time: time,
            type: type,
            isCompleted: taskJson['status'] == 'done',
            completionDate: taskJson['completed_on'] != null
                ? DateFormat('MM/dd/yyyy').format(DateTime.parse(taskJson['completed_on']).toLocal())
                : null,
            isGoalSubtask: false,
          );
        }).toList());
      } else {
        errorMessage.value = taskResponse['message'] ?? 'Failed to fetch scheduled tasks';
        _logger.w('Error fetching scheduled tasks: ${errorMessage.value}');
      }

      // Process goal subtasks
      if (subtaskResponse['success']) {
        final List<dynamic> subtaskData = subtaskResponse['data'];
        scheduledTasks.addAll(subtaskData.map((subtaskJson) {
          String date = '';
          String time = '';
          final eventDate = subtaskJson['event_occuring_date'];
          final eventTime = subtaskJson['event_occuring_time'];
          if (eventDate != null) {
            try {
              // Assume eventDate is in ISO 8601 format (e.g., 2025-05-22T17:00:00Z)
              final dateTime = DateTime.parse(eventDate).toLocal();
              date = DateFormat('MM/dd/yyyy').format(dateTime);
              time = DateFormat('hh:mm a').format(dateTime);
              _logger.d('Parsed subtask ${subtaskJson['id']}: date=$date, time=$time');
            } catch (e) {
              _logger.e('Failed to parse event_occuring_date for subtask ${subtaskJson['id']}: $eventDate, error: $e');
              // Fallback: Try combining eventDate and eventTime if eventDate isn't ISO 8601
              if (eventTime != null) {
                try {
                  final dateTime = DateTime.parse('$eventDate $eventTime').toLocal();
                  date = DateFormat('MM/dd/yyyy').format(dateTime);
                  time = DateFormat('hh:mm a').format(dateTime);
                  _logger.d('Fallback parsed subtask ${subtaskJson['id']}: date=$date, time=$time');
                } catch (e) {
                  _logger.e('Fallback parse failed for subtask ${subtaskJson['id']}: $eventDate $eventTime, error: $e');
                  date = '';
                  time = '';
                }
              }
            }
          }
          return Task(
            id: subtaskJson['id'].toString(),
            title: subtaskJson['name'] ?? 'Unknown Subtask',
            description: subtaskJson['description'] ?? 'No Description',
            date: date,
            time: time,
            type: 'Scheduled',
            isCompleted: subtaskJson['done'] == true,
            completionDate: subtaskJson['done'] == true
                ? DateFormat('MM/dd/yyyy').format(DateTime.now())
                : null,
            isGoalSubtask: true,
            goalSubtaskId: subtaskJson['id'].toString(),
          );
        }).toList());
      } else {
        errorMessage.value = subtaskResponse['message'] ?? 'Failed to fetch goal subtasks';
        _logger.w('Error fetching goal subtasks: ${errorMessage.value}');
      }

      if (errorMessage.value.isNotEmpty) {
        SnackbarHelper.showErrorSnackbar(errorMessage.value);
      }

      syncWithCalendarController();
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      _logger.e('Unexpected error in fetchScheduledTasks: $e');
      SnackbarHelper.showErrorSnackbar(errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  void syncWithCalendarController() {
    calendarController.tasks.removeWhere((task) => task.type == 'Scheduled');
    calendarController.tasks.addAll(scheduledTasks.where((task) => task.type == 'Scheduled'));
    calendarController.saveTasks();
    _logger.d('Synced ${scheduledTasks.where((task) => task.type == 'Scheduled').length} scheduled tasks with CalendarController');
  }

  Future<Map<String, dynamic>> markTaskComplete(String taskId) async {
    try {
      taskLoading[taskId] = true;
      taskLoading.refresh();

      final task = scheduledTasks.firstWhere((t) => t.id == taskId, orElse: () => Task(
        id: taskId,
        title: '',
        description: '',
        date: '',
        time: '',
        type: 'Scheduled',
        isCompleted: false,
      ));

      Map<String, dynamic> response;

      if (task.isGoalSubtask) {
        response = await apiService.updateSubtask(taskId, {'recurring': 1});
        _logger.d('Mark Subtask Complete response for subtask $taskId: $response');
        if (response['success']) {
          final index = scheduledTasks.indexWhere((t) => t.id == taskId);
          if (index != -1) {
            scheduledTasks[index] = Task(
              id: scheduledTasks[index].id,
              title: scheduledTasks[index].title,
              description: scheduledTasks[index].description,
              date: scheduledTasks[index].date,
              time: scheduledTasks[index].time,
              type: scheduledTasks[index].type,
              isCompleted: response['subtask']['progress'] >= 100.0,
              completionDate: DateFormat('MM/dd/yyyy').format(DateTime.now()),
              isGoalSubtask: true,
              goalSubtaskId: taskId,
            );
          }
        }
      } else {
        response = await apiService.markTaskComplete(taskId);
        _logger.d('Mark Task Complete response for task $taskId: $response');
        if (response['success']) {
          final index = scheduledTasks.indexWhere((t) => t.id == taskId);
          if (index != -1) {
            final completionDate = response['data']['completed_on'] != null
                ? DateFormat('MM/dd/yyyy').format(DateTime.parse(response['data']['completed_on']).toLocal())
                : DateFormat('MM/dd/yyyy').format(DateTime.now());
            scheduledTasks[index] = Task(
              id: scheduledTasks[index].id,
              title: scheduledTasks[index].title,
              description: scheduledTasks[index].description,
              date: scheduledTasks[index].date,
              time: scheduledTasks[index].time,
              type: scheduledTasks[index].type,
              isCompleted: true,
              completionDate: completionDate,
            );
          }
        }
      }

      if (response['success']) {
        syncWithCalendarController();
        scheduledTasks.refresh();
        _logger.i('Marked task/subtask $taskId as complete');
      } else {
        errorMessage.value = response['message'] ?? 'Failed to mark task as complete';
        _logger.w('Error marking task/subtask $taskId: ${errorMessage.value}');
      }
      return response;
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred: $e';
      _logger.e('Unexpected error in markTaskComplete: $e');
      return {
        'success': false,
        'message': 'An unexpected error occurred: $e',
      };
    } finally {
      taskLoading[taskId] = false;
      taskLoading.refresh();
    }
  }

  Future<Map<String, dynamic>> cancelTask(String taskId) async {
    try {
      taskLoading[taskId] = true;
      taskLoading.refresh();

      final task = scheduledTasks.firstWhere((t) => t.id == taskId, orElse: () => Task(
        id: taskId,
        title: '',
        description: '',
        date: '',
        time: '',
        type: 'Scheduled',
        isCompleted: false,
      ));

      if (task.isGoalSubtask) {
        _logger.w('Cannot cancel goal subtask $taskId');
        return {
          'success': false,
          'message': 'Goal subtasks cannot be canceled',
        };
      }

      final response = await apiService.deleteTask(taskId);
      if (response['success']) {
        _logger.i('Task $taskId deleted successfully');
        scheduledTasks.removeWhere((task) => task.id == taskId);
        scheduledTasks.refresh();
        calendarController.tasks.removeWhere((task) => task.id == taskId);
        calendarController.saveTasks();
      }
      return response;
    } catch (e) {
      _logger.e('Error canceling task: $e');
      return {'success': false, 'message': 'Error canceling task: $e'};
    } finally {
      taskLoading[taskId] = false;
      taskLoading.refresh();
    }
  }

  List<Task> getTasksForDate(String date) {
    final tasksForDate = scheduledTasks.where((task) {
      final isScheduledTask = task.type == 'Scheduled' && task.date == date;
      return isScheduledTask;
    }).toList();
    _logger.d(
        'Tasks for date $date: ${tasksForDate.map((t) => 'ID: ${t.id}, Title: ${t.title}, Type: ${t.type}, CompletionDate: ${t.completionDate}, IsGoalSubtask: ${t.isGoalSubtask}').toList()}');
    return tasksForDate;
  }
}