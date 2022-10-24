import 'package:flutter/material.dart';
import 'package:tmdt/models/user.dart';

class UserManager extends ChangeNotifier {
  User? _user;

  User? get getUser {
    return _user;
  }

  set setUser(User? value) {
    _user = value;
    notifyListeners();
  }
}
