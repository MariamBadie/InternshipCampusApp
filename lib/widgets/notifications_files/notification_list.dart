import 'package:campus_app/models/NotificationObject.dart';
import 'package:campus_app/widgets/notifications_files/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key, required this.notif, required this.onDelete});

  final List<NotificationObject> notif;
  final Function(int) onDelete;

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: notif.length,
      itemBuilder: (ctx, index) => NotificationItem(
        notif[index],
        () => onDelete(index),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import '../models/notification.dart';
// import 'general_notification_item.dart';

// class NotificationsList extends StatelessWidget {
//   final List<NotificationModel> notifications;
//   final Function(int) onDelete;
//   final Map<String, IconData>? iconMap;

//   const NotificationsList({
//     Key? key,
//     required this.notifications,
//     required this.onDelete,
//     this.iconMap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: notifications.length,
//       itemBuilder: (ctx, index) {
//         final notification = notifications[index];
//         final icon = iconMap?[notification.type] ?? Icons.notification_important;
//         return GeneralNotificationItem(
//           notification: notification,
          
//           profilePic: _getProfilePicture(notification.type),
//           onDelete: () => onDelete(index),
//         );
//       },
//     );
//   }

//   AssetImage _getProfilePicture(String type) {
//     switch (type) {
//       case 'event':
//         return AssetImage('assets/images/announcement.png');
//       case 'like':
//       case 'comment':
//         return AssetImage('assets/images/profile-pic.png');
//       default:
//         return AssetImage('assets/images/bell.png');
//     }
//   }
// }