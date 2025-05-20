import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../api/api_service.dart';
import '../model/goal.dart';

class GoalController extends GetxController {
  final Logger _logger = Logger();
  final RxList<Goal> goals = <Goal>[].obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchGoals();
  }

  /// Fetches all goals and their tasks/subtasks.
  Future<void> fetchGoals() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final response = await Get.find<ApiService>().getGoals();
      _logger.d('Fetch Goals Response: $response');

      if (response['success']) {
        goals.clear();
        for (var goalData in response['goals']) {
          final goal = Goal.fromJson(goalData);
          // Fetch dependent subtasks for each task
          for (var task in goal.tasks) {
            for (var subtask in task.subtasks) {
              await _fetchDependentSubtasks(subtask, task.subtasks);
            }
          }
          goals.add(goal);
        }
        _logger.d('Goals fetched: ${goals.map((g) => g.toJson())}');
      } else {
        errorMessage.value = response['message'] ?? 'Failed to fetch goals';
        _logger.e('Error fetching goals: ${errorMessage.value}');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching goals: $e';
      _logger.e('Exception in fetchGoals: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Recursively fetches dependent subtasks if depends_on_subtasks is non-empty.
  Future<void> _fetchDependentSubtasks(Subtask subtask, List<Subtask> allSubtasks) async {
    if (subtask.dependsOnSubtasks.isNotEmpty) {
      for (var depId in subtask.dependsOnSubtasks) {
        final response = await Get.find<ApiService>().getSubtask(depId.toString());
        _logger.d('Fetch Subtask $depId Response: $response');
        if (response['success']) {
          final depSubtask = Subtask.fromJson(response['subtask']);
          // Add to subtasks list if not already present
          if (!allSubtasks.any((s) => s.id == depSubtask.id)) {
            allSubtasks.add(depSubtask);
            // Recursively fetch dependencies for this subtask
            await _fetchDependentSubtasks(depSubtask, allSubtasks);
          }
        } else {
          _logger.e('Error fetching subtask $depId: ${response['message']}');
        }
      }
    }
  }
}