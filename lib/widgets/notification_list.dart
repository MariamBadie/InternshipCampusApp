import 'package:flutter/material.dart';
import '../models/notification.dart';
import 'general_notification_item.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({
    Key? key,
    required this.notifications,
    required this.onDelete,
  }) : super(key: key);

  final List<NotificationModel> notifications;
  final void Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (ctx, index) => GeneralNotificationItem(
        notification: notifications[index],
        onDelete: () => onDelete(index),
      ),
    );
  }
}
