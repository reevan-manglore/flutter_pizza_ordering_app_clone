import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import "../../providers/offer_provider.dart";
import '../../providers/cart_provider.dart';

import './offer_item_dispaly_card.dart';

class OfferPickingScreen extends StatelessWidget {
  static const String routeName = "/offer-picking-screen";

  const OfferPickingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offerData = Provider.of<OfferProvider>(context);
    final cartData = Provider.of<CartProvider>(context);
    final offers = offerData.getCouponsBasedOnCartItems(cartData);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Offer Picker"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, idx) => OfferItemDisplayCard(
              title: offers[idx].title,
              description: offers[idx].description,
              offerCode: offers[idx].offerCode,
              discountAmt: cartData.getDiscountForOfferCoupon(
                offers[idx],
              ),
              whenTapped: () => cartData.copyOffer(offers[idx]),
            ),
            itemCount: offers.length,
          ),
        ));
  }
}
