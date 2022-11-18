import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show NumberFormat;
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:pizza_app/env/env.dart';
import "package:firebase_auth/firebase_auth.dart";
import '../../providers/cart_provider.dart';
import '../../providers/menu_provider.dart';
import '../../providers/user_account_provider.dart';

import '../order_view_screen/order_view_screen.dart';

class CartBottomBar extends StatefulWidget {
  const CartBottomBar({
    Key? key,
    required this.context,
    required this.amtToPay,
  }) : super(key: key);

  final BuildContext context;
  final int amtToPay;

  @override
  State<CartBottomBar> createState() => _CartBottomBarState();
}

class _CartBottomBarState extends State<CartBottomBar> {
  bool isLoading = false;

  Future<void> _placeOrder() async {
    final resturantAssigned =
        Provider.of<MenuProvider>(context, listen: false).resturantAssigned;

    setState(() => isLoading = true);
    final orderId = await Provider.of<CartProvider>(context, listen: false)
        .placeOrder(resturantAssigned!);
    setState(() => isLoading = false);
    _openCheckout(orderId);
    debugPrint("orderId is ${orderId}");
  }

  Future<void> _openCheckout(String orderId) async {
    final razorPay = Provider.of<Razorpay>(context, listen: false);
    final phoneNumber =
        Provider.of<UserAccountProvider>(context, listen: false).phoneNumber;
    final user = FirebaseAuth.instance.currentUser;
    final options = {
      "key": Env.keyId,
      "amount": 100 * widget.amtToPay,
      "order_id": orderId,
      "name": "Pizza App",
      "timeout": 60 * 5, //5 minutes
      "prefill": {
        "email": user?.email,
        "contact": phoneNumber,
      },
    };
    razorPay.open(options);
  }

  @override
  Widget build(BuildContext context) {
    final numFormatter =
        NumberFormat.currency(locale: "HI", decimalDigits: 0, symbol: "");
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
                          numFormatter.format(widget.amtToPay)..padRight(3),
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: isLoading ? null : _placeOrder,
                  child: isLoading
                      ? const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Place Order & Pay"),
                            const SizedBox(
                              width: 5.0,
                            ),
                            const Icon(Icons.arrow_forward_ios_sharp)
                          ],
                        ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
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
