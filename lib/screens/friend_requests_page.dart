import 'package:flutter/material.dart';
import '../models/friend_request.dart';
import '../widgets/friend_requests_list.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({Key? key}) : super(key: key);

  @override
  _FriendRequestsPageState createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  final List<FriendRequest> _requests = [
    FriendRequest(
      name: 'Anas Tamer',
      requestDate: DateTime.now().subtract(const Duration(days: 1)),
      profilePic: AssetImage('assets/images/profile-pic.png'),
    ),
    FriendRequest(
      name: 'Hussien Haitham',
      requestDate: DateTime.now().subtract(const Duration(days: 2)),
      profilePic: AssetImage('assets/images/profile-pic.png'),
    ),
  ];

  void _deleteRequest(int index) {
    setState(() {
      _requests.removeAt(index);
    });
  }

  void _confirmRequest(int index) {
    // Handle confirmation logic
    print('Friend request from ${_requests[index].name} confirmed');
    setState(() {
      _requests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend Requests'),
      ),
      body: FriendRequestsList(
        requests: _requests,
        onDelete: _deleteRequest,
        onConfirm: _confirmRequest,
      ),
    );
  }
}
