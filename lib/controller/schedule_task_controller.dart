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
  var taskLoading = <String, bool>{}.obs; // Added taskLoading
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

      final response = await apiService.getScheduledTasks();
      _logger.d('Fetch Scheduled Tasks response: ${response.toString()}');

      if (response['success']) {
        final List<dynamic> data = response['data'];
        scheduledTasks.clear();
        scheduledTasks.addAll(data.map((taskJson) {
          final scheduleTime = taskJson['schedule_time'];
          String date = '';
          String time = '';
          String type = 'Any Time';
          if (scheduleTime != null) {
            final dateTime = DateTime.parse(scheduleTime).toLocal();
            date = DateFormat('MM/dd/yyyy').format(dateTime);
            time = DateFormat('hh:mm a').format(dateTime);
            type = 'Scheduled';
            _logger.d('Parsed task ${taskJson['id']}: date=$date, time=$time, type=$type');
          } else {
            _logger.d('Parsed task ${taskJson['id']}: Any Time task');
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
                ? DateFormat('MM/dd/yyyy')
                .format(DateTime.parse(taskJson['completed_on']).toLocal())
                : null,
          );
        }).toList());

        scheduledTasks.forEach((task) {
          _logger.d(
              'Task ${task.id}: date=${task.date}, type=${task.type}, completed=${task.isCompleted}, completionDate=${task.completionDate}');
        });

        syncWithCalendarController();
      } else {
        errorMessage.value = response['message'] ?? 'Failed to fetch scheduled tasks';
        _logger.w('Error fetching scheduled tasks: ${errorMessage.value}');
        SnackbarHelper.showErrorSnackbar(errorMessage.value);
      }
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
      final response = await apiService.markTaskComplete(taskId);
      _logger.d('Mark Task Complete response for task $taskId: ${response.toString()}');

      if (response['success']) {
        final index = scheduledTasks.indexWhere((task) => task.id == taskId);
        if (index != -1) {
          final completionDate = response['data']['completed_on'] != null
              ? DateFormat('MM/dd/yyyy')
              .format(DateTime.parse(response['data']['completed_on']).toLocal())
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
          syncWithCalendarController();
          scheduledTasks.refresh();
          _logger.i('Marked task $taskId as complete');
        } else {
          _logger.w('Task with id $taskId not found in scheduledTasks');
          return {
            'success': false,
            'message': 'Task not found',
          };
        }
      } else {
        errorMessage.value = response['message'] ?? 'Failed to mark task as complete';
        _logger.w('Error marking task $taskId: ${errorMessage.value}');
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

      final response = await apiService.deleteTask(taskId);

      if (response['success']) {
        _logger.i('Task $taskId deleted successfully');
        scheduledTasks.removeWhere((task) => task.id == taskId);
        scheduledTasks.refresh();

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

  List<Task> getTasksForDate(String date) {
    final tasksForDate = scheduledTasks.where((task) {
      final isScheduledTask = task.type == 'Scheduled' && task.date == date;
      return isScheduledTask;
    }).toList();
    _logger.d(
        'Tasks for date $date: ${tasksForDate.map((t) => 'ID: ${t.id}, Title: ${t.title}, Type: ${t.type}, CompletionDate: ${t.completionDate}').toList()}');
    return tasksForDate;
  }
}