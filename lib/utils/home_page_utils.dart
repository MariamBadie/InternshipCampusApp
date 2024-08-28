import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/event.dart';

import '../screens/post_creation_page.dart';
import '../screens/post_details_page.dart';
import '../screens/event_details_page.dart';

void navigateToPostCreation(BuildContext context, String type, Function(Post) onPostCreated) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostCreationPage(type: type, onPostCreated: onPostCreated),
    ),
  );
}

void navigateToPostDetails(
  BuildContext context,
  Post post,
  Function(String, String) onReact,
  Function(String, String, String) onComment,
  Function(String, int, String) onReactToComment,
) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostDetailsPage(
        post: post,
        onReact: onReact,
        onComment: onComment,
        onReactToComment: onReactToComment,
      ),
    ),
  );
}

void navigateToEventDetails(BuildContext context, Event event) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EventDetailsPage(event: event),
    ),
  );
}

void showPostOptions(BuildContext context, Function(String) navigateToPostCreation) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('Post Confession'),
            onTap: () {
              Navigator.pop(context);
              navigateToPostCreation('Confession');
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_answer),
            title: const Text('Post Academic Question'),
            onTap: () {
              Navigator.pop(context);
              navigateToPostCreation('Help');
            },
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Post an Event/Activity'),
            onTap: () {
              Navigator.pop(context);
              navigateToPostCreation('Event');
            },
          ),
        ],
      );
    },
  );
}
