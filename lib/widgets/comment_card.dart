import 'package:campus_app/models/post.dart';
import 'package:flutter/material.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final Function(String) onReact;
  final bool isReply;

  CommentCard({
    required this.comment,
    required this.onReact,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: isReply ? 0 : 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(comment.username),
            subtitle: Text(comment.content),
          ),
          if (!isReply)
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
        ],
      ),
    );
  }

  Widget _buildReactionButton(
      BuildContext context, String type, IconData icon) {
    return TextButton.icon(
      onPressed: () => onReact(type),
      icon: Icon(icon, size: 16),
      label: Text(comment.reactions[type]?.toString() ?? '0'),
    );
  }
}
