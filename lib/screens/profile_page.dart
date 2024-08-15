import 'package:flutter/material.dart';
import 'friends_list_page.dart'; // Import the FriendsListPage

class ProfilePage extends StatelessWidget {
  final String username = 'Anas Tamer';
  final String bio = 'MET Major | Student at GUC';
  final int numberOfPosts = 4;
  final int numberOfFriends = 120;
  final int karma = 350;

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
