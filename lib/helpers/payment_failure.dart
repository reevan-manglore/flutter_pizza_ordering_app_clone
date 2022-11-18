import 'package:flutter/material.dart';
import "package:lottie/lottie.dart";

import "../screens/cart_screen/cart_screen.dart";
import '../screens/home_page/home_page.dart';

class PaymentFailure extends StatelessWidget {
  const PaymentFailure({super.key});
  static const routeName = "/payment-failure";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "lib/assets/lotties/payment_failed.json",
              height: 300,
              alignment: Alignment.center,
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              "Your payment failed due to some unexpected reasons",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 36,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(
                    context, ModalRoute.withName(HomePage.routeName));
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              child: const Text(
                "Return to your cart page",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                alignment: Alignment.center,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                minimumSize: const Size.fromHeight(32),
              ),
            )
          ],
        ),
      ),
    );
  }
}
