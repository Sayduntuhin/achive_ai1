import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../api/api_service.dart';
import '../model/goal_model.dart';

class GoalController extends GetxController {
  final Logger _logger = Logger();
  final RxList<Goal> goals = <Goal>[].obs;
  final RxString errorMessage = ''.obs;
  final RxBool isLoading = false.obs;
  bool _isFetching = false; // Prevent concurrent fetches

  @override
  void onInit() {
    super.onInit();
    _logger.i('GoalController initialized');
    fetchGoals();
  }

  @override
  void onClose() {
    _logger.i('GoalController closed');
    super.onClose();
  }

  /// Fetches all goals and their tasks/subtasks.
  Future<void> fetchGoals() async {
    if (_isFetching) {
      _logger.w('FetchGoals already in progress, skipping');
      return;
    }

    try {
      _isFetching = true;
      _logger.i('Fetching goals from API');
      isLoading.value = true;
      errorMessage.value = '';
      goals.clear(); // Clear existing goals to prevent stale data
      final response = await Get.find<ApiService>().getGoals();
      _logger.d('Fetch Goals Response: $response');

      if (response['success']) {
        final List<Goal> newGoals = [];
        for (var goalData in response['goals']) {
          try {
            final goal = Goal.fromJson(goalData);
            // Fetch dependent subtasks for each task
            for (var task in goal.tasks) {
              for (var subtask in task.subtasks) {
                await _fetchDependentSubtasks(subtask, task.subtasks);
              }
            }
            // Check for duplicates by ID
            if (!newGoals.any((g) => g.id == goal.id)) {
              newGoals.add(goal);
            } else {
              _logger.w('Duplicate goal ID ${goal.id} detected, skipping');
            }
          } catch (e) {
            _logger.e('Error parsing goal ID ${goalData['id']}: $e, goalData: $goalData');
            errorMessage.value = 'Some goals could not be loaded. Please try again.';
            continue; // Skip invalid goal but continue processing others
          }
        }
        goals.assignAll(newGoals); // Update goals list atomically
        _logger.i('Goals fetched: ${goals.length} goals');
      } else {
        errorMessage.value = response['message'] ?? 'Failed to fetch goals';
        _logger.e('Error fetching goals: ${errorMessage.value}');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching goals: $e';
      _logger.e('Exception in fetchGoals: $e');
    } finally {
      isLoading.value = false;
      _isFetching = false;
    }
  }

  /// Recursively fetches dependent subtasks if depends_on_subtasks is non-empty.
  Future<void> _fetchDependentSubtasks(Subtask subtask, List<Subtask> allSubtasks) async {
    if (subtask.dependsOnSubtasks.isNotEmpty) {
      for (var depId in subtask.dependsOnSubtasks) {
        final response = await Get.find<ApiService>().getSubtask(depId.toString());
        _logger.d('Fetch Subtask $depId Response: $response');
        if (response['success']) {
          try {
            final depSubtask = Subtask.fromJson(response['subtask']);
            // Add to subtasks list if not already present
            if (!allSubtasks.any((s) => s.id == depSubtask.id)) {
              allSubtasks.add(depSubtask);
              // Recursively fetch dependencies for this subtask
              await _fetchDependentSubtasks(depSubtask, allSubtasks);
            }
          } catch (e) {
            _logger.e('Error parsing subtask $depId: $e, response: ${response['subtask']}');
          }
        } else {
          _logger.e('Error fetching subtask $depId: ${response['message']}');
        }
      }
    }
  }
}