import 'package:flutter/material.dart';

class SubOfferCard extends StatelessWidget {
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
        width: 300,
        height: 100,
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
