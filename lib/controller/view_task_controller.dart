import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../api/api_service.dart';
import '../model/goal_model.dart';
import '../view/widgets/snackbar_helper.dart';

class ViewTaskController extends GetxController {
  final Logger _logger = Logger();
  late Goal goal;
  final RxList<Subtask> allSubtasks = <Subtask>[].obs;
  final RxDouble progress = 0.0.obs;
  final RxDouble consistency = 0.0.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      if (Get.arguments is Goal) {
        goal = Get.arguments as Goal;
        _logger.d('ViewTaskController initialized with goal: ${goal.name}');
        _initializeSubtasks();
        _updateProgressAndConsistency();
      } else {
        throw Exception('Invalid navigation arguments: Expected Goal object');
      }
    } catch (e) {
      errorMessage.value = 'Error initializing tasks: $e';
      _logger.e('Error in ViewTaskController onInit: $e');
    }
  }

  void _initializeSubtasks() {
    allSubtasks.clear();
    allSubtasks.addAll(goal.tasks.expand((task) => task.subtasks));
    _logger.d('Initialized ${allSubtasks.length} subtasks for goal: ${goal.name}');
  }

  void _updateProgressAndConsistency() {
    if (allSubtasks.isEmpty) {
      progress.value = 0.0;
      consistency.value = 0.0;
      _logger.d('No subtasks found, progress and consistency set to 0');
      return;
    }

    // Progress: percentage of subtasks with progress >= 100.0
    int completedCount = allSubtasks.where((subtask) => subtask.progress >= 100.0).length;
    progress.value = (completedCount / allSubtasks.length) * 100;

    // Consistency: average progress of all subtasks
    double totalProgress = allSubtasks.fold(0.0, (sum, subtask) => sum + subtask.progress);
    consistency.value = totalProgress / allSubtasks.length;

    _logger.d('Updated progress: ${progress.value.toStringAsFixed(2)}%, consistency: ${consistency.value.toStringAsFixed(2)}%');
  }

  bool isSubtaskLocked(Subtask subtask) {
    if (!subtask.locked) return false;
    if (subtask.dependsOnSubtasks.isEmpty) return subtask.locked;

    return subtask.dependsOnSubtasks.any((depId) {
      final depSubtask = allSubtasks.firstWhere(
            (s) => s.id == depId,
        orElse: () => Subtask(
          id: depId,
          progress: 0.0,
          locked: true,
          name: '',
          description: '',
          status: 'pending',
          isDaily: false,
          recurrence: 0,
          recurring: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          task: 0,
          dependsOnSubtasks: [],
        ),
      );
      return depSubtask.progress < 100.0; // Check progress instead of status
    });
  }

  Future<void> toggleSubtaskCompletion(Subtask subtask) async {
    if (isSubtaskLocked(subtask)) {
      _logger.w('Cannot toggle subtask ID: ${subtask.id}, name: ${subtask.name}: it is locked');
      errorMessage.value = 'This task is locked. Complete dependent tasks first.';
      return;
    }

    try {
      final response = await Get.find<ApiService>().updateSubtask(
        subtask.id.toString(),
        {'recurring': 1},
      );
      _logger.d('Update subtask ${subtask.id} response: $response');

      if (response['success']) {
        final updatedSubtask = Subtask.fromJson(response['subtask']);
        final index = allSubtasks.indexWhere((s) => s.id == subtask.id);
        if (index != -1) {
          allSubtasks[index] = updatedSubtask;
          _updateProgressAndConsistency();
          _logger.i('Subtask ${subtask.id} updated: ${updatedSubtask.status}, progress: ${updatedSubtask.progress}');
          errorMessage.value = '';
          SnackbarHelper.showSuccessSnackbar('Task "${subtask.name}" updated successfully!');
        } else {
          _logger.e('Subtask ${subtask.id} not found in allSubtasks');
          errorMessage.value = 'Error: Task not found';
        }
      } else {
        errorMessage.value = response['message'] ?? 'Failed to update task';
        _logger.e('Error updating subtask ${subtask.id}: ${response['message']}');
      }
    } catch (e) {
      errorMessage.value = 'Error updating task: $e';
      _logger.e('Exception updating subtask ${subtask.id}: $e');
    }
  }
}