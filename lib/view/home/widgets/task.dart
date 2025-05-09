import 'dart:convert';

class Task {
  final String id;
  final String title;
  final String description;
  final String goal;
  final String date; // Format: "MM/DD/YYYY"
  final String time; // Format: "HH:MM AM/PM" or empty for Any Time tasks
  final bool isCompleted;
  final String type; // "Any Time", "Scheduled", "Goal"

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.goal,
    required this.date,
    required this.time,
    this.isCompleted = false,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'goal': goal,
    'date': date,
    'time': time,
    'isCompleted': isCompleted,
    'type': type,
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    goal: json['goal'],
    date: json['date'],
    time: json['time'],
    isCompleted: json['isCompleted'],
    type: json['type'],
  );
}