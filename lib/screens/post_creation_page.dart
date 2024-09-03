import 'package:campus_app/backend/Controller/postController.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../backend/Model/Post.dart';


class PostCreationPage extends StatefulWidget {
  final String type;
  final Function(Post) onPostCreated;

  const PostCreationPage({super.key, required this.type, required this.onPostCreated});

  @override
  _PostCreationPageState createState() => _PostCreationPageState();
}

class _PostCreationPageState extends State<PostCreationPage> {
  final TextEditingController _contentController = TextEditingController();
  final PostController _postController = PostController();
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Enter your ${widget.type.toLowerCase()} here',
                border: const OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
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
                  const Text('Post anonymously'),
                ],
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_contentController.text.isNotEmpty) {
                  print("oklahoma");
                  Post post =Post(
                     id: _postController.testUserId,
                    username: 'Anas Tamer', // Replace with actual username
                    type: widget.type,
                    content: _contentController.text,
                    profilePictureUrl: _isAnonymous 
                        ? 'assets/images/anas.jpg' 
                        : 'assets/images/current_user.jpg',
                    isAnonymous: _isAnonymous,
                    timestamp: DateTime.now(),
                    upvotes: 2,
                    downvotes: 0,
                    isConfession: widget.type == 'Confession',
                    privacy: 'Public', // Set privacy based on your requirement
                  );
                  // Call the createPost function
                   _postController.addPost(post);
                    print("abdo");

                  // After creating the post, close the page and trigger the callback
                  Navigator.pop(context);
                } else {
                  // Show error message if content is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter some content')),
                  );
                }
              },
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }
}
