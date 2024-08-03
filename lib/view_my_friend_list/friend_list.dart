import 'package:campus_app/models/friend.dart';
import 'package:flutter/material.dart';

class FriendList extends StatelessWidget {
  final List<Friend> friends = [
    Friend(
      name: 'Yasmeen yasser',
      username: 'yas12',
      profileImageUrl: 'https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1722211200&semt=ais_user',
      isOnline: true,
    ),
    Friend(
      name: 'Khadiga Yehia',
      username: 'Khadigazz',
      profileImageUrl: 'https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1722211200&semt=ais_user',
      isOnline: true,
    ),
    
    // Add more friends here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return Card(
            elevation: 5,
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(friend.profileImageUrl)),
              title: Text(friend.name),
              subtitle: Text(friend.username),
              trailing: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: friend.isOnline ? Colors.green : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}