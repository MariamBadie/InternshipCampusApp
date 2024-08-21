
import 'package:campus_app/models/NotificationObject.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem(this.notificationAvaliable, this.onDelete, {super.key});

  final NotificationObject notificationAvaliable;
  final VoidCallback onDelete;

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
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notificationAvaliable.notficationText,
                    style: GoogleFonts.montserrat(
                     // color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(notificationAvaliable.notficationObjectFormattedDate),
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
                          Icon(Icons.delete, 
                          //color: Color.fromARGB(255, 0, 0, 0),
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Delete',
                            //style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
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
