import 'package:flutter/material.dart';

class UserAccountProvider with ChangeNotifier {
  late String name;
  late String phoneNumber;
  late String emailAddress;

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
