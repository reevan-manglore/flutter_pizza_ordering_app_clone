import 'package:pizza_app/providers/toppings_provider.dart';

import '../providers/pizza_item_provider.dart';

import './topping_item.dart';

class PizzaCartItem {
  final PizzaItemProvider pizza;
  final PizzaSizes selectedSize;
  int itemPrice = 0;
  List<ToppingItem>? extraToppings;
  Map<String, ToppingItem>? toppingReplacement;
  /*
    Here toppingReplacement map will contain data as follwing 
    {
      "toppingToBeReplaced":ToppingProvider,
      "replacementTopping":ToppingProvider
    }
  */

  PizzaCartItem({
    required this.pizza,
    required this.selectedSize,
    required this.itemPrice,
    this.extraToppings,
    this.toppingReplacement,
  });
}
