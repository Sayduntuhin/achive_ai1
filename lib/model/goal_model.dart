class Goal {
  final int id;
  final String name;
  final String description;
  final double progress;
  final String status;
  final DateTime startTime;
  final DateTime endTime;
  final int user;
  final List<Task> tasks;

  Goal({
    required this.id,
    required this.name,
    required this.description,
    required this.progress,
    required this.status,
    required this.startTime,
    required this.endTime,
    required this.user,
    required this.tasks,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      startTime: _parseDateTime(json['start_time']),
      endTime: _parseDateTime(json['end_time']),
      user: _parseInt(json['user'] ?? 0),
      tasks: (json['tasks'] as List<dynamic>? ?? [])
          .map((task) => Task.fromJson(task))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'progress': progress,
    'status': status,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime.toIso8601String(),
    'user': user,
    'tasks': tasks.map((t) => t.toJson()).toList(),
  };
}

class Task {
  final int id;
  final String name;
  final String description;
  final double progress;
  final int goal;
  final List<Subtask> subtasks;

  Task({
    required this.id,
    required this.name,
    required this.description,
    required this.progress,
    required this.goal,
    required this.subtasks,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: _parseInt(json['id']),
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      goal: _parseInt(json['goal']),
      subtasks: (json['subtasks'] as List<dynamic>? ?? [])
          .map((subtask) => Subtask.fromJson(subtask))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'progress': progress,
    'goal': goal,
    'subtasks': subtasks.map((s) => s.toJson()).toList(),
  };
}

class Subtask {
  final int id;
  final double progress;
  final bool locked;
  final String name;
  final String description;
  final DateTime? scheduleTime;
  final String status;
  final bool isDaily;
  final DateTime? lastWorked;
  final String? eventTime;
  final int recurrence;
  final int recurring;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? notifierId; // Changed to String? for UUID
  final int task;
  final List<int> dependsOnSubtasks;

  Subtask({
    required this.id,
    required this.progress,
    required this.locked,
    required this.name,
    required this.description,
    this.scheduleTime,
    required this.status,
    required this.isDaily,
    this.lastWorked,
    this.eventTime,
    required this.recurrence,
    required this.recurring,
    required this.createdAt,
    required this.updatedAt,
    this.notifierId,
    required this.task,
    required this.dependsOnSubtasks,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      id: _parseInt(json['id']),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      locked: json['locked'] ?? false,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      scheduleTime: json['schedule_time'] != null
          ? _parseDateTime(json['schedule_time'])
          : null,
      status: json['status']?.toString() ?? 'pending',
      isDaily: json['is_daily'] ?? false,
      lastWorked: json['last_worked'] != null
          ? _parseDateTime(json['last_worked'])
          : null,
      eventTime: json['event_time']?.toString(),
      recurrence: _parseInt(json['recurrence'] ?? 0),
      recurring: _parseInt(json['recurring'] ?? 0),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
      notifierId: json['notifier_id']?.toString(),
      task: _parseInt(json['task']),
      dependsOnSubtasks: (json['depends_on_subtasks'] as List<dynamic>? ?? [])
          .map((id) => _parseInt(id))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'progress': progress,
    'locked': locked,
    'name': name,
    'description': description,
    'schedule_time': scheduleTime?.toIso8601String(),
    'status': status,
    'is_daily': isDaily,
    'last_worked': lastWorked?.toIso8601String(),
    'event_time': eventTime,
    'recurrence': recurrence,
    'recurring': recurring,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
    'notifier_id': notifierId,
    'task': task,
    'depends_on_subtasks': dependsOnSubtasks,
  };
}

// Helper function to parse int from dynamic (handles String or int)
int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) {
    try {
      return int.parse(value);
    } catch (e) {
      throw FormatException('Expected an int or String parsable to int, got $value');
    }
  }
  throw FormatException('Expected an int or String parsable to int, got $value');
}

// Helper function to parse DateTime with fallback
DateTime _parseDateTime(dynamic value) {
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (e) {
      return DateTime(1970, 1, 1);
    }
  }
  return DateTime(1970, 1, 1);
}