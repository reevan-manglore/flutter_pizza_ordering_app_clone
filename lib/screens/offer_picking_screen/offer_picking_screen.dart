import 'package:flutter/material.dart';

class OfferPickingScreen extends StatelessWidget {
  static const String routeName = "/offer-picking-screen";

  const OfferPickingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offer Picker"),
      ),
      body: const Center(
        child: Text(
          "Offer Picking Screen",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
