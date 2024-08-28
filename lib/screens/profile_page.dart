import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'friends_list_page.dart'; // Import the FriendsListPage
import '../models/post.dart'; // Import the Post model
import 'post_details_page.dart'; // Import the PostDetailsPage
import './points_guide.dart'; // Import the KarmaDialog

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String username = 'Anas Tamer';
  final String bio = 'MET Major | Student at GUC';
  int numberOfPosts = 4;
  final int numberOfFriends = 120;
  final int karma = 350;

  List<Post> userPosts = [
    Post(
      id: '1',
      username: 'Anas Tamer',
      type: 'Text',
      content: 'Had a great day exploring Flutter!',
      reactions: {'like': 10, 'love': 5, 'haha': 2},
      comments: [],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      profilePictureUrl: 'assets/images/anas.jpg',
    ),
    Post(
      id: '2',
      username: 'Anas Tamer',
      type: 'Image',
      content: 'Check out this cool picture I took!',
      reactions: {'like': 15, 'love': 8, 'haha': 1},
      comments: [],
      isAnonymous: false,
      timestamp: DateTime.now().subtract(Duration(days: 1)),
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
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildProfileStats(context),
              const SizedBox(height: 24),
              _buildEditProfileButton(context),
              const SizedBox(height: 24),
              _buildUserPosts(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: const AssetImage("assets/images/anas.jpg"),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                username,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                bio,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileStats(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn(context, 'Posts', numberOfPosts),
        _buildStatColumn(context, 'Friends', numberOfFriends),
        _buildStatColumn(context, 'Karma', karma),
      ],
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, int count) {
    return InkWell(
      onTap: () {
        if (label == 'Friends') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FriendsListPage(profileName: username),
            ),
          );
        }
           showDialog(
            context: context,
            builder: (BuildContext context) {
              return KarmaDialog();
            },
          );
      },
      child: Column(
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
      ),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, '/editProfile'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: const Text('Edit Profile'),
      ),
    );
  }

  Widget _buildUserPosts(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Posts',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('MMM d, y h:mm a').format(post.timestamp),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _showDeleteConfirmation(context, index),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostDetailsPage(
                      post: post,
                      onReact: (postId, reactionType) {
                        // Handle reaction
                      },
                      onComment: (postId, username, comment) {
                        // Handle comment
                      },
                      onReactToComment: (postId, commentIndex, reactionType) {
                        // Handle reaction to comment
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Post'),
          content: Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deletePost(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePost(int index) {
    setState(() {
      userPosts.removeAt(index);
      numberOfPosts--;
    });
  }
}