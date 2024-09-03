import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../backend/Model/Post.dart';
import '../utils/home_page_utils.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Function(String, String) onReact;
  final Function(String, String, String) onComment;
  final Function(String, int, String) onReactToComment;
  final Function(String, int, String) onReplyToComment;
  final VoidCallback onShare;
  final VoidCallback onCopyLink;
  final VoidCallback onReport;

  const PostCard({
    super.key,
    required this.post,
    required this.onReact,
    required this.onComment,
    required this.onReactToComment,
    required this.onReplyToComment,
    required this.onShare,
    required this.onCopyLink,
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
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case 'Share':
                          onShare();
                          break;
                        case 'Copy Link':
                          onCopyLink();
                          break;
                        case 'Report':
                          onReport();
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return ['Share', 'Copy Link', 'Report']
                          .map((String choice) {
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
                    _buildReactionButton(context, 'upvote', Icons.keyboard_arrow_up, post.upvotes),
                    _buildReactionButton(context, 'downvote', Icons.keyboard_arrow_down, post.downvotes),
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
                    Comment comment = entry.value;
                    return _buildCommentSection(context, comment, idx);
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(BuildContext context, String type, IconData icon, int count) {
    return TextButton.icon(
      onPressed: () => onReact(post.id, type),
      icon: Icon(icon),
      label: Text(count.toString()),
    );
  }

  Widget _buildCommentSection(BuildContext context, Comment comment, int commentIndex) {
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
                Text(comment.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(comment.content),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCommentReactionButton(context, commentIndex, 'upvote', Icons.keyboard_arrow_up, comment.upvotes),
                    _buildCommentReactionButton(context, commentIndex, 'downvote', Icons.keyboard_arrow_down, comment.downvotes),
                    IconButton(
                      icon: const Icon(Icons.reply, size: 16),
                      onPressed: () => _showReplyDialog(context, commentIndex),
                    ),
                  ],
                ),
                if (comment.replies.isNotEmpty)
                  ...comment.replies.map((reply) {
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
                                Text(reply.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(reply.content),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildReplyReactionButton(context, 'upvote', Icons.keyboard_arrow_up, reply.upvotes),
                                    _buildReplyReactionButton(context, 'downvote', Icons.keyboard_arrow_down, reply.downvotes),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentReactionButton(BuildContext context, int commentIndex, String type, IconData icon, int count) {
    return TextButton.icon(
      onPressed: () => onReactToComment(post.id, commentIndex, type),
      icon: Icon(icon),
      label: Text(count.toString()),
    );
  }

  Widget _buildReplyReactionButton(BuildContext context, String type, IconData icon, int count) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(count.toString()),
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
