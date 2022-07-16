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
