import 'package:campus_app/backend/Controller/postController.dart';
import 'package:campus_app/backend/Controller/userController.dart';
import 'package:flutter/material.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  String type = 'All Types';
  String userID = 'upeubEqcmzSU9aThExaO'; // Initialize the common userID
  final PostController _postController=PostController();

  List<Map<String, String>> posts = [];

  @override
  void initState() {
    super.initState();
    _fetchArchivedPosts();
  }

  Future<void> _fetchArchivedPosts() async {
    List<String> archivedPostData = await getArchivedPostData(userID);

    setState(() {
      posts = archivedPostData.map((data) {
        var splitData = data.split(',');
        return {
          'title': splitData[0],
          'content': splitData[1],
          'postID': splitData[2],
        };
      }).toList();
    });
  }

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
            onPressed: _fetchArchivedPosts, // Refresh the posts when pressed
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
                maxCrossAxisExtent: 150,
                childAspectRatio: 1,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
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
                                if (value == 'restore') {
                                  removeFromArchived(post['postID']!, userID);
                                  _fetchArchivedPosts(); // Refresh posts after removal
                                } else if (value == 'edit') {
                                  _editPost(context, post['title']!, post['content']!, post['postID']!);
                                } else if (value == 'delete') {
                                  _deletePost(context,post['postID'].toString());
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'restore',
                                  child: Row(
                                    children: [
                                      Icon(Icons.restore_rounded, color: Colors.black),
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

  void _deletePost(BuildContext context, String postID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [Text('Are you sure you want to delete?')],
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
                _postController.deletePost(postID);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editPost(BuildContext context, String initialTitle, String initialContent, String postID) {
    final TextEditingController titleController = TextEditingController(text: initialTitle);
    final TextEditingController contentController = TextEditingController(text: initialContent);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Edit the Title of the post'),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.edit),
                  labelText: "Edit the Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.edit),
                  labelText: "Edit the content",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  String updatedTitle = titleController.text;
                  String updatedContent = contentController.text;
                  _postController.editPost(postID, updatedContent, updatedTitle);
                  Navigator.of(context).pop();
                  _fetchArchivedPosts(); // Refresh the posts after editing
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
