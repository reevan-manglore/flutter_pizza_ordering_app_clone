import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_address.dart';

class UserAccountProvider with ChangeNotifier {
  String _name = "";
  String _phoneNumber = "";

  List<UserAddress> _savedAddresses = [];
  bool _isRegisterd = false;
  bool _isLoading = false;

  UserAccountProvider() {
    fetchAndSetUser();
  }

  //try to fetch user details if user is registerd then this returns true or else false
  Future<bool> fetchAndSetUser() async {
    _isRegisterd = false;
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    if (FirebaseAuth.instance.currentUser == null) {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return false;
    }
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where(
          "uid",
          isEqualTo: uid,
        )
        .get();
    if (querySnapshot.docs.isEmpty) {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return false;
    }
    final docs = querySnapshot.docs.first.data();
    _name = docs["name"];
    _phoneNumber = docs["phoneNumber"];

    for (var element in docs["savedAddresses"] as List<dynamic>) {
      _savedAddresses.add(UserAddress.fromMap(element));
    }
    _isLoading = false;
    _isRegisterd = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    return true;
  }

  Future<void> createNewUser({
    required String name,
    required String phoneNumber,
    required String address,
    required double latitude,
    required double longitude,
    required String tag,
  }) async {
    _isRegisterd = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final instance = FirebaseFirestore.instance.collection("users");
    await instance.doc(user.uid).set({
      "uid": user.uid,
      "name": name,
      "phoneNumber": phoneNumber,
      "favourites": [],
      "savedAddresses": [
        {
          "placeName": address,
          "latitude": latitude,
          "longitude": longitude,
          "geoHash": UserAddress.getGeoHashFromLatLang(
            latitude: latitude,
            longitude: longitude,
          ),
          "tag": tag
        }
      ],
    });
    _name = name;

    _phoneNumber = phoneNumber;
    _savedAddresses = [
      UserAddress(
        address: address,
        latitude: latitude,
        longitude: longitude,
        tag: tag,
      )
    ];
    _isRegisterd = true;
    notifyListeners();
  }

  String get name => _name;
  String get phoneNumber => _phoneNumber;
  List<UserAddress> get savedAddresses => _savedAddresses;
  bool get isRegisterd => _isRegisterd;
  bool get isLoading => _isLoading;
}
