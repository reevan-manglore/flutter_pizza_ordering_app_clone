import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:cloud_firestore/cloud_firestore.dart";

class SidesItemProvider extends ChangeNotifier {
  final String id;
  final String sidesName;
  final String sidesImageUrl;
  final String sidesDescription;
  final int price;
  bool isVegan;
  bool isFavourite;
  final bool isBestSeller;
  final SidesCategory category;

  SidesItemProvider({
    required this.id,
    required this.category,
    required this.sidesName,
    required this.sidesImageUrl,
    required this.sidesDescription,
    required this.price,
    this.isVegan = false,
    this.isBestSeller = false,
    this.isFavourite = false,
  });

  factory SidesItemProvider.fromMap(
      String documentId, Map<String, dynamic> document,
      {required bool isFavourite}) {
    late SidesCategory itemCategory;
    switch (document["itemType"] as String) {
      case "snacks":
        itemCategory = SidesCategory.snacks;
        break;
      case "desserts":
        itemCategory = SidesCategory.desserts;
        break;
      case "drinks":
        itemCategory = SidesCategory.drinks;
        break;
      default:
        throw ArgumentError.value(
            document["itemType"], "Invalid value returned from firebase");
    }
    return SidesItemProvider(
      id: documentId,
      category: itemCategory,
      sidesName: document["itemName"],
      sidesImageUrl: document["itemImageUrl"],
      sidesDescription: document["itemDescription"],
      price: document["itemPrice"],
      isBestSeller: document["isBestSeller"],
      isVegan: document["isVegan"],
      isFavourite: isFavourite,
    );
  }

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
}

enum SidesCategory {
  desserts,
  drinks,
  snacks,
}

// isBestSeller :
// isVegan: 
// itemDescription :
// itemImageUrl:
// itemName :
// itemPrice :
// itemType :

