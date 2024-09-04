import 'package:campus_app/backend/Controller/highlightsController.dart'; // Ensure this path is correct
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HighlightspopupsDialog extends StatefulWidget {
  final String highlightID;
  final String friendsOrProfile;

  HighlightspopupsDialog({required this.highlightID, required this.friendsOrProfile});

  @override
  _HighlightspopupsDialogState createState() => _HighlightspopupsDialogState();
}

class _HighlightspopupsDialogState extends State<HighlightspopupsDialog> {
  List<Map<String, dynamic>> postData = [];
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    fetchHighlightPosts(widget.highlightID).then((fetchedPosts) {
      setState(() {
        postData = fetchedPosts;
        if (postData.isNotEmpty) {
          currentPage = 0; // Reset to the first page if there are posts
        }
        print(postData);
      });
    }).catchError((error) {
      print("Error fetching posts: $error");
    });
  }

  void _handlePopupMenuAction(String action, String? postId) async {
    if (postId == null) {
      print('Post ID is null');
      return;
    }

    print('Handling action: $action for post: $postId from highlight ${widget.highlightID}');
    switch (action) {
      case 'Delete Post':
        await removePostFromHighlightsById(widget.highlightID, "/Posts/$postId");
        setState(() {
          postData.removeWhere((post) => post['id'] == postId);
          if (currentPage >= postData.length) {
            currentPage = postData.length > 0 ? postData.length - 1 : 0;
          }
        });
        break;
      case 'Add Post':
        // Implement add post logic here
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Highlight Posts'),
      content: Container(
        width: 300, // Adjust width as needed
        height: 300, // Adjust height as needed
        child: postData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: Center(
                      child: postData.isNotEmpty
                          ? Stack(
                              children: [
                                if (widget.friendsOrProfile == "profile")
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: PopupMenuButton<String>(
                                      onSelected: (value) {
                                        final postId = postData.isNotEmpty ? postData[currentPage]['id'] as String? : null;
                                        _handlePopupMenuAction(value, postId);
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem<String>(
                                          value: 'Delete Post',
                                          child: Text('Delete Post'),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'Add Post',
                                          child: Text('Add Post'),
                                        ),
                                      ],
                                    ),
                                  ),
                                Center(
                                  child: Text(
                                    postData.isNotEmpty
                                        ? postData[currentPage]['content'] ?? 'No content'
                                        : 'No content',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ],
                            )
                          : Text('No posts available'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_left),
                        onPressed: () {
                          setState(() {
                            if (currentPage > 0) {
                              currentPage--;
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            if (currentPage < postData.length - 1) {
                              currentPage++;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
