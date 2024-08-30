import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:campus_app/models/post.dart';

class CommentCard extends StatefulWidget {
  final Comment comment;
  final Function(String) onReact;
  final Function onDelete;
  final bool isReply;

  const CommentCard({
    super.key,
    required this.comment,
    required this.onReact,
    required this.onDelete,
    this.isReply = false,
  });

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return SizedBox.shrink(); // Hide the comment if deleted

    return Card(
      margin: EdgeInsets.symmetric(horizontal: widget.isReply ? 0 : 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(widget.comment.username),
            subtitle: Text(widget.comment.content),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'Delete') {
                  _showDeleteConfirmationDialog(context);
                } else if (value == 'Report') {
                  _showReportDialog(context);
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'Delete',
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Report',
                    child: Text('Report'),
                  ),
                ];
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
          if (!widget.isReply)
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

  Widget _buildReactionButton(BuildContext context, String type, IconData icon) {
    return TextButton.icon(
      onPressed: () => widget.onReact(type),
      icon: Icon(icon, size: 16),
      label: Text(widget.comment.reactions[type]?.toString() ?? '0'),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this comment?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isVisible = false;
                });
                widget.onDelete(); // Call delete callback
              },
            ),
          ],
        );
      },
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Report Comment"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text("Spam"),
                onTap: () => _reportComment(context, "Spam"),
              ),
              ListTile(
                title: Text("Inappropriate"),
                onTap: () => _reportComment(context, "Inappropriate"),
              ),
              ListTile(
                title: Text("Other"),
                onTap: () => _reportComment(context, "Other"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _reportComment(BuildContext context, String reportType) {
    Navigator.of(context).pop(); // Close the dialog
    Fluttertoast.showToast(
      msg: "Reported as $reportType",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }
}
