import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/notification.dart';

class GeneralNotificationItem extends StatelessWidget {
  const GeneralNotificationItem({
    super.key,
    required this.notification,
    required this.profilePic,
    required this.onDelete,
  });

  final NotificationModel notification;
  final AssetImage profilePic;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Aligned to start as per your previous code
          children: [
            CircleAvatar(
              backgroundImage: profilePic,
              radius: 25, // Preserved the radius from your code
            ),
            const SizedBox(width: 20), // Reduced width to match your layout
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.content,
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16, // Adjusted to match the text style from your previous code
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(notification.formattedDate),
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
                  PopupMenuItem(
                    value: 'delete',
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 239, 239, 239),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.delete, color: Color.fromARGB(255, 0, 0, 0)),
                          SizedBox(width: 8.0),
                          Text(
                            'Delete',
                            style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                          ),
                        ],
                      ),
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
