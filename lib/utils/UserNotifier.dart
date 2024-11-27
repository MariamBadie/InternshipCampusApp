import 'package:flutter/foundation.dart';
import 'package:campus_app/backend/Model/User.dart';

class UserNotifier extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
