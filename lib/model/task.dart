import 'package:intl/intl.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String type;
  late final bool isCompleted;
  final String? completionDate;
  final bool isGoalSubtask;
  final String? goalSubtaskId;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.type,
    this.isCompleted = false,
    this.completionDate,
    this.isGoalSubtask = false,
    this.goalSubtaskId,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    // Determine if this is a goal subtask based on the presence of 'name' or 'done'
    final isGoalSubtask = json.containsKey('name') || json.containsKey('done');

    // Common fields
    final id = json['id']?.toString() ?? '';
    final title = isGoalSubtask ? json['name'] ?? '' : json['title'] ?? '';
    final description = json['description'] ?? '';

    // Completion status
    final isCompleted = isGoalSubtask
        ? json['done'] == true
        : json['status'] == 'done' || json['isCompleted'] == true;

    // Date and time parsing
    String date = '';
    String time = '';
    String? completionDate = json['completed_on'] ?? json['completionDate'];
    String type = isGoalSubtask ? 'Scheduled' : (json['type'] ?? 'Any Time');

    if (isGoalSubtask) {
      // Handle goal subtask date/time
      final eventDate = json['event_occuring_date'];
      final eventTime = json['event_occuring_time'];
      if (eventDate != null) {
        try {
          // Try parsing eventDate as ISO 8601
          final dateTime = DateTime.parse(eventDate).toLocal();
          date = DateFormat('MM/dd/yyyy').format(dateTime);
          time = DateFormat('hh:mm a').format(dateTime);
          if (json['done'] == true && completionDate == null) {
            completionDate = date;
          }
        } catch (e) {
          // Fallback: Try combining eventDate and eventTime
          if (eventTime != null) {
            try {
              final dateTime = DateTime.parse('$eventDate $eventTime').toLocal();
              date = DateFormat('MM/dd/yyyy').format(dateTime);
              time = DateFormat('hh:mm a').format(dateTime);
              if (json['done'] == true && completionDate == null) {
                completionDate = date;
              }
            } catch (e) {
              // Log error but continue with empty date/time
              print('Failed to parse subtask date/time: $eventDate $eventTime, error: $e');
            }
          }
        }
      }
    } else {
      // Handle regular task date/time
      final scheduleTime = json['schedule_time'];
      if (scheduleTime != null) {
        try {
          final dateTime = DateTime.parse(scheduleTime).toLocal();
          date = DateFormat('MM/dd/yyyy').format(dateTime);
          time = DateFormat('hh:mm a').format(dateTime);
          type = 'Scheduled';
        } catch (e) {
          print('Failed to parse schedule_time: $scheduleTime, error: $e');
        }
      }
    }

    return Task(
      id: id,
      title: title,
      description: description,
      date: date,
      time: time,
      type: type,
      isCompleted: isCompleted,
      completionDate: completionDate,
      isGoalSubtask: isGoalSubtask,
      goalSubtaskId: isGoalSubtask ? id : null,
    );
  }

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'description': description,
      'date': date,
      'time': time,
      'type': type,
      'isCompleted': isCompleted,
      'completionDate': completionDate,
      'isGoalSubtask': isGoalSubtask,
      'goalSubtaskId': goalSubtaskId,
    };

    // Map title to 'name' for goal subtasks, 'title' for regular tasks
    if (isGoalSubtask) {
      json['name'] = title;
    } else {
      json['title'] = title;
    }

    return json;
  }
}