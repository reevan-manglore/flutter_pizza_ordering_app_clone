import 'package:flutter/material.dart';

class PizzaItemProvider with ChangeNotifier {
  final String id;
  final String pizzaName;
  final String pizzaImageUrl;
  String description;
  Map<PizzaSizes, int> price;
  bool isVegan = false;
  late bool isFaviourite;
  late bool isBestSeller = false;
  bool isCustomizable = false;
  PizzaItemProvider({
    required this.id,
    required this.pizzaName,
    required this.description,
    required this.price,
    required this.pizzaImageUrl,
    this.isVegan = false,
    this.isFaviourite = false,
    this.isBestSeller = false,
    this.isCustomizable = false,
  });

  void toogleFaviourite() {
    isFaviourite = !isFaviourite;
    notifyListeners();
  }

  factory PizzaItemProvider.fromMap(
      String documentId, Map<String, dynamic> document) {
    return PizzaItemProvider(
      id: documentId,
      pizzaName: document["itemName"],
      description: document["itemDescription"],
      pizzaImageUrl: document["itemImageUrl"],
      isBestSeller: document["isBestSeller"] ?? false,
      isCustomizable: document["isCustomizable"] ?? false,
      isVegan: document["isVegan"] ?? false,
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
