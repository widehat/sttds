import 'package:flutter/material.dart';

class NotchPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double notchRadius = 24;
    const double notchChord = 17.8885 * 2;
    double width = size.width;
    double height = size.height;
    double heightToTopOfNotch = (height - notchChord) / 2;
    double heightToBottomOfNotch = (height + notchChord) / 2;
    Offset rightNotchBottomPoint = Offset(width, heightToBottomOfNotch);
    // Offset leftNotchTopPoint = Offset(0, heightToTopOfNotch);

    final path = Path()
      // ..moveTo(0, 0)
      ..lineTo(width, 0)
      ..lineTo(width, heightToTopOfNotch)
      ..arcToPoint(rightNotchBottomPoint,
          radius: Radius.circular(notchRadius), clockwise: false)
      ..lineTo(width, height)
      ..lineTo(0, height)
      // ..lineTo(0, heightToBottomOfNotch)
      // ..arcToPoint(leftNotchTopPoint,
      //     radius: Radius.circular(notchRadius), clockwise: false)
      // ..lineTo(0, 0);
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
