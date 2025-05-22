import 'package:logger/logger.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final Logger logger = Logger();
    try {
      return NotificationModel(
        id: json['id']?.toString() ?? '',
        title: json['text']?.toString() ?? 'Untitled',
        description: json['user_email']?.toString() ?? json['text']?.toString() ?? 'No description',
        createdAt: DateTime.tryParse(json['event_time']?.toString() ?? '') ?? DateTime.now(),
        isRead: json['is_read'] as bool? ?? false,
      );
    } catch (e) {
      logger.e('Error parsing NotificationModel from JSON: $e, json: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': title,
      'user_email': description,
      'event_time': createdAt.toIso8601String(),
      'is_read': isRead,
    };
  }
}