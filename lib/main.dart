import 'package:campus_app/friend_requests_page/requests.dart';
import 'package:campus_app/notifications_files/notifications_sent.dart';
import 'package:campus_app/view_blocked_accounts/blocked_accounts.dart';
import 'package:campus_app/view_my_friend_list/friend_list.dart';
import 'package:campus_app/view_my_profile/run_view_my_profile.dart';
import 'package:campus_app/view_others_profile/run_view_others_profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(home: BlockedAccounts(),
    ),
  );
}
