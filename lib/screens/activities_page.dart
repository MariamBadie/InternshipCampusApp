import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/friend_request.dart';
import '../models/notification.dart';
import '../widgets/friend_requests_list.dart';
import '../widgets/notification_list.dart';
import '../widgets/general_notification_item.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final List<FriendRequest> _friendRequests = [
    FriendRequest(
      name: 'Anas Tamer',
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      profilePic: AssetImage('assets/images/profile-pic.png'),
    ),
    FriendRequest(
      name: 'Hussien Haitham',
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
      profilePic: AssetImage('assets/images/profile-pic.png'),
    ),
  ];

  final List<NotificationModel> _notifications = [
    NotificationModel(
      type: 'alert',
      content: 'Job fair alert! Discover new job opportunities available next week!',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      type: 'like',
      content: '@Anas liked your post.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      type: 'comment',
      content: '@Hussien commented on your post.',
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NotificationModel(
      type: 'other',
      content: 'You have a new notification.',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
    ),
    NotificationModel(type: 'event', content: 'Dont miss the christmas discount!', timestamp: DateTime.now()),
  ];

  void _deleteFriendRequest(int index) {
    setState(() {
      _friendRequests.removeAt(index);
    });
  }

  void _confirmFriendRequest(int index) {
    setState(() {
      _friendRequests.removeAt(index);
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  void _clearAllNotifications() {
    setState(() {
      _notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Friend Requests'),
              Tab(text: 'General Notifications'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendRequestsTab(),
            GeneralNotificationsTab(),
          ],
        ),
      ),
    );
  }

  Widget FriendRequestsTab() {
    return FriendRequestsList(
      requests: _friendRequests,
      onDelete: _deleteFriendRequest,
      onConfirm: _confirmFriendRequest,
    );
  }

  Widget GeneralNotificationsTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: _clearAllNotifications,
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(10),
            separatorBuilder: (BuildContext context, int index) {
              return Align(
                alignment: Alignment.centerRight,
                child: Container(
                  height: 0.5,
                  width: MediaQuery.of(context).size.width / 1.3,
                  child: const Divider(),
                ),
              );
            },
            itemCount: _notifications.length,
            itemBuilder: (BuildContext context, int index) {
              final notification = _notifications[index];
              return GeneralNotificationItem(
                notification: notification,
                profilePic: _getProfilePicture(notification.type),
                onDelete: () => _deleteNotification(index),
              );
            },
          ),
        ),
      ],
    );
  }

  AssetImage _getProfilePicture(String type) {
    switch (type) {
      case 'alert':
        return AssetImage('assets/images/announcement.png');
      case 'like':
      case 'comment':
        return AssetImage('assets/images/profile-pic.png');
      case 'event':
        return AssetImage('assets/images/party-hat.png');
      default:
        return AssetImage('assets/images/bell.png');
    }
  }
}