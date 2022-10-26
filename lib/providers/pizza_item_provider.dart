import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PizzaItemProvider with ChangeNotifier {
  final String id;
  final String pizzaName;
  final String pizzaImageUrl;
  String description;
  Map<PizzaSizes, int> price;
  bool isVegan = false;
  late bool isFavourite;
  late bool isBestSeller = false;
  bool isCustomizable = false;
  PizzaItemProvider({
    required this.id,
    required this.pizzaName,
    required this.description,
    required this.price,
    required this.pizzaImageUrl,
    this.isVegan = false,
    this.isFavourite = false,
    this.isBestSeller = false,
    this.isCustomizable = false,
  });

  void toogleFaviourite() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userDocument =
        FirebaseFirestore.instance.collection("users").doc(uid);

    if (isFavourite) {
      //implementing optimestic updates
      userDocument.update({
        "favourites": FieldValue.arrayRemove([id])
      }).catchError((_) {
        isFavourite = true;
        notifyListeners();
      });
    } else {
      //implementing optimestic updates
      userDocument.update({
        "favourites": FieldValue.arrayUnion([id])
      }).catchError((_) {
        isFavourite = false;
        notifyListeners();
      });
    }

    isFavourite = !isFavourite;
    notifyListeners();
  }

  factory PizzaItemProvider.fromMap(
      String documentId, Map<String, dynamic> document,
      {required bool isFavourite}) {
    return PizzaItemProvider(
      id: documentId,
      pizzaName: document["itemName"],
      description: document["itemDescription"],
      pizzaImageUrl: document["itemImageUrl"],
      isBestSeller: document["isBestSeller"] ?? false,
      isCustomizable: document["isCustomizable"] ?? false,
      isVegan: document["isVegan"] ?? false,
      isFavourite: isFavourite,
      price: (document["itemPrice"] as Map<String, dynamic>).map((size, price) {
        switch (size) {
          case "small":
            return MapEntry(PizzaSizes.small, price);
          case "medium":
            return MapEntry(PizzaSizes.medium, price);
          case "large":
            return MapEntry(PizzaSizes.large, price);
          default:
            throw ArgumentError.value(
              {size, price},
              "Invalid value returned from firebase",
            );
        }
      }),
    );
  }
}

enum PizzaSizes {
  small("Small"),
  medium("Medium"),
  large("Large");

  final String label;
  const PizzaSizes(this.label);
  String get getDisplayName {
    return label;
  }
}
