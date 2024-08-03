import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for Clipboard

class ProfilePage extends StatelessWidget {
  final String profileImageUrl;
  final String profilePageUrl;
  final String username;
  final String fullName;
  final String bio;
  final String location;
  final int postCount;
  final int followerCount;
  final int followingCount;
  final Widget body;

  const ProfilePage({
    super.key,
    required this.profileImageUrl,
    required this.profilePageUrl,
    required this.username,
    required this.fullName,
    required this.bio,
    required this.location,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Color.fromARGB(255, 58, 161, 139),
        actions: [
          IconButton(
            icon: Icon(Icons.copy), // Icon for copying URL
            onPressed: () {
              Clipboard.setData(ClipboardData(text: profilePageUrl)); // Copy profilePageUrl
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile URL copied to clipboard!')),
              );
            },
          ),
          //IconMenu(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Hero image
                // Image.asset('assets/hero_image.jpg'),
                // User information
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage(profileImageUrl),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(fullName),
                            ],
                          ),
                        ],
                      ),
                      Text(bio),
                      Text(location),
                    ],
                  ),
                ),
                // User stats
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('$postCount', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Posts'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('$followerCount', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Followers'),
                        ],
                      ),
                      Column(
                        children: [
                          Text('$followingCount', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Following'),
                        ],
                      ),
                    ],
                  ),
                ),
                // Image grid
                // ...
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: body,
          ),
        ],
      ),
    );
  }
}