import 'package:campus_app/view_my_profile/activity_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard

class ActivityList extends StatefulWidget {
  final List<Map<String, dynamic>> activityData;

  const ActivityList({super.key, required this.activityData});

  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {
  late List<Map<String, dynamic>> _activityData;

  @override
  void initState() {
    super.initState();
    _activityData = widget.activityData;
  }

  void _removeActivityItem(int index) {
    setState(() {
      _activityData.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(), // Prevent the ListView from scrolling
      itemCount: _activityData.length,
      itemBuilder: (context, index) {
        final data = _activityData[index];
        return ActivityItem(
          profileImageUrl: data['profileImageUrl'],
          userName: data['userName'],
          activityDescription: data['activityDescription'],
          timestamp: data['timestamp'],
          showFollowButton: index % 2 == 0, // Example logic for showing follow button
          isImage: data['isImage'], // Pass the isImage value
          onDelete: () => _removeActivityItem(index), // Pass the callback
        );
      },
    );
  }
}