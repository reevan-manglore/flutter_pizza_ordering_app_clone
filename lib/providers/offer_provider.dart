import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';

import '../providers/cart_provider.dart';
import '../models/offer_cupon.dart';

class OfferProvider with ChangeNotifier {
  List<OfferCoupon> _offers = [];
  bool _isLoading = false;
  bool _hasError = true;
  String? _errMsg;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  String? get errMsg => _errMsg;

  Future<void> fetchAndSetOffers() async {
    try {
      final List<OfferCoupon> tempOfferArr = [];
      _isLoading = true;
      _hasError = false; //if in case _hasError is true
      _errMsg = null;
      final conectivityReult = await Connectivity().checkConnectivity();
      if (conectivityReult == ConnectivityResult.none) {
        throw const SocketException("Sorry internet connection not found");
      }

      /*
        here whenever we call notify listeners in middle of  build process i.e is during inital fetch
        (when home page is loaded) it requests the Flutter Framework to rebuild it 
        but Flutter is already in a build process. 
        here,so Flutter rejects the request and throws an exception.
        so inorder to prevent this exception we call addPostFrameCallback() is called
        inorder to ensure that closure. notifyListeners() will be executed after the build is complete.
      */
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      final queySnapshot = await FirebaseFirestore.instance
          .collection("offerCoupons")
          .where("validTill", isGreaterThan: Timestamp.now())
          .get();
      final offerCoupons = queySnapshot.docs;
      for (var element in offerCoupons) {
        print(element.data()["title"]);
        tempOfferArr.add(
          OfferCoupon.fromMap(
            documentId: element.id,
            document: element.data(),
          ),
        );
      }
      _offers = tempOfferArr;
    } on SocketException catch (e) {
      log("there was some problem in clients internet connection$e");
      _errMsg = e.message;
      _hasError = true;
    } on FirebaseException catch (e) {
      log("there was some problem while fetching data $e");
      _errMsg = e.message;
      _hasError = true;
    } catch (e) {
      log("there was some error $e");
      _errMsg = e.toString();
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<OfferCoupon> get offers {
    return _offers
        .where((element) => element.validTill.isAfter(DateTime.now()))
        .toList();
  }

  OfferCoupon? get heroOffer {
    try {
      return offers.firstWhere(
        (element) => element.isHeroOffer,
        orElse: () => _offers.first,
      );
    } catch (e) {
      log("an error occured becuase _offers list was empty");
      return null;
    }
  }

  List<OfferCoupon> get subOffers {
    OfferCoupon? bestSeller = heroOffer;
    return offers.where((element) => element.id != bestSeller?.id).toList();
  }

  OfferCoupon getOfferById(String id) {
    return offers.singleWhere((element) => element.id == id);
  }

  List<OfferCoupon> getCouponsBasedOnCartItems(CartProvider cartData) {
    Set<OfferCoupon> items = {};
    final itemOffers = offers.whereType<ItemOffer>().toList();
    final cartOffers = offers.whereType<CartOffer>().toList();
    for (final i in cartData.pizzas) {
      items.addAll(itemOffers
          .where((element) => element.applicableItems.contains(i.pizza.id)));
    }
    for (final i in cartData.sides) {
      items.addAll(itemOffers
          .where((element) => element.applicableItems.contains(i.side.id)));
    }

    items.addAll(cartOffers
        .where((element) => cartData.cartTotalAmount >= element.minValue));
    return items.toList();
  }
}


  //final List<OfferCoupon> _offers = [
  //   CartOffer(
  //     id: "123",
  //     offerCode: "abc123",
  //     title: "Raining discounts",
  //     description: "up to 50% on tempting pizzas",
  //     discountPercentage: 50,
  //     minValue: 149,
  //     maxDiscountAmount: 100,
  //     validTill: DateTime.parse("2022-11-25"),
  //   ),
  //   ItemOffer(
  //     id: "456",
  //     offerCode: "abc456",
  //     title: "Extrodunary Discounts",
  //     description: "up to 40% on tempting pizzas",
  //     discountPercentage: 40,
  //     maxDiscountAmount: 80,
  //     validTill: DateTime.parse("2022-08-25"),
  //     applicableItems: [
  //       "123",
  //       "567",
  //       "abc124",
  //       "gad625",
  //     ],
  //   ),
  //   ItemOffer(
  //     id: "678",
  //     offerCode: "abc678",
  //     title: "Extrodinary Discounts",
  //     description: "up to 20% on tempting pizzas",
  //     discountPercentage: 40,
  //     maxDiscountAmount: 40,
  //     validTill: DateTime.parse("2022-11-25"),
  //     isHeroOffer: true,
  //     applicableItems: [
  //       "456",
  //       "123",
  //       "gad625",
  //       "bcd538",
  //     ],
  //   ),
  // ];
