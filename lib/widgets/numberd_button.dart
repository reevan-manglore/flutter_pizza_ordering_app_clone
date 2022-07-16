import 'package:flutter/material.dart';

class NumberdButton extends StatelessWidget {
  final int value;
  final String label;
  final void Function() onIncrementPressed;
  final void Function() onDecrementPressed;

  const NumberdButton(
    this.value, {
    required this.label,
    required this.onIncrementPressed,
    required this.onDecrementPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (value < 1) {
      return ElevatedButton.icon(
        onPressed: onIncrementPressed,
        label: Text(label),
        icon: Icon(Icons.add),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: onDecrementPressed,
              icon: Icon(
                Icons.remove,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: 6),
            Text(
              "$value",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(width: 6),
            IconButton(
              onPressed: onIncrementPressed,
              icon: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      );
    }
  }
}
