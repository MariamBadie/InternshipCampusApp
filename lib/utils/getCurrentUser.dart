import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:campus_app/utils/UserNotifier.dart';
import 'package:campus_app/screens/signin.dart';
import 'package:campus_app/backend/Model/User.dart';

User? getCurrentUser(BuildContext context) {
  final user = Provider.of<UserNotifier>(context, listen: false).user;

  if (user == null) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Signin()),
      );
    });
  }

  return user;
}
