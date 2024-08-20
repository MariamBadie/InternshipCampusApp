import 'package:flutter/material.dart';

class BlockedAccountObject {
  final String blockedAccountID; // Add this field
  final String blockedAccountName;
  final Image blockedAccountProfilePic;

  BlockedAccountObject({
    required this.blockedAccountID, // Initialize the ID
    required this.blockedAccountName,
    required this.blockedAccountProfilePic,
  });
}

