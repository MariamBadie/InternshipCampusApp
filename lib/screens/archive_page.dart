import 'package:flutter/material.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  String type = 'All Types';

  final List<Map<String, String>> posts = [
    {
      'title': 'Post 1',
      'content': 'This is the content of post 1.',
      'type': 'normal Post'
    },
    {
      'title': 'Post 2',
      'content': 'This is the content of post 2.',
      'type': 'Academic Post'
    },
    {
      'title': 'Post 3',
      'content': 'This is the content of post 3.',
      'type': 'normal Post'
    },
    {
      'title': 'Post 4',
      'content': 'This is the content of post 4.',
      'type': 'Academic Post'
    },
    {
      'title': 'Post 5',
      'content': 'This is the content of post 5.',
      'type': 'normal Post'
    },
    {
      'title': 'Post 6',
      'content': 'This is the content of post 6.',
      'type': 'Academic Post'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Archives",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 150, // Maximum width for each item
                childAspectRatio: 1, // Aspect ratio of each card (width/height)
                mainAxisSpacing: 10, // Space between rows
                crossAxisSpacing: 10, // Space between columns
              ),
              padding: const EdgeInsets.all(10),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              post['title']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                // Handle the selected option here
                                if (value == 'restore') {
                                  // Handle restore action
                                } else if (value == 'edit') {
                                _editPost(context, 'Current Title', 'Current Content','Postid');
                                } else if (value == 'delete') {
                                  _deletePost(context);
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'restore',
                                  child: Row(
                                    children: [
                                      Icon(Icons.restore_rounded,
                                          color: Colors.black),
                                      SizedBox(width: 10),
                                      Text("Show back to my profile"),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, color: Colors.black),
                                      SizedBox(width: 10),
                                      Text("Edit"),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
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
                        ),
                        Text(post['content']!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
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
          children: [Text('Are You sure you want to delete?')],
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

void _editPost(BuildContext context, String initialTitle, String initialContent,String id) {
  final TextEditingController _titleController = TextEditingController(text: initialTitle);
  final TextEditingController _contentController = TextEditingController(text: initialContent);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Edit the Title of the post'),
            const SizedBox(height: 16), // Add spacing between the fields

            SizedBox(
              child: TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.edit),
                  labelText: "Edit the Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0), // Rounded borders
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding to fit inside the SizedBox
                ),
              ),
            ),
            const SizedBox(height: 16), // Add spacing between the fields
            SizedBox(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.edit),
                  labelText: "Edit the content",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0), // Rounded borders
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0), // Adjust padding to fit inside the SizedBox
                ),
              ),
            ),
            const SizedBox(height: 16), // Add spacing between the fields
            TextButton(
              onPressed: () {
                // Handle submit action here
                // Example: Update the post with the new title and content
                String updatedTitle = _titleController.text;
                String updatedContent = _contentController.text;

                // Perform the update operation here

              },
              child: const Text('Submit'),
            )
          ],
        ),
      );
    },
  );
}
