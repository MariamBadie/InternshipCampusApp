import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard

class IconMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'block') {
          // Handle block action
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Blocked')),
          );
        } else if (value == 'report') {
          // Show dialog to enter report reason
          _showReportDialog(context);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'block',
            child: Text('Block'),
          ),
          const PopupMenuItem<String>(
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
          title: const Text('Report'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please provide a reason for reporting:'),
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(
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
              child: const Text('Cancel'),
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
                    const SnackBar(content: Text('Please enter a reason')),
                  );
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
