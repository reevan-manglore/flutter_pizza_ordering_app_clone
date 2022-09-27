import 'package:flutter/widgets.dart';

class SidesItemProvider extends ChangeNotifier {
  final String id;
  final String sidesName;
  final String sidesImageUrl;
  final String sidesDescription;
  final int price;
  bool isVegan;
  bool isFaviourite;
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
    this.isFaviourite = false,
  });

  factory SidesItemProvider.fromMap(
      String documentId, Map<String, dynamic> document) {
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
    );
  }

  void toogleFaviourite() {
    isFaviourite = !isFaviourite;
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

