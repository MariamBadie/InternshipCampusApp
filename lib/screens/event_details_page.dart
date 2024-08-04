import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';


class EventDetailsPage extends StatelessWidget {
  final Event event;

  EventDetailsPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text(event.description),
            SizedBox(height: 16),
            Text('Date: ${DateFormat('MMM d, y h:mm a').format(event.date)}'),
            Text('Location: ${event.location}'),
          ],
        ),
      ),
    );
  }
}