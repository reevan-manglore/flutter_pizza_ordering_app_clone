import 'package:flutter/material.dart';
import "package:lottie/lottie.dart";

import "../screens/home_page/home_page.dart";

class PaymentSuccess extends StatelessWidget {
  const PaymentSuccess({super.key});
  static const routeName = "/payment-success";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              "lib/assets/lotties/payment success.json",
              height: 300,
              alignment: Alignment.center,
              repeat: false,
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              "Your payment is successfull you will shortly recive notification about confirmation about your order",
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
              },
              child: const Text(
                "Return to home page",
                style: TextStyle(color: Colors.white, fontSize: 18),
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
