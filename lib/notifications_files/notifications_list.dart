
import 'package:campus_app/models/notification_object.dart';
import 'package:campus_app/notifications_files/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key, required this.notif});

  final List<NotificationObject> notif;

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: notif.length,
      itemBuilder: (ctx, index) => NotificationItem(notif[index]),
    );
  }
}
