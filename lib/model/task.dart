class Task {
  final String id;
  final String title;
  final String description;
  final String date;
  final String time;
  final String type;
  late final bool isCompleted;
  final String? completionDate;

  Task({
    required this.id,
    required this.title,
    required this.description,

    required this.date,
    required this.time,
    required this.type,
    this.isCompleted = false,
    this.completionDate,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      completionDate: json['completionDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'type': type,
      'isCompleted': isCompleted,
      'completionDate': completionDate,
    };
  }
}