import 'package:flutter/material.dart';

class PostEditMenu extends StatelessWidget {
  const PostEditMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PopupMenuButton<String>(
          onSelected: (value) {
            // Handle the selected option here
            if (value == 'archive') {
              // Handle restore action
            } else if (value == 'edit') {
              // Handle edit action
            } else if (value == 'delete') {
              _deletePost(context);

            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'archive',
              child: Row(
                children: [
                  Icon(Icons.archive, color: Colors.black),
                  SizedBox(width: 10),
                  Text("Archive"),
                ],
              ),
            ),
          const  PopupMenuItem(
              value: 'edit',
              child: Row(
                children:  [
                  Icon(Icons.edit, color: Colors.black),
                  SizedBox(width: 10),
                  Text("Edit"),
                ],
              ),
            ),
          const  PopupMenuItem(
              value: 'delete',
              child: Row(
                children:  [
                  Icon(Icons.delete, color: Colors.black),
                  SizedBox(width: 10),
                  Text("Delete"),
                ],
              ),
            ),
          ],
          child: const Icon(Icons.more_vert_rounded),
        ),
      ],
    );
  }
}

 void _deletePost(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {


      return AlertDialog(
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text('Are You sure you want to delete?')
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('DELETE'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

