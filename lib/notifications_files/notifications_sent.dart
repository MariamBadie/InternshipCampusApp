import 'package:campus_app/models/notification_object.dart';
import 'package:campus_app/notifications_files/notifications_list.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationsSent extends StatefulWidget {
  const NotificationsSent({super.key});

  @override
  State<NotificationsSent> createState() {
    return _NotificationsSentState();
  }
}

class _NotificationsSentState extends State<NotificationsSent> {
  final List<NotificationObject> _avaliableNotifications = [
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

  void _deleteNotification(int index) {
    setState(() {
      _avaliableNotifications.removeAt(index);
    });
  }

  void _clearAllNotifications() {
    setState(() {
      _avaliableNotifications.clear();
    });
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 35, 5, 5),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Notifications",
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
                notif: _avaliableNotifications,
                onDelete: _deleteNotification,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
