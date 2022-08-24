import 'package:flutter/material.dart';

/// Multiple rounded curve clipper to use with [ClipPath]
class MultipleRoundedCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final cutLength = 5.0;
    Path path = Path();
    final width = size.width;
    final fakeHeight = size.height - cutLength;
    double xCursor = 0.0;
    double yCursor = 5.0;
    path.lineTo(0, cutLength);
    while (yCursor < fakeHeight) {
      path.arcToPoint(
        Offset(xCursor, yCursor + cutLength),
        radius: Radius.circular(cutLength),
      );
      yCursor += 5;
      path.lineTo(xCursor, yCursor + cutLength);
      yCursor += cutLength;
    }
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
