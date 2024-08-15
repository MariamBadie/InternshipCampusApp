import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart'; // For sharing
import '../models/post.dart';
import '../widgets/comment_card.dart';

class PostDetailsPage extends StatelessWidget {
  final Post post;
  final Function(String, String) onReact;
  final Function(String, String, String) onComment;
  final Function(String, int, String) onReactToComment;

  PostDetailsPage({
    required this.post,
    required this.onReact,
    required this.onComment,
    required this.onReactToComment,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _sharePost(context),
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => _copyPostLink(context),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(post.isAnonymous ? 'Anonymous' : post.username),
            subtitle: Text(post.content),
            trailing:
                Text(DateFormat('MMM d, y h:mm a').format(post.timestamp)),
          ),
          if (post.type != 'Help')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildReactionButton(context, 'like', Icons.thumb_up),
                  _buildReactionButton(context, 'dislike', Icons.thumb_down),
                  _buildReactionButton(context, 'love', Icons.favorite),
                  _buildReactionButton(context, 'haha', Icons.emoji_emotions),
                ],
              ),
            ),
          ...post.comments.asMap().entries.map((entry) {
            int idx = entry.key;
            Comment comment = entry.value;
            return CommentCard(
              comment: comment,
              onReact: (reactionType) =>
                  onReactToComment(post.id, idx, reactionType),
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

  void _sharePost(BuildContext context) {
    final postUrl =
        'https://example.com/posts/${post.id}'; // Example URL format
    Share.share('Check out this post: $postUrl');
  }

  void _copyPostLink(BuildContext context) {
    final postUrl =
        'https://example.com/posts/${post.id}'; // Example URL format
    Clipboard.setData(ClipboardData(text: postUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link copied to clipboard!')),
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
                  onComment(post.id, 'CurrentUser',
                      commentText); // Replace 'CurrentUser' with actual username
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildReactionButton(
      BuildContext context, String type, IconData icon) {
    return TextButton.icon(
      onPressed: () => onReact(post.id, type),
      icon: Icon(icon),
      label: Text(post.reactions[type].toString()),
    );
  }
}
