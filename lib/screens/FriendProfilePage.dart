import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FriendProfilePage extends StatelessWidget {
  final String name;
  final String profilePic;
  final String bio = 'Friend\'s Bio | Additional Info'; // Placeholder bio
  final int numberOfPosts = 10; // Placeholder post count
  final int numberOfFriends = 50; // Placeholder friends count
  final int karma = 100; // Placeholder karma

  const FriendProfilePage({super.key, required this.name, required this.profilePic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert), // 3 dots icon
            onSelected: (String result) {
              switch (result) {
                case 'Report User':
                  _showReportDialog(context);
                  break;
                case 'Block User':
                  _showBlockConfirmationDialog(context);
                  break;
                case 'Share User':
                  Clipboard.setData(ClipboardData(text: 'https://yourapp.com/user/$name'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Profile URL copied to clipboard')),
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
              _buildSendMessageButton(context),
              const SizedBox(height: 24),
              _buildUserPosts(context),
            ],
          ),
        ),
      ),
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
          backgroundImage: NetworkImage(profilePic),
          backgroundColor: Colors.grey[200],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        _buildStatColumn('Posts', numberOfPosts),
        _buildStatColumn('Friends', numberOfFriends),
        _buildStatColumn('Karma', karma),
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
          itemCount: 5, // Show only 5 most recent posts
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: const Icon(Icons.post_add),
                title: Text('Post Title ${index + 1}'),
                subtitle: const Text('Post content preview...'),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/postDetails',
                  arguments: {'postId': index},
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}