import 'package:flutter/material.dart';

import 'package:intl/intl.dart' show NumberFormat;

class OrderSideDisplayTile extends StatelessWidget {
  const OrderSideDisplayTile({
    required this.sidesName,
    required this.quantityOrderd,
    required this.cost,
  });
  final String sidesName;
  final int cost;
  final int quantityOrderd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text("${quantityOrderd}x"),
        ),
        title: Text(sidesName),
        trailing: Text(
          NumberFormat.currency(
            symbol: '₹ ',
            locale: "HI",
            decimalDigits: 0,
          ).format(cost * quantityOrderd),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
