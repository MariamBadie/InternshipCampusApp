import 'package:flutter/material.dart';
import '../models/friend_request.dart';
import '../models/notification.dart';
import '../widgets/friend_requests_list.dart';
import '../widgets/notification_list.dart';

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
      type: 'like',
      content: 'Someone liked your post.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
    NotificationModel(
      type: 'comment',
      content: 'Someone commented on your post.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
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
    return NotificationsList(
      notifications: _notifications,
      onDelete: _deleteNotification,
    );
  }
}
