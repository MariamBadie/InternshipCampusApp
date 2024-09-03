import 'package:flutter/material.dart';
import '../models/Community.dart';
import '../backend/Model/Post.dart';
import '../models/User.dart';
import '../screens/suggested_community_page.dart';
import '../screens/community_list.dart';
import '../screens/for_you_page.dart';
import '../screens/create_new_community.dart';

class CommunityGeneralPage extends StatelessWidget {
  final List<Community> myCommunities = [
    Community(
      id: 'comm1',
      name: 'Math501',
      pictureUrl: 'assets/images/community2Picture.webp',
      members: [
        User(name: 'Hussien Haitham', profilPictureUrl: 'assets/images/hussien.jpg'),
        User(name: 'Anas', profilPictureUrl: 'assets/images/anas.jpg'),
        User(name: 'Mohanad', profilPictureUrl: 'assets/images/mohanad.jpg'),
        User(name: 'Ahmed Hany', profilPictureUrl: 'assets/images/ahmed.jpg'),
      ],
      posts: [
        Post(
          id: '1',
          username: 'Hussien Haitham',
          type: 'Confession',
          content: "I really admire Professor Mervat's teaching style!",
          upvotes: 7,
          downvotes: 1,
          comments: [
            Comment(
              username: 'Anas',
              content: 'I agree! Her lectures are great.',
              upvotes: 3,
              downvotes: 0,
              profilePictureUrl: 'assets/images/anas.jpg',
            ),
            Comment(
              username: 'Mohanad',
              content: 'What subjects does she teach?',
              upvotes: 3,
              downvotes: 0,
              profilePictureUrl: 'assets/images/mohanad.jpg',
            ),
          ],
          isAnonymous: false,
          isConfession: true,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          profilePictureUrl: 'assets/images/hussien.jpg',
        ),
        Post(
          id: '2',
          username: 'Ahmed Hany',
          type: 'Help',
          content: 'Can someone help me with Math203 problems?',
          upvotes: 3,
          downvotes: 0,
          comments: [
            Comment(
              username: 'Ibrahim',
              content: 'Sure, tell me how can I help?',
              upvotes: 2,
              downvotes: 0,
              profilePictureUrl: 'assets/images/ibrahim.jpg',
            ),
          ],
          isAnonymous: false,
          isConfession: false,
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          profilePictureUrl: 'assets/images/ahmed.jpg',
        ),
      ],
      memberCounter: 4,
      goal: 'Educational',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    Community(
      id: 'comm2',
      name: 'Monday 6',
      pictureUrl: 'assets/images/community4.webp',
      members: [],
      posts: [],
      memberCounter: 0,
      goal: 'Club',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
  ];

  final List<Community> suggestedCommunities = [
    Community(
      id: 'comm3',
      name: 'Tuesday 5',
      pictureUrl: 'assets/images/community3.webp',
      members: [],
      posts: [],
      memberCounter: 0,
      goal: 'Athletic',
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
    ),
    Community(
      id: 'comm4',
      name: 'ICPC',
      pictureUrl: 'assets/images/community4.webp',
      members: [],
      posts: [],
      memberCounter: 0,
      goal: 'Club',
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
  ];

  CommunityGeneralPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Icon(Icons.group),
              SizedBox(width: 8.0),
              Text(
                'Communities',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.add_circle),
              onSelected: (String result) {
                if (result == 'newCommunity') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewCommunity()),
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem(
                  value: 'newCommunity',
                  child: Text('Create new Community'),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'For You', icon: Icon(Icons.feed)),
              Tab(text: 'Your Communities', icon: Icon(Icons.people_alt_sharp)),
              Tab(text: 'Discover', icon: Icon(Icons.public)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ForYouPage(communities: myCommunities),
            CommunityListPage(communities: myCommunities),
            SuggestedCommunityPage(SuggestedCommunities: suggestedCommunities),
          ],
        ),
      ),
    );
  }
}
