import 'dart:math';

import 'package:flutter/widgets.dart';

import '../models/pizza_cart_item.dart';
import '../models/sides_cart_item.dart';
import '../models/offer_cupon.dart';
import '../providers/pizza_item_provider.dart';
import '../providers/sides_item_provider.dart';

class CartProvider extends ChangeNotifier {
  final List<PizzaCartItem> _cartPizzaItems = [];
  final List<SidesCartItem> _cartSidesItems = [];
  OfferCoupon? _copiedCoupon;
  dynamic get cartItems {
    return [..._cartPizzaItems, ..._cartSidesItems];
  }

  List<PizzaCartItem> get pizzas {
    return _cartPizzaItems;
  }

  List<SidesCartItem> get sides {
    return _cartSidesItems;
  }

  Map<PizzaCartItem, int> getGroupedPizzas() {
    Map<PizzaCartItem, int> items = {};
    for (PizzaCartItem pizzaItem in _cartPizzaItems) {
      PizzaCartItem? foundSimilarPizza;
      for (PizzaCartItem i in items.keys) {
        if (pizzaItem == i) {
          foundSimilarPizza = i;
          break;
        }
      }

      if (foundSimilarPizza == null) {
        items[pizzaItem] = 1;
      } else {
        items[foundSimilarPizza] = items[foundSimilarPizza]! + 1;
      }
    }
    return items;
  }

  void removePizzasWhichAreSimilar(PizzaCartItem similarPizza) {
    _cartPizzaItems.removeWhere((element) => element == similarPizza);
    notifyListeners();
  }

  void removeSidesWhichAreSimilar(SidesCartItem similarSides) {
    _cartSidesItems.removeWhere((element) => element == similarSides);
    notifyListeners();
  }

  Map<SidesCartItem, int> getGroupedSidesItem() {
    Map<SidesCartItem, int> items = {};
    for (SidesCartItem sidesItem in _cartSidesItems) {
      if (items.containsKey(sidesItem)) {
        items[sidesItem] = items[sidesItem]! + 1;
      } else {
        items[sidesItem] = 1;
      }
    }

    return items;
  }

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

  void addSide(SidesCartItem side) {
    _cartSidesItems.add(side);
    notifyListeners();
  }

  void reduceSideFromCart(SidesItemProvider side) {
    int index =
        _cartSidesItems.lastIndexWhere((element) => element.side == side);
    if (index < 0) {
      return;
    }
    _cartSidesItems.removeAt(index);
    notifyListeners();
  }

  int countOfSideItem(SidesItemProvider side) {
    return _cartSidesItems.where((element) => element.side == side).length;
  }

  int get cartCount {
    return _cartPizzaItems.length + _cartSidesItems.length;
  }

  int get cartTotalAmount {
    int amount = 0;
    amount = _cartPizzaItems.fold<int>(
        amount, (previousValue, element) => previousValue + element.itemPrice);
    amount = _cartSidesItems.fold<int>(
        amount, (previousValue, element) => previousValue + element.itemPrice);
    return amount;
  }

  OfferCoupon? get copiedOffer {
    return _copiedCoupon;
  }

  void copyOffer(OfferCoupon cupon) {
    _copiedCoupon = cupon;
    notifyListeners();
  }

  void resetAppliedCoupon() {
    _copiedCoupon = null;
    notifyListeners();
  }

  int get discount {
    if (_copiedCoupon == null) {
      return 0;
    }

    if (_copiedCoupon!.type == OfferType.offerOnCart &&
        cartTotalAmount >= (_copiedCoupon as CartOffer).minValue) {
      return min(
        (cartTotalAmount * _copiedCoupon!.discountPercentage / 100).floor(),
        _copiedCoupon!.maxDiscountAmount,
      );
    }

    int discount = 0;
    if (_copiedCoupon!.type == OfferType.offerOnItem) {
      final coupon = copiedOffer as ItemOffer;
      for (PizzaCartItem pizza in _cartPizzaItems) {
        if (coupon.applicableItems.contains(pizza.pizza.id)) {
          discount +=
              (pizza.itemPrice * coupon.discountPercentage / 100).ceil();
        }
        if (discount >= coupon.maxDiscountAmount) {
          return min(discount, coupon.maxDiscountAmount);
        }
      }
      for (SidesCartItem side in _cartSidesItems) {
        if (coupon.applicableItems.contains(side.side.id)) {
          discount += (side.itemPrice * coupon.discountPercentage / 100).ceil();
        }
        if (discount >= coupon.maxDiscountAmount) {
          return min(discount, coupon.maxDiscountAmount);
        }
      }
    }
    return min(discount, _copiedCoupon!.maxDiscountAmount);
  }
}
