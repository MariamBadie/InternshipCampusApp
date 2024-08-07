import 'package:flutter/material.dart';
import '../models/friend_request.dart';
import 'friend_request_item.dart';

class FriendRequestsList extends StatelessWidget {
  const FriendRequestsList({
    Key? key,
    required this.requests,
    required this.onDelete,
    required this.onConfirm,
  }) : super(key: key);

  final List<FriendRequest> requests;
  final void Function(int) onDelete;
  final void Function(int) onConfirm;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (ctx, index) => FriendRequestItem(
        request: requests[index],
        onDelete: () => onDelete(index),
        onConfirm: () => onConfirm(index),
      ),
    );
  }
}
