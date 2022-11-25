import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import "package:geoflutterfire/geoflutterfire.dart";

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

  void addNewResturant({
    required double latitude,
    required double longitude,
    required String address,
  }) {
    final point =
        Geoflutterfire().point(latitude: latitude, longitude: longitude).data;
    final resturnatRef = FirebaseFirestore.instance.collection("restaurants");
    resturnatRef.add({"resturantAddress": address, "location": point});
  }

  void searchResturants(
      {required double latitude,
      required double longitude,
      required double radius}) async {
    GeoFirePoint center =
        Geoflutterfire().point(latitude: latitude, longitude: longitude);

    var collectionReference =
        FirebaseFirestore.instance.collection('restaurants');

    // double radius = 50;
    String field = 'location';

    Stream<List<DocumentSnapshot>> stream = Geoflutterfire()
        .collection(
          collectionRef: collectionReference,
        )
        .within(
          center: center,
          radius: radius,
          field: field,
        );

    List<DocumentSnapshot> documents = await stream.first;
    if (documents.isEmpty) return;
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
    late DocumentSnapshot<Map<String, dynamic>> querySnapshot;
    try {
      querySnapshot =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
    } catch (e) {
      log("there was an error while reading from users collection ${e.toString()}");
      _isLoading = false;
      WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) {
        notifyListeners();
      });
      return false;
    }
    if (!querySnapshot.exists) {
      _isLoading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      return false;
    }
    final docs = querySnapshot.data()!;
    _name = docs["name"];
    _phoneNumber = docs["phoneNumber"];
    /*reset any of previously saved adrress if present happens usualy when user
      logs out in log out screen and then again user logs in
     */
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
    //to refresh token in server whenver users fcm token gets updated
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      try {
        userDoc.update({"fcmToken": token});
      } catch (e) {
        log("error occured while updating fcmToken");
      }
    }).onError((e) {
      log("error occured in onTokenRefresh stream");
    });

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
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await instance.doc(user.uid).set({
      "uid": user.uid,
      "name": name,
      "phoneNumber": phoneNumber,
      "fcmToken": fcmToken,
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
