import 'package:campus_app/models/notification_object.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/friend_request.dart';
import '../widgets/friend_requests_list.dart';
import '../widgets/notification_list.dart';

class Activities extends StatefulWidget {
  const Activities({Key? key}) : super(key: key);

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  final List<FriendRequest> _friendRequests  = [
    FriendRequest(
      name: 'Aya Mahmoud',
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    FriendRequest(
      name: 'Mayar Ahmed',
      requestDate: DateTime.now().subtract(const Duration(days: 5)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    FriendRequest(
      name: 'Yaseen Mostafa',
      requestDate: DateTime.now().subtract(const Duration(days: 10)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    FriendRequest(
      name: 'Jomana Ayman',
      requestDate: DateTime.now().subtract(const Duration(days: 20)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
  ];

  final List<NotificationObject> _notifications =  [
    NotificationObject(
      notficationText: 'New Comment! Mayar Ahmed commented on your post!',
      notficationDate: DateTime.now().subtract(const Duration(hours: 1)),
      notficationImg: Image.asset('assets/images/comment.png', width: 200),
    ),
    NotificationObject(
      notficationText:
          'Job Fair Alert! Discover companies and internships available next Monday!',
      notficationDate: DateTime.now().subtract(const Duration(hours: 5)),
      notficationImg: Image.asset('assets/images/announcement.png', width: 200),
    ),
    NotificationObject(
      notficationText:
          'Mention Alert! Salma Sayed mentioned you in a comment. See what they have to say!',
      notficationDate: DateTime.now().subtract(const Duration(days: 2)),
      notficationImg: Image.asset('assets/images/bell.png', width: 200),
    ),
    NotificationObject(
      notficationText:
          'Special Offer! Enjoy discounts and special offers at Cerave Booth on campus. Don\'t miss out on the great deals!',
      notficationDate: DateTime.now().subtract(const Duration(days: 5)),
      notficationImg: Image.asset('assets/images/party-hat.png', width: 200),
    ),
    NotificationObject(
      notficationText:
          'You\'ve been tagged! Laila Khaled mentioned you in a post!',
      notficationDate: DateTime.now().subtract(const Duration(days: 6)),
      notficationImg: Image.asset('assets/images/bell.png', width: 200),
    ),
    NotificationObject(
      notficationText:
          'Your post just got a like! Nour Khaled liked your post. Check it out!',
      notficationDate: DateTime.now().subtract(const Duration(days: 31)),
      notficationImg: Image.asset('assets/images/like.png', width: 200),
    ),
    NotificationObject(
      notficationText:
          'New Booth Alert! BreadFast is opening a booth on campus in 2 days. Plan your visit!',
      notficationDate: DateTime.now().subtract(const Duration(days: 32)),
      notficationImg: Image.asset('assets/images/party-hat.png', width: 200),
    ),
    NotificationObject(
      notficationText:
          'Your comment just got a like! Mariam Mohamed liked your comment!',
      notficationDate: DateTime.now().subtract(const Duration(days: 64)),
      notficationImg:
          Image.asset('assets/images/liked-a-comment.png', width: 200),
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

   void _clearAllFriendRequests() {
    setState(() {
      _friendRequests.clear();
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
            NotificationItem(),
          ],
        ),
      ),
    );
  }

  Widget FriendRequestsTab() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                "Friend Requests",
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                '${_friendRequests.length}',
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 213, 12, 12),
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _clearAllFriendRequests,
              child: Text(
                'Clear All',
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 30, 53, 235),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: FriendRequestsList(
                requests: _friendRequests,
                onDelete: _deleteFriendRequest,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget NotificationItem(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "General Notifications",
            style: GoogleFonts.roboto(
              color: const Color.fromARGB(255, 0, 0, 0),
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _clearAllNotifications,
              child: Text(
                'Clear All',
                style: GoogleFonts.roboto(
                  color: const Color.fromARGB(255, 30, 53, 235),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: NotificationsList(
                notif: _notifications,
                onDelete: _deleteNotification,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//   AssetImage _getProfilePicture(String type) {
//     switch (type) {
//       case 'alert':
//         return AssetImage('assets/images/announcement.png');
//       case 'like':
//       case 'comment':
//         return AssetImage('assets/images/profile-pic.png');
//       case 'event':
//         return AssetImage('assets/images/party-hat.png');
//       default:
//         return AssetImage('assets/images/bell.png');
//     }
//   }
// }