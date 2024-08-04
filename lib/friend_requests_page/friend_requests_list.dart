import 'package:flutter/material.dart';
import 'package:campus_app/models/friend_request.dart';
import 'package:campus_app/friend_requests_page/friend_request_item.dart';

class FriendRequestsList extends StatelessWidget {
  const FriendRequestsList({super.key, required this.requests, required this.onDelete});

  final List<FriendRequest> requests;
  final void Function(int) onDelete;

  @override
  Widget build(context) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (ctx, index) => FriendRequestItem(
        requests[index],
        () => onDelete(index),
      ),
    );
  }
}
