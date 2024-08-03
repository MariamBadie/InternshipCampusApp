import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:campus_app/models/notification_object.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem(this.notificationAvaliable, {super.key});

  final NotificationObject notificationAvaliable;

  @override
  Widget build(context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: notificationAvaliable.notficationImg.image,
              radius: 40,
            ),
            const SizedBox(width: 20), // Increased space before the text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationAvaliable.notficationText,
                    style: GoogleFonts.montserrat(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(notificationAvaliable.notficationObjectFormattedDate),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                // Add your settings icon action here
              },
              alignment: Alignment.topRight,
            ),
          ],
        ),
      ),
    );
  }
}
