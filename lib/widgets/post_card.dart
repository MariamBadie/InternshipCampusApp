import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/post.dart' as post_model;
import '../utils/home_page_utils.dart';
import '../models/post.dart' show Post, Comment, Reply;
import '../widgets/comment_card.dart';

class PostCard extends StatelessWidget {
  final post_model.Post post;
  final Function(String, String) onReact;
  final Function(String, String, String) onComment;
  final Function(String, int, String) onReactToComment;
  final Function(String, int, String) onReplyToComment;
  final VoidCallback onShare;
  final VoidCallback onCopyLink;

  // final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  PostCard({
    required this.post,
    required this.onReact,
    required this.onComment,
    required this.onReactToComment,
    required this.onReplyToComment,
    required this.onShare,
    required this.onCopyLink,
    // required this.onEdit,
  
    required this.onDelete,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => navigateToPostDetails(
          context,
          post,
          onReact,
          onComment,
          onReactToComment,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: post.isAnonymous
                    ? const AssetImage('assets/images/anas.jpg')
                    : AssetImage(post.profilePictureUrl),
                radius: 26,
              ),
              title: Text(post.isAnonymous ? 'Anonymous' : post.username),
              subtitle: Text(post.content),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(DateFormat('MMM d, y h:mm a').format(post.timestamp)),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        // case 'Edit':
                        //   onEdit();
                          // break;
                        case 'Delete':
                          onDelete();
                          break;
                        case 'Report':
                          onReport();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Edit', 'Delete', 'Report'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
            if (post.type != 'Help')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildReactionButton(context, 0, 'like', Icons.thumb_up),
                    _buildReactionButton(context, 0, 'dislike', Icons.thumb_down),
                    _buildReactionButton(context, 0, 'love', Icons.favorite),
                    _buildReactionButton(context, 0, 'haha', Icons.emoji_emotions),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Comments: ${post.comments.length}'),
                  ...post.comments.asMap().entries.map((entry) {
                    int idx = entry.key;
                    post_model.Comment comment = entry.value;
                    return _buildCommentSection(context, comment, idx);
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: onShare,
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: onCopyLink,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(
      BuildContext context, int commentIndex, String type, IconData icon) {
    return TextButton.icon(
      onPressed: () => onReactToComment(post.id, commentIndex, type),
      icon: Icon(icon),
      label: Text(post.comments[commentIndex].reactions[type].toString()),
    );
  }

  Widget _buildCommentSection(
      BuildContext context, post_model.Comment comment, int commentIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(comment.profilePictureUrl),
            radius: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.username,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(comment.content),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildReactionButton(context, commentIndex, 'like', Icons.thumb_up),
                    _buildReactionButton(context, commentIndex, 'dislike', Icons.thumb_down),
                    _buildReactionButton(context, commentIndex, 'love', Icons.favorite),
                    _buildReactionButton(context, commentIndex, 'haha', Icons.emoji_emotions),
                    IconButton(
                      icon: const Icon(Icons.reply, size: 16),
                      onPressed: () => _showReplyDialog(context, commentIndex),
                    ),
                  ],
                ),
                if (comment.replies != null && comment.replies!.isNotEmpty)
                  ...comment.replies!.map((reply) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 32.0, top: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(reply.profilePictureUrl),
                            radius: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reply.username,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                Text(reply.content),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildReactionButton(context, 0, 'like', Icons.thumb_up),
                                    _buildReactionButton(context, 0, 'dislike', Icons.thumb_down),
                                    _buildReactionButton(context, 0, 'love', Icons.favorite),
                                    _buildReactionButton(context, 0, 'haha', Icons.emoji_emotions),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, int commentIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String replyText = '';
        return AlertDialog(
          title: const Text('Reply to Comment'),
          content: TextField(
            onChanged: (value) {
              replyText = value;
            },
            decoration: const InputDecoration(hintText: "Enter your reply"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Reply'),
              onPressed: () {
                if (replyText.isNotEmpty) {
                  onReplyToComment(post.id, commentIndex, replyText);
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
