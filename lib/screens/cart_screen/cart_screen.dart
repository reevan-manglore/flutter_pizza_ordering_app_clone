import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' show NumberFormat;

import './cart_pizza_display_tile.dart';
import './cart_side_display_tile.dart';

import '../../providers/cart_provider.dart';

import '../offer_picking_screen/offer_picking_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-screen";

  const CartScreen({Key? key}) : super(key: key);

  Widget _buildOfferViewTile(int offerAmount) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: LinearGradient(
          colors: [Colors.green.shade300, Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Row(
        children: [
          const Text(
            "You Saved",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.currency_rupee_sharp),
          const SizedBox(
            width: 2.0,
          ),
          Text(
            "$offerAmount",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildSelectOfferTile(BuildContext context, CartProvider cartData) {
    if (cartData.copiedOffer == null || cartData.discount <= 0) {
      return Card(
        child: ListTile(
          onTap: () {
            Navigator.of(context)
                .pushNamed(OfferPickingScreen.routeName)
                .then((value) => print("Returned From offer picking screen"));
          },
          tileColor: Theme.of(context).colorScheme.primaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: const Text(
            "Use Coupons",
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_outlined,
            color: Colors.black,
          ),
        ),
      );
    } else {
      return Card(
        child: ListTile(
          tileColor: Theme.of(context).colorScheme.primaryContainer,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text("\"${cartData.copiedOffer?.offerCode}\" applied"),
          subtitle: Text("₹${cartData.discount} coupon savings"),
          trailing: TextButton(
            child: const Text(
              "Remove",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              cartData.resetAppliedCoupon();
            },
          ),
        ),
      );
    }
  }

  Widget _buildBillingSection(
    BuildContext context, {
    required int itemTotal,
    required int discountAmt,
  }) {
    final numFormater = NumberFormat.currency(
      name: "INR",
      locale: 'en_IN',
      decimalDigits: 0,
      symbol: '₹ ',
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Item Total"),
              trailing: Text(numFormater.format(itemTotal)),
            ),
            const Divider(),
            ListTile(
              title: const Text("Fixed Delivery Charges"),
              trailing: Text(numFormater.format(40)),
            ),
            const Divider(),
            if (discountAmt > 0)
              ListTile(
                title: const Text(
                  "- Coupon Discount ",
                  style: TextStyle(color: Colors.green),
                ),
                trailing: Text(
                  "- ${numFormater.format(discountAmt)}",
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            if (discountAmt > 0) const Divider(),
            ListTile(
              title: const Text(
                "Grand Total",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(
                numFormater.format(itemTotal - discountAmt + 40),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<CartProvider>(context);
    final similarPizza = cartData.getGroupedPizzas();
    final similarSides = cartData.getGroupedSidesItem();
    final discount = cartData.discount;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Your Cart Has Total Of ${cartData.cartCount} Items",
                style: const TextStyle(
                  fontSize: 22,
                ),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            cartData.cartCount < 1
                ? Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        size: 48,
                      ),
                      const Text(
                        "Your Cart Is Empty",
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ))
                : Expanded(
                    child: ListView(
                      children: [
                        if (discount > 0) _buildOfferViewTile(discount),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...similarPizza.keys
                                .map((pizzaItem) => CartPizzaDisplayTile(
                                      elementKey: pizzaItem.hashCode.toString(),
                                      pizzaItem: pizzaItem,
                                      pizzaCount: similarPizza[pizzaItem]!,
                                      whenDismissed: () =>
                                          cartData.removePizzasWhichAreSimilar(
                                              pizzaItem),
                                    ))
                                .toList(),
                            ...similarSides.keys
                                .map(
                                  (sideItem) => CartSidesDisplayTile(
                                    itemKey: sideItem.hashCode.toString(),
                                    sideItem: sideItem,
                                    quantity: similarSides[sideItem]!,
                                    whenDismissed: () {
                                      cartData.removeSidesWhichAreSimilar(
                                        sideItem,
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                            const SizedBox(
                              height: 15.0,
                            ),
                            _buildSelectOfferTile(context, cartData),
                            const SizedBox(
                              height: 15.0,
                            ),
                            _buildBillingSection(
                              context,
                              itemTotal: cartData.cartTotalAmount,
                              discountAmt: discount,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
          ],
        ),
      ),
      bottomNavigationBar: cartData.cartCount > 0
          ? _buildBottomBar(context, cartData.cartTotalAmount - discount + 40)
          : null,
    );
  }

  Widget _buildBottomBar(BuildContext context, int amtToPay) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BottomAppBar(
          elevation: 2,
          child: Container(
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    const Text(
                      "You Have To Pay:",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.currency_rupee),
                        Text(
                          amtToPay.toString()..padRight(3),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Proceed To Pay"),
                      const SizedBox(
                        width: 5.0,
                      ),
                      const Icon(Icons.arrow_forward_ios_sharp)
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    onPrimary: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
