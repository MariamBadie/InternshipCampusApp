import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:campus_app/helpers/custom_messages.dart';

class FriendRequestObject {
  FriendRequestObject({
    required this.friendRequestID,
    required this.name,
    required this.requestDate,
    required this.profilepic,
  });

  final String name;
  String friendRequestID;
  final DateTime requestDate;
  final Image profilepic;

  String get formattedDate {
    // Register custom messages
    timeago.setLocaleMessages('en', CustomMessages());
    return timeago.format(requestDate, locale: 'en');
  }
}
