import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Function(String, String) onReact;
  final Function(String, String, String) onComment;
  final VoidCallback onTap;

  PostCard({required this.post, required this.onReact, required this.onComment, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(post.isAnonymous ? 'Anonymous' : post.username),
              subtitle: Text(post.content),
              trailing: Text(DateFormat('MMM d, y h:mm a').format(post.timestamp)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
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
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Comments: ${post.comments.length}'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(BuildContext context, String type, IconData icon) {
    return TextButton.icon(
      onPressed: () => onReact(post.id, type),
      icon: Icon(icon),
      label: Text(post.reactions[type].toString()),
    );
  }
}