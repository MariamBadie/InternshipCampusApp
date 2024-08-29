//import 'package:campus_app/models/notification_object.dart';
import 'package:campus_app/models/NotificationObject.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem(this.notificationAvailable, this.onDelete, {super.key});

  final NotificationObject notificationAvailable;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: notificationAvailable.notficationImg.image,
              radius: 40,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationAvailable.notficationText,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(notificationAvailable.formattedDate), // Corrected getter name
                ],
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.black),
                        SizedBox(width: 8.0),
                        Text(
                          'Delete',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
    );
  }
}
