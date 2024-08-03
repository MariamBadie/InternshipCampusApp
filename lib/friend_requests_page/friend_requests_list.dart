import 'package:campus_app/models/friend_request.dart';
import 'package:flutter/material.dart';
import 'package:campus_app/friend_requests_page/friend_request_item.dart';

class FriendRequestsList extends StatelessWidget {
  const FriendRequestsList({super.key, required this.requests});

  final List<FriendRequest> requests;

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (ctx, index) => FriendRequestItem(requests[index]),
    );
  }
}
