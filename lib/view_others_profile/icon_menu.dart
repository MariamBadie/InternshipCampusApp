import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard

class IconMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'block') {
          // Handle block action
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Blocked')),
          );
        } else if (value == 'report') {
          // Show dialog to enter report reason
          _showReportDialog(context);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'block',
            child: Text('Block'),
          ),
          PopupMenuItem<String>(
            value: 'report',
            child: Text('Report'),
          ),
        ];
      },
    );
  }

  void _showReportDialog(BuildContext context) {
    final TextEditingController _reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please provide a reason for reporting:'),
              TextField(
                controller: _reasonController,
                decoration: InputDecoration(
                  hintText: 'Enter reason here',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final reason = _reasonController.text;
                if (reason.isNotEmpty) {
                  // Handle the report with the reason
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reported with reason: $reason')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a reason')),
                  );
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}