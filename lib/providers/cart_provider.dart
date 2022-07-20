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

  //gets last added pizza to cart having (id) id
  PizzaCartItem? getLastAddedPizzaById(String id) {
    //if there doesnt exist pizza in cart with this id then return null
    if (!_cartPizzaItems.any((element) => element.pizza.id == id)) {
      return null;
    }
    return _cartPizzaItems.lastWhere((element) => element.pizza.id == id);
  }

  int get cartCount {
    return _cartPizzaItems.length + _cartSidesItems.length;
  }
}
