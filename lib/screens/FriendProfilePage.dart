import 'dart:io';

import 'package:campus_app/backend/Controller/highlightsController.dart';
import 'package:campus_app/backend/Controller/postController.dart';
import 'package:campus_app/backend/Controller/userController.dart';
import 'package:campus_app/screens/highlights_popups.dart';
import 'package:campus_app/screens/post_details_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:campus_app/backend/Model/Highlights.dart';
import 'package:campus_app/backend/Model/Post.dart';
import 'package:image_picker/image_picker.dart'; // Make sure this import path is correct

class FriendProfilePage extends StatefulWidget {
  final String name;
  final String profilePic;
  final String bio;
  final int numberOfPosts;
  final int numberOfFriends;
  final int karma;

  FriendProfilePage({
    super.key, 
    required this.name, 
    required this.profilePic,
    this.bio = 'Friend\'s Bio | Additional Info',
    this.numberOfPosts = 10,
    this.numberOfFriends = 50,
    this.karma = 100,
  });

  @override
  _FriendProfilePageState createState() => _FriendProfilePageState();
}

class _FriendProfilePageState extends State<FriendProfilePage> {
  List<Highlights> userHighlights = [];

  @override
  void initState() {
    super.initState();
    _fetchUserHighlights();
    name = getUsernameByID(userID);
  }
      String userID = 'vY1VlLrRxAfbDDGrb9wH';
  late Future<String> name;
  Future<void> _fetchUserHighlights() async {
    // Replace `userID` with the actual user ID you want to fetch highlights for
    final highlights = await getHighlights(userID);
    setState(() {
      userHighlights = highlights;
    });
  }
  
  List<Post> userPosts = [
    Post(
      id: '1',
      username: 'Anas Tamer',
      type: 'Text',
      content: 'Had a great day exploring Flutter!',
      upvotes: 10, // Replace the old reactions map with upvotes
      downvotes: 2, // Assume some downvotes for demonstration
      comments: [],
      isAnonymous: false,
      isConfession: false, // Specify if it's a confession or not
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      profilePictureUrl: 'assets/images/anas.jpg',
    ),
    Post(
      id: '2',
      username: 'Anas Tamer',
      type: 'Image',
      content: 'Check out this cool picture I took!',
      upvotes: 7, // Replace the old reactions map with upvotes
      downvotes: 1, // Assume some downvotes for demonstration
      comments: [],
      isAnonymous: false,
      isConfession: false, // Specify if it's a confession or not
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      profilePictureUrl: 'assets/images/anas.jpg',
    ),
    // Add more posts here...
  ];
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Profile'),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert), 
          onSelected: (String result) {
            switch (result) {
              case 'Report User':
                _showReportDialog(context);
                break;
              case 'Block User':
                _showBlockConfirmationDialog(context);
                break;
              case 'Share User':
                Clipboard.setData(
                    ClipboardData(text: 'https://yourapp.com/user/${widget.name}'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Profile URL copied to clipboard')),
                );
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'Report User',
              child: Text('Report User'),
            ),
            const PopupMenuItem<String>(
              value: 'Block User',
              child: Text(
                'Block User',
                style: TextStyle(color: Colors.red),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'Share User',
              child: Text('Share User'),
            ),
          ],
        ),
      ],
    ),
    body: DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileHeader(),
                const SizedBox(height: 24),
                _buildProfileStats(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildHighlightsRow(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // TabBar
          const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.grid_on)),
              Tab(icon: Icon(Icons.alternate_email_rounded)),
            ],
          ),
          // TabBarView
          Expanded(
            child: TabBarView(
              children: [
                _buildUserPosts(context),
                _buildPostsMentioningMe(context),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildUserPosts(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: userPosts.length,
      itemBuilder: (context, index) {
        final post = userPosts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(post.profilePictureUrl),
            ),
            title: Text(post.isAnonymous ? 'Anonymous' : post.username),
            subtitle: Text(
              post.content.length > 50
                  ? '${post.content.substring(0, 50)}...'
                  : post.content,
            ),
          ),
        );
      },
    );
  }
Future<List<Map<String, dynamic>>> _fetchPostsMentioningMe() async {
    // Replace this with your method to find and fetch posts mentioning the user
    final postIds = await findPostsWithMention(await name);
    return await fetchPostsDetails(postIds);
  }

  Widget _buildPostsMentioningMe(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchPostsMentioningMe(), // Implement this method to fetch posts
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final fetchedPosts = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: fetchedPosts.length,
            itemBuilder: (context, index) {
              final post = fetchedPosts[index];
              return Container(
                width: 50,
                height: 80,
                margin: const EdgeInsets.all(4.0),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text(post['title'] ?? 'No Title'),
                        subtitle: Text(post['content'] ?? 'No Content'),
                        trailing: Text(post['type'] ?? 'No Type'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: Text('No posts mentioning you'));
        }
      },
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Report User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select a reason for reporting:'),
              ListTile(
                title: const Text('Spam'),
                onTap: () {
                  Navigator.pop(context);
                  _showToast();
                },
              ),
              ListTile(
                title: const Text('Inappropriate Content'),
                onTap: () {
                  Navigator.pop(context);
                  _showToast();
                },
              ),
              ListTile(
                title: const Text('Harassment'),
                onTap: () {
                  Navigator.pop(context);
                  _showToast();
                },
              ),
              ListTile(
                title: const Text('Other'),
                onTap: () {
                  Navigator.pop(context);
                  _showToast();
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: "User reported. We will check it and respond as soon as possible.",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showBlockConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Block User'),
          content: const Text('Are you sure you want to block this user?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Block',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                // Handle block user action
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(widget.profilePic),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.bio,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn('Posts', widget.numberOfPosts),
        _buildStatColumn('Friends', widget.numberOfFriends),
        _buildStatColumn('Karma', widget.karma),
      ],
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildSendMessageButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/sendMessage'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: const Text('Send Message'),
      ),
    );
  }


Widget _buildHighlightsRow() {
  return FutureBuilder<String>(
    future: getUsernameByID(userID),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else if (snapshot.hasData) {
        final username = snapshot.data!;
        return SizedBox(
          height: 81, // Adjust the height to fit your needs
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: userHighlights.length,
            itemBuilder: (context, index) {
              final highlight = userHighlights[index];
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return HighlightspopupsDialog(
                        highlightID: highlight.id as String,
                        friendsOrProfile: 'friends',
                        username: username,
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: highlight.imageUrl != null
                            ? NetworkImage(highlight.imageUrl!)
                            : const AssetImage('assets/images/default_highlight.jpg') as ImageProvider,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        highlight.highlightsname ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      } else {
        return const Center(child: Text('No highlights found'));
      }
    },
  );
}

}