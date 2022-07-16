import 'package:flutter/cupertino.dart';

import '../providers/pizza_item_provider.dart';

class PizzaCartItem {
  final String pizzaId;
  final PizzaSizes selectedSize;
  int itemPrice = 0;
  List<String>? extraToppings;
  Map<String, String>? toppingToBeReplaced;

  PizzaCartItem({
    required this.pizzaId,
    required this.selectedSize,
    this.extraToppings,
    this.toppingToBeReplaced,
    required this.itemPrice,
  });
}
