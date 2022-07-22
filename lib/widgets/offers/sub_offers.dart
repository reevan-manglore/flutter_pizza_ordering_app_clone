import 'package:flutter/material.dart';

class SubOffers extends StatelessWidget {
  const SubOffers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      children: [
        _SubOfferItem(),
        _SubOfferItem(),
        _SubOfferItem(),
        _SubOfferItem(),
        _SubOfferItem(),
      ],
    );
  }
}

class _SubOfferItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade200,
              Colors.orange.shade300,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
