import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/sides_cart_item.dart';

class CartSidesDisplayTile extends StatelessWidget {
  const CartSidesDisplayTile({
    required this.itemKey,
    required this.sideItem,
    required this.quantity,
    required this.whenDismissed,
  });

  final SidesCartItem sideItem;
  final int quantity;
  final String itemKey;
  final Function whenDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(itemKey),
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.delete, size: 30),
            const Icon(Icons.delete, size: 30)
          ],
        ),
      ),
      onDismissed: (_) {
        whenDismissed();
      },
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            child: Text("${quantity}x"),
          ),
          title: Text(sideItem.side.sidesName),
          trailing: Text(
            NumberFormat.currency(
              symbol: '₹ ',
              locale: "HI",
              decimalDigits: 0,
            ).format(sideItem.itemPrice * quantity),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
