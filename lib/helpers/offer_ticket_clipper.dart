import 'package:flutter/material.dart';

class OfferTicketClipper extends CustomClipper<Path> {
  final double holeRadius;

  OfferTicketClipper({required this.holeRadius});

  @override
  Path getClip(Size size) {
    final double fromBottom = size.height / 2 - 10;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(0.0, size.height - fromBottom - holeRadius)
      ..arcToPoint(
        Offset(0, size.height - fromBottom),
        clockwise: true,
        radius: const Radius.circular(1),
      )
      ..lineTo(0.0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, size.height - fromBottom)
      ..arcToPoint(
        Offset(size.width, size.height - fromBottom - holeRadius),
        clockwise: true,
        radius: const Radius.circular(1),
      );

    path.lineTo(size.width, 0.0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) => true;
}
