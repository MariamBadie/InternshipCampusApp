import 'package:flutter/material.dart';
import '../models/post.dart';

class PostCreationPage extends StatefulWidget {
  final String type;
  final Function(Post) onPostCreated;

  PostCreationPage({required this.type, required this.onPostCreated});

  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  final TextEditingController _contentController = TextEditingController();
  bool _isAnonymous = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create ${widget.type}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Enter your ${widget.type.toLowerCase()} here',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            if (widget.type == 'Confession')
              Row(
                children: [
                  Checkbox(
                    value: _isAnonymous,
                    onChanged: (value) {
                      setState(() {
                        _isAnonymous = value ?? false;
                      });
                    },
                  ),
                  Text('Post anonymously'),
                ],
              ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_contentController.text.isNotEmpty) {
                  final newPost = Post(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    username: 'CurrentUser', // Replace with actual username if possible
                    type: widget.type,
                    content: _contentController.text,
                    reactions: {'like': 0, 'dislike': 0, 'love': 0, 'haha': 0},
                    comments: [],
                    isAnonymous: _isAnonymous,
                    timestamp: DateTime.now(),
                    profilePictureUrl: _isAnonymous ? 'assets/images/anonymous.jpg' : 'assets/images/current_user.jpg',
                  );
                  widget.onPostCreated(newPost);
                  Navigator.pop(context);
                } else {
                  // Show error message if content is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter some content')),
                  );
                }
              },
              child: Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}