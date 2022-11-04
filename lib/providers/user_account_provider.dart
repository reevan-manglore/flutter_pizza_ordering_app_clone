import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/user_address.dart';

class UserAccountProvider with ChangeNotifier {
  String _name = "";
  String _phoneNumber = "";

  List<UserAddress> _savedAddresses = [];
  UserAddress? _addressToDeliver;
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
    /*reset any of previously saved adrress if present happens usualy when user
      logos out in log out screen and then again user logs in
     */
    // final deviceId = await FirebaseMessaging.instance.getToken();
    // log("device id is ${deviceId}");

    _savedAddresses = [];
    for (var element in docs["savedAddresses"] as List<dynamic>) {
      _savedAddresses.add(UserAddress.fromMap(element));
    }
    _addressToDeliver = _savedAddresses.firstWhere(
      (ele) => ele.tag == "Home",
      orElse: () => _savedAddresses.first,
    );
    final userDoc = FirebaseFirestore.instance.collection("users").doc(uid);
    try {
      //here if field  addressToDeliver dont exist then this will throw error
      await userDoc.update({
        "addressToDeliver": {
          "latitude": _addressToDeliver?.latitude,
          "longitude": _addressToDeliver?.longitude,
          "placeName": _addressToDeliver?.address,
          "tag": _addressToDeliver?.tag
        }
      });
    } catch (e) {
      /*if field addressToDeliver dont exist then create new field addressToDeliver and merge this
     aleredy existing user document
     */
      await userDoc.set(
        {
          "addressToDeliver": {
            "latitude": _addressToDeliver?.latitude,
            "longitude": _addressToDeliver?.longitude,
            "placeName": _addressToDeliver?.address,
            "tag": _addressToDeliver?.tag
          }
        },
        SetOptions(merge: true),
      );
    }

    _isLoading = false;
    _isRegisterd = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
    return true;
  }

  set addressToDeliver(UserAddress newAddress) {
    if (_addressToDeliver?.geoHash == newAddress.geoHash) return;
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userDoc = FirebaseFirestore.instance.collection("users").doc(uid);
    userDoc.update({
      "addressToDeliver": {
        "latitude": newAddress.latitude,
        "longitude": newAddress.longitude,
        "placeName": newAddress.address,
        "tag": newAddress.tag
      }
    }).then((_) {
      _addressToDeliver = newAddress;
      notifyListeners();
    }).catchError((e) {
      log("error occured while updating addressToDeliver field userDoc $e");
    });
  }

  UserAddress get addressToDeliver {
    return _addressToDeliver ??
        _savedAddresses.firstWhere(
          (element) => element.tag == "Home",
          orElse: () => _savedAddresses[0],
        );
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
    // final deviceId = await FirebaseMessaging.instance.getToken();
    await instance.doc(user.uid).set({
      "uid": user.uid,
      "name": name,
      "phoneNumber": phoneNumber,
      // "deviceId": deviceId,
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

  Future<void> addNewAddress({
    required String address,
    required double latitude,
    required double longitude,
    required String tag,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final instance = FirebaseFirestore.instance.collection("users");
    await instance.doc(user.uid).update({
      "savedAddresses": FieldValue.arrayUnion(
        [
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
      )
    });
    _savedAddresses.add(
      UserAddress(
        address: address,
        latitude: latitude,
        longitude: longitude,
        tag: tag,
      ),
    );
    notifyListeners();
    return;
  }

  String get name => _name;
  String get phoneNumber => _phoneNumber;
  List<UserAddress> get savedAddresses => _savedAddresses;
  bool get isRegisterd => _isRegisterd;
  bool get isLoading => _isLoading;
}
