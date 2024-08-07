import 'package:flutter/material.dart';

class FriendRequest {
  final String name;
  final DateTime requestDate;
  final ImageProvider profilePic;

  FriendRequest({
    required this.name,
    required this.requestDate,
    required this.profilePic,
  });

  String get formattedDate {
    return '${requestDate.day}/${requestDate.month}/${requestDate.year}';
  }
}
