import 'package:campus_app/view_others_profile/icon_menu.dart';
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
        title: Text('Profile'),
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
          IconMenu(),
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
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(bio),
                              Text(location),
                            ],
                          ),
                          Spacer(), // Pushes the button to the right
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 119, 160, 158),
                              minimumSize: Size(60, 30),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Follow', style: TextStyle(color: Color.fromARGB(255, 27, 27, 27))),
                          ),
                        ],
      ),
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
