import 'package:flutter/widgets.dart';

import '../models/pizza_cart_item.dart';
import '../providers/pizza_item_provider.dart';

class CartProvider extends ChangeNotifier {
  List<PizzaCartItem> _cartPizzaItems = [];
  List _cartSidesItems = [];

  void addPizza(PizzaCartItem pizza) {
    _cartPizzaItems.add(pizza);
    notifyListeners();
  }

  int countOfPizzaItem(PizzaItemProvider pizza) {
    return _cartPizzaItems.where((element) => element.pizza == pizza).length;
  }

  void reducePizzaFromCart(PizzaItemProvider pizza) {
    int index =
        _cartPizzaItems.lastIndexWhere((element) => element.pizza == pizza);
    if (index < 0) {
      return;
    }
    _cartPizzaItems.removeAt(index);
    notifyListeners();
  }

  int get cartCount {
    return _cartPizzaItems.length + _cartSidesItems.length;
  }
}
