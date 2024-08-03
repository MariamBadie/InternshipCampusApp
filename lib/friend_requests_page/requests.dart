import 'package:campus_app/models/friend_request.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/friend_requests_page/friend_requests_list.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  State<Requests> createState() {
    return _RequestsState();
  }
}

class _RequestsState extends State<Requests> {
  final List<FriendRequest> _avaliableRequests = [
    FriendRequest(
      name: 'Aya Mahmoud',
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    FriendRequest(
      name: 'Mayar Ahmed',
      requestDate: DateTime.now().subtract(const Duration(days: 5)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    FriendRequest(
      name: 'Yaseen Mostafa',
      requestDate: DateTime.now().subtract(const Duration(days: 10)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
    FriendRequest(
      name: 'Jomana Ayman',
      requestDate: DateTime.now().subtract(const Duration(days: 20)),
      profilepic: Image.asset('assets/images/profile-pic.png', width: 200),
    ),
  ];

  @override
  Widget build(context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FriendRequestsList(requests: _avaliableRequests),
          ),
        ],
      ),
    );
  }
}
