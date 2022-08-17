import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../models/offer_cupon.dart';

class OfferProvider with ChangeNotifier {
  final List<OfferCoupon> _offers = [
    CartOffer(
      id: "123",
      offerCode: "abc123",
      title: "Raining discounts",
      description: "up to 50% on tempting pizzas",
      discountPercentage: 50,
      minValue: 149,
      maxDiscountAmount: 100,
      validTill: DateTime.parse("2022-08-25"),
    ),
    ItemOffer(
      id: "456",
      offerCode: "abc456",
      title: "Extrodunary Discounts",
      description: "up to 40% on tempting pizzas",
      discountPercentage: 40,
      maxDiscountAmount: 80,
      validTill: DateTime.parse("2022-08-25"),
      applicableItems: [
        "123",
        "567",
        "abc124",
        "gad625",
      ],
    ),
    ItemOffer(
      id: "678",
      offerCode: "abc678",
      title: "Extrodinary Discounts",
      description: "up to 20% on tempting pizzas",
      discountPercentage: 40,
      maxDiscountAmount: 40,
      validTill: DateTime.parse("2022-08-25"),
      isHeroOffer: true,
      applicableItems: [
        "456",
        "123",
        "gad625",
        "bcd538",
      ],
    ),
  ];
  List<OfferCoupon> get offers {
    return _offers;
  }

  OfferCoupon? get heroOffer {
    try {
      return _offers.firstWhere(
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
    return _offers.where((element) => element.id != bestSeller?.id).toList();
  }

  OfferCoupon getOfferById(String id) {
    return _offers.singleWhere((element) => element.id == id);
  }
}
