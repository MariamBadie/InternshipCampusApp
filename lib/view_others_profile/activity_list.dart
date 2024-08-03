import 'package:campus_app/view_others_profile/activity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard


class ActivityList extends StatelessWidget {
  final List<Map<String, dynamic>> activityData;

  const ActivityList({super.key, required this.activityData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Prevent the ListView from scrolling
      itemCount: activityData.length,
      itemBuilder: (context, index) {
        final data = activityData[index];
        return ActivityItem(
          profileImageUrl: data['profileImageUrl'],
          userName: data['userName'],
          activityDescription: data['activityDescription'],
          timestamp: data['timestamp'],
          showFollowButton: index % 2 == 0, // Example logic for showing follow button
          isImage: data['isImage'], // Pass the isImage value
        );
      },
    );
  }
}
