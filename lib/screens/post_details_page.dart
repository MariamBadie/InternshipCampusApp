import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../widgets/post_card.dart';
import '../widgets/comment_card.dart';


class PostDetailsPage extends StatelessWidget {
  final Post post;
  final Function(String, String) onReact;
  final Function(String, String, String) onComment;
  final Function(String, int, String) onReactToComment;

  PostDetailsPage({required this.post, required this.onReact, required this.onComment, required this.onReactToComment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: ListView(
        children: [
          PostCard(
            post: post,
            onReact: onReact,
            onComment: onComment,
            onTap: () {}, // No action needed here
          ),
          ...post.comments.asMap().entries.map((entry) {
            int idx = entry.key;
            Comment comment = entry.value;
            return CommentCard(
              comment: comment,
              onReact: (reactionType) => onReactToComment(post.id, idx, reactionType),
            );
          }),
          Padding(
            padding: EdgeInsets.all(8),
            child: ElevatedButton(
              onPressed: () => _showCommentDialog(context),
              child: Text('Add Comment'),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String commentText = '';
        return AlertDialog(
          title: Text('Add a Comment'),
          content: TextField(
            onChanged: (value) {
              commentText = value;
            },
            decoration: InputDecoration(hintText: "Enter your comment"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Post'),
              onPressed: () {
                if (commentText.isNotEmpty) {
                  onComment(post.id, 'CurrentUser', commentText);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}