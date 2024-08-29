import 'package:campus_app/screens/event_details_page.dart';
import 'package:flutter/material.dart';
import '../models/event.dart';
import '../widgets/event_card.dart';

class EventsPage extends StatelessWidget {
  final List<Event> events;

  const EventsPage({Key? key, required this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return EventCard(
            event: event,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailsPage(event: event),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
