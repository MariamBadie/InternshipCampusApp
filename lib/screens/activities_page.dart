import 'package:campus_app/backend/Controller/friendrequestsController.dart';
import 'package:campus_app/backend/Model/FriendRequests.dart';
import 'package:campus_app/backend/Model/NotificationCustom.dart';
import 'package:campus_app/models/NotificationObject.dart';
import 'package:campus_app/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/FriendRequestObject.dart';
import '../widgets/friend_requests/friend_requests_list.dart';
import '../widgets/notifications_files/notification_list.dart';
import 'package:campus_app/backend/Controller/notificationController.dart';

class Activities extends StatefulWidget {
  const Activities({super.key});

  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  List<FriendRequestObject> _availableFriendRequests = [];
  List<NotificationObject> _notificationsTBD = [];
  bool _isFriendRequestsLoading = true;
  bool _isNotificationsLoading = true;
  String userID = 'yq2Z9NaQdPz0djpnLynN'; // Replace with actual user ID

  @override
  void initState() {
    super.initState();
    _fetchFriendRequests();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try{
      List<NotificationObject> notificationsData =
      await retrieveNotifiData();

      setState(() {
        _notificationsTBD = notificationsData;
        _isNotificationsLoading = false; // Stop loading once data is fetched
      });
    } catch(e){
      setState(() {
        _isNotificationsLoading =
        false; // Stop loading even if there is an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load notifications: $e')),
      );
    }

  }

  Future<void> _fetchFriendRequests() async {
    try {
      List<FriendRequests> friendRequestsData =
          await getAllFriendRequests(userID);

      // Fetch the sender's name for each friend request
      List<FriendRequestObject> friendRequestObjects = [];

      for (var request in friendRequestsData) {
        // Fetch the sender's user document
        DocumentSnapshot senderSnapshot = await FirebaseFirestore.instance
            .collection('User')
            .doc(request.senderID)
            .get();

        if (senderSnapshot.exists) {
          String senderName = senderSnapshot[
              'name']; // 'name' is the field in the User collection

          friendRequestObjects.add(FriendRequestObject(
            friendRequestID: request.id!,
            name: senderName,
            requestDate: request.createdAt,
            profilepic: Image.asset('assets/images/profile-pic.png',
                width: 200), // Placeholder profile picture
          ));
        }
      }

      setState(() {
        _availableFriendRequests = friendRequestObjects;
        _isFriendRequestsLoading = false; // Stop loading once data is fetched
      });
    } catch (e) {
      setState(() {
        _isFriendRequestsLoading =
            false; // Stop loading even if there is an error
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load friend requests: $e')),
      );
    }
  }

  final List<NotificationObject> _notifications = [
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

  void _deleteFriendRequest(int index) async {
    String requestID =
        _availableFriendRequests[index].friendRequestID; // Use the ID

    await deleteFriendRequestUsingID(requestID);

    setState(() {
      _availableFriendRequests.removeAt(index);
    });
  }

  void _clearAllFriendRequests() async {
    await clearAllFriendRequests(userID);

    setState(() {
      _availableFriendRequests.clear();
    });
  }

  void _confirmFriendRequest(int index) async {
    setState(() {
      _availableFriendRequests.removeAt(index);
    });
  }

  void _deleteNotification(int index) {
    setState(() {
      _notificationsTBD.removeAt(index);
    });
  }

  void _clearAllNotifications() {
    setState(() {
      _notificationsTBD.clear();
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
    return _isFriendRequestsLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _availableFriendRequests.isEmpty
            ? const Center(
                child: Text(
                  'No Friend Requests Found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                    title: Row(
                      children: [
                        Text(
                          "Friend Requests",
                          style: GoogleFonts.roboto(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${_availableFriendRequests.length}',
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
                          requests: _availableFriendRequests,
                          onDelete: _deleteFriendRequest,
                        ),
                      ),
                    ],
                  ),
                ),
              );
  }

  Widget NotificationItem() {
    return _isNotificationsLoading
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : _notificationsTBD.isEmpty
        ? const Center(
      child: Text(
        'No Notifications Found',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
      ),
    )
        : Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black
              : Colors.white,
          title: Text(
            "General Notifications",
            style: GoogleFonts.roboto(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
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
                notif: _notificationsTBD,
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