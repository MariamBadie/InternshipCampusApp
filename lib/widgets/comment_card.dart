import 'package:flutter/material.dart';
import '../models/post.dart';

class CommentCard extends StatelessWidget {
  final Comment comment;
  final Function(String) onReact;

  CommentCard({required this.comment, required this.onReact});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(comment.username),
            subtitle: Text(comment.content),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildReactionButton(context, 'like', Icons.thumb_up),
                _buildReactionButton(context, 'dislike', Icons.thumb_down),
                _buildReactionButton(context, 'love', Icons.favorite),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildReactionButton(BuildContext context, String type, IconData icon) {
    return TextButton.icon(
      onPressed: () => onReact(type),
      icon: Icon(icon),
      label: Text(comment.reactions[type].toString()),
    );
  }
}