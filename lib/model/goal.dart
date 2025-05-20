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
      id: json['id'],
      name: json['name'],
      description: json['description'],
      progress: (json['progress'] as num).toDouble(),
      status: json['status'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      user: json['user'],
      tasks: (json['tasks'] as List<dynamic>)
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
      id: json['id'],
      name: json['name'],
      description: json['description'],
      progress: (json['progress'] as num).toDouble(),
      goal: json['goal'],
      subtasks: (json['subtasks'] as List<dynamic>)
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
  final int? notifierId;
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
      id: json['id'],
      progress: (json['progress'] as num).toDouble(),
      locked: json['locked'],
      name: json['name'],
      description: json['description'],
      scheduleTime: json['schedule_time'] != null
          ? DateTime.parse(json['schedule_time'])
          : null,
      status: json['status'],
      isDaily: json['is_daily'],
      lastWorked: json['last_worked'] != null
          ? DateTime.parse(json['last_worked'])
          : null,
      eventTime: json['event_time'],
      recurrence: json['recurrence'],
      recurring: json['recurring'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      notifierId: json['notifier_id'],
      task: json['task'],
      dependsOnSubtasks: (json['depends_on_subtasks'] as List<dynamic>)
          .map((id) => id as int)
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
