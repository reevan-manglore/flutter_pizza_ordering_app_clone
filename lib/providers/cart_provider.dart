import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:pizza_app/env/env.dart';

import '../models/pizza_cart_item.dart';
import '../models/sides_cart_item.dart';
import '../models/offer_cupon.dart';
import '../models/restaurant.dart';
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

  int getDiscountForOfferCoupon(OfferCoupon? offerCoupon) {
    if (offerCoupon == null) {
      return 0;
    }
    if (offerCoupon.type == OfferType.offerOnCart &&
        cartTotalAmount >= (offerCoupon as CartOffer).minValue) {
      return min(
        (cartTotalAmount * offerCoupon.discountPercentage / 100).floor(),
        offerCoupon.maxDiscountAmount,
      );
    }

    int discount = 0;
    if (offerCoupon.type == OfferType.offerOnItem) {
      final coupon = offerCoupon as ItemOffer;
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
    return min(discount, offerCoupon.maxDiscountAmount);
  }

  void resetCart() {
    _cartPizzaItems.clear();
    _cartSidesItems.clear();
    _copiedCoupon = null;
    notifyListeners();
  }

  Future<String> _generateRazorPayOrder(int amountToPay) async {
    final reqBody = {
      "amount": amountToPay * 100, //in terms of paisas
      "currency": "INR",
    };
    final razorPayToken =
        'Basic ${base64Encode(utf8.encode("${Env.keyId}:${Env.keySecret}"))}';
    final res = await http.post(
      Uri.parse("https://api.razorpay.com/v1/orders"),
      headers: {
        "Content-Type": "application/json",
        "authorization": razorPayToken,
      },
      body: jsonEncode(reqBody),
    );
    if (res.statusCode != 200) {
      throw const HttpException(
          "some error occured while making order request to razorpay");
    }
    return jsonDecode(res.body)["id"];
  }

  Future<String> placeOrder(Restaurant restaurantAssigned) async {
    final firebaseInstance = FirebaseFirestore.instance;
    final pizzas = getGroupedPizzas();
    final sides = getGroupedSidesItem();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final razorPayId =
        await _generateRazorPayOrder(cartTotalAmount - discount + 40);

    await firebaseInstance.collection("orders").add({
      'razorPayOrderId': razorPayId,
      'uid': uid,
      'orderdOn': DateTime.now().toIso8601String(),
      'resturantId': restaurantAssigned.resturantId,
      'resturantAddress': restaurantAssigned.resturantAddress,
      'cartCost': cartTotalAmount,
      'deliveryCharge': 40,
      if (copiedOffer != null) 'offerApplied': copiedOffer!.offerCode,
      if (copiedOffer != null) 'discountAmount': discount,
      'amountToPay': cartTotalAmount - discount + 40,
      'isPaymentDone': false,
      'cartCount': cartCount,
      'cartItems': [
        ...pizzas.entries
            .map((e) => {
                  "itemId": e.key.pizza.id,
                  "itemType": "pizza",
                  "itemName": e.key.pizza.pizzaName,
                  "choosenSize": e.key.selectedSize.label,
                  "itemPrice": e.key.itemPrice,
                  "quantity": e.value,
                  if (e.key.extraToppings != null)
                    "extraToppings":
                        e.key.extraToppings!.map((e) => e.toppingName).toList(),
                  if (e.key.toppingReplacement != null)
                    "toppingReplacement": {
                      "toppingToBeReplaced": e
                          .key
                          .toppingReplacement!["toppingToBeReplaced"]!
                          .toppingName,
                      "replacementTopping": e
                          .key
                          .toppingReplacement!["replacementTopping"]!
                          .toppingName,
                    }
                })
            .toList(),
        ...sides.entries
            .map((e) => {
                  "itemId": e.key.side.id,
                  "itemType": "side",
                  "itemName": e.key.side.sidesName,
                  "itemPrice": e.key.itemPrice,
                  "itemQuantity": e.value,
                })
            .toList(),
      ],
    });
    return razorPayId;
  }
}
