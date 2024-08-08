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
      type: 'comment',
      content: 'New Comment! Mayar Ahmed commented on your post!',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NotificationModel(
      type: 'alert',
      content: 'Job Fair Alert! Discover companies and internships available next Monday!',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      type: 'mention',
      content: 'Mention Alert! Salma Sayed mentioned you in a comment. See what they have to say!',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      type: 'offer',
      content: 'Special Offer! Enjoy discounts and special offers at Cerave Booth on campus. Don\'t miss out on the great deals!',
      timestamp: DateTime.now().subtract(const Duration(days: 5)),
    ),
    NotificationModel(
      type: 'tag',
      content: 'You\'ve been tagged! Laila Khaled mentioned you in a post!',
      timestamp: DateTime.now().subtract(const Duration(days: 6)),
    ),
    NotificationModel(
      type: 'like',
      content: 'Your post just got a like! Nour Khaled liked your post. Check it out!',
      timestamp: DateTime.now().subtract(const Duration(days: 31)),
    ),
    NotificationModel(
      type: 'event',
      content: 'New Booth Alert! BreadFast is opening a booth on campus in 2 days. Plan your visit!',
      timestamp: DateTime.now().subtract(const Duration(days: 32)),
    ),
    NotificationModel(
      type: 'like_comment',
      content: 'Your comment just got a like! Mariam Mohamed liked your comment!',
      timestamp: DateTime.now().subtract(const Duration(days: 64)),
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
      return AssetImage('assets/images/like.png');
      case 'comment':
      return AssetImage('assets/images/comment.png');
      case 'like_comment':
        return AssetImage('assets/images/profile-pic.png');
      case 'event':
        return AssetImage('assets/images/party-hat.png');
      case 'offer':
      case 'mention':
      case 'tag':
        return AssetImage('assets/images/bell.png');
      default:
        return AssetImage('assets/images/default.png');
    }
  }
}
