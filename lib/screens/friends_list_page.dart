import 'package:flutter/material.dart';

class FriendsListPage extends StatefulWidget {
  final String profileName;

  FriendsListPage({required this.profileName});

  @override
  _FriendsListPageState createState() => _FriendsListPageState();
}

class _FriendsListPageState extends State<FriendsListPage> {
  // Sample friends data with profile picture URLs
  List<Map<String, String>> friends = [
    {
      'name': 'Alice',
      'profilePic': 'https://www.example.com/path/to/alice-profile-pic.jpg'
    },
    {
      'name': 'Bob',
      'profilePic': 'https://www.example.com/path/to/bob-profile-pic.jpg'
    },
    {
      'name': 'Charlie',
      'profilePic': 'https://www.example.com/path/to/charlie-profile-pic.jpg'
    },
    {
      'name': 'David',
      'profilePic': 'https://www.example.com/path/to/david-profile-pic.jpg'
    },
    {
      'name': 'Eva',
      'profilePic': 'https://www.example.com/path/to/eva-profile-pic.jpg'
    },
    // Add more friends here
  ];

  List<Map<String, String>> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = friends;
  }

  void _filterFriends(String query) {
    final lowerCaseQuery = query.toLowerCase();
    setState(() {
      filteredFriends = friends
          .where((friend) =>
              friend['name']?.toLowerCase().contains(lowerCaseQuery) ?? false)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.profileName}\'s Friends'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterFriends,
              decoration: const InputDecoration(
                labelText: 'Search Friends',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(friend['profilePic'] ?? ''),
                      radius: 25,
                    ),
                    title: Text(friend['name'] ?? 'Unknown'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
