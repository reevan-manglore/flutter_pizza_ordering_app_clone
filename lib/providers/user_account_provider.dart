import 'package:flutter/material.dart';

class UserAccountProvider with ChangeNotifier {
  late String name;
  late String phoneNumber;
  late String emailAddress;
  bool _isLoggedIn = true;
  bool get isLoggedIn => _isLoggedIn;

  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setAccountDetails(
      {required name, required phoneNumber, required emailAddress}) {
    this.name = name;
    this.phoneNumber = phoneNumber;
    this.emailAddress = emailAddress;
    notifyListeners();
  }

  void updateName(String name) {
    this.name = name;
    notifyListeners();
  }

  void updateEmailAddress(String email) {
    emailAddress = email;
    notifyListeners();
  }
}
