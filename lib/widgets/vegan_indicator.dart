import 'package:flutter/material.dart';

class VeganIndicator extends StatelessWidget {
  final bool isVegan;
  const VeganIndicator({required this.isVegan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: isVegan ? Colors.green.shade400 : Colors.red.shade400,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 6,
        backgroundColor: isVegan ? Colors.green.shade400 : Colors.red.shade400,
      ),
    );
  }
}
