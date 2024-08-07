class NotificationModel {
  final String type;
  final String content;
  final DateTime timestamp;

  NotificationModel({
    required this.type,
    required this.content,
    required this.timestamp,
  });

  String get formattedDate {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
}
