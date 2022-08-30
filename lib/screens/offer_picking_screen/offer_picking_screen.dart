import 'package:flutter/material.dart';
import 'package:pizza_app/models/offer_cupon.dart';

import 'package:provider/provider.dart';

import "../../providers/offer_provider.dart";
import '../../providers/cart_provider.dart';

import './offer_item_dispaly_card.dart';
import './search_bar.dart';

class OfferPickingScreen extends StatefulWidget {
  static const String routeName = "/offer-picking-screen";

  const OfferPickingScreen({Key? key}) : super(key: key);

  @override
  State<OfferPickingScreen> createState() => _OfferPickingScreenState();
}

class _OfferPickingScreenState extends State<OfferPickingScreen> {
  bool didChangeDependecies = false;
  String _queryString = "";
  List<OfferCoupon> _allCoupons = [];
  List<OfferCoupon> _filterdCoupons = [];
  late final CartProvider cartData;
  final Map<OfferCoupon, int> _discountTable = {};
  @override
  void didChangeDependencies() {
    if (!didChangeDependecies) {
      final offerData = Provider.of<OfferProvider>(context);
      cartData = Provider.of<CartProvider>(context);
      _allCoupons = offerData.getCouponsBasedOnCartItems(cartData);
      for (OfferCoupon i in _allCoupons) {
        _discountTable[i] = cartData.getDiscountForOfferCoupon(i);
      }
      _allCoupons.sort(
        (ele1, ele2) => _discountTable[ele2]! > _discountTable[ele1]! ? 1 : 0,
      );
      _filterdCoupons = _allCoupons;
      didChangeDependecies = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offer Picker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchBar(
              text: _queryString,
              onChanged: _whenInputChanged,
              hintText: "Search By Offer Title Or By Offer Code",
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: _filterdCoupons.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.cancel,
                          size: 70,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "No Coupons Found",
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    )
                  : ListView.builder(
                      itemBuilder: (context, idx) => OfferItemDisplayCard(
                        title: _filterdCoupons[idx].title,
                        description: _filterdCoupons[idx].description,
                        offerCode: _filterdCoupons[idx].offerCode,
                        discountAmt: _discountTable[_filterdCoupons[idx]]!,
                        whenTapped: () =>
                            cartData.copyOffer(_filterdCoupons[idx]),
                      ),
                      itemCount: _filterdCoupons.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _whenInputChanged(String str) {
    final coupons = _allCoupons
        .where(
          (element) =>
              element.title.toLowerCase().contains(str.toLowerCase()) ||
              element.offerCode.toLowerCase().contains(str.toLowerCase()),
        )
        .toList();
    setState(() {
      _queryString = str;
      _filterdCoupons = coupons;
    });
  }
}
