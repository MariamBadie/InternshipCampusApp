import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  const EventCard({super.key, required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(event.title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(event.description),
              const SizedBox(height: 4),
              Text('Date: ${DateFormat('MMM d, y h:mm a').format(event.date)}'),
              Text('Location: ${event.location}'),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }
}
