import 'package:flutter/material.dart';
import 'package:sttds/utilities/feathericons.dart';

class MoreIconPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double bigRadius = 16;
    // const double endRadius = 8;
    // const double cornerRadius = 3;
    const double holeRadius = 2;

    final path = Path()
      // ..moveTo(8, 4)
      // ..arcToPoint(Offset(8, 20),
      //     radius: Radius.circular(endRadius), clockwise: false)
      // ..lineTo(21, 20)
      // ..arcToPoint(Offset(24, 17),
      //     radius: Radius.circular(cornerRadius), clockwise: false)
      // ..lineTo(24, 12)
      // ..lineTo(21, 12)
      // ..arcToPoint(Offset(18, 12), radius: Radius.circular(holeRadius))
      // ..lineTo(15, 12)
      // ..arcToPoint(Offset(12, 12), radius: Radius.circular(holeRadius))
      // ..lineTo(9, 12)
      // ..arcToPoint(Offset(6, 12), radius: Radius.circular(holeRadius))
      // ..arcToPoint(Offset(9, 12), radius: Radius.circular(holeRadius))
      // ..lineTo(12, 12)
      // ..arcToPoint(Offset(15, 12), radius: Radius.circular(holeRadius))
      // ..lineTo(18, 12)
      // ..arcToPoint(Offset(21, 12), radius: Radius.circular(holeRadius))
      // ..lineTo(24, 12)
      // ..lineTo(24, 7)
      // ..arcToPoint(Offset(21, 4),
      //     radius: Radius.circular(cornerRadius), clockwise: false)
      // ..close();

      // ..moveTo(24, 12)
      // ..arcToPoint(Offset(0, 12),
      //     radius: Radius.circular(bigRadius), clockwise: false)
      // ..arcToPoint(Offset(24, 12),
      //     radius: Radius.circular(bigRadius), clockwise: false)
      // ..lineTo(21, 12)
      // ..arcToPoint(Offset(17, 12), radius: Radius.circular(holeRadius))
      // ..lineTo(14, 12)
      // ..arcToPoint(Offset(10, 12), radius: Radius.circular(holeRadius))
      // ..lineTo(7, 12)
      // ..arcToPoint(Offset(3, 12), radius: Radius.circular(holeRadius))
      // ..arcToPoint(Offset(7, 12), radius: Radius.circular(holeRadius))
      // ..lineTo(10, 12)
      // ..arcToPoint(Offset(14, 12), radius: Radius.circular(holeRadius))
      // ..lineTo(17, 12)
      // ..arcToPoint(Offset(21, 12), radius: Radius.circular(holeRadius))
      // ..close();

      ..moveTo(16, 0)
      ..arcToPoint(Offset(16, 32),
          radius: Radius.circular(bigRadius), clockwise: false)
      ..arcToPoint(Offset(16, 0),
          radius: Radius.circular(bigRadius), clockwise: false)
      ..lineTo(16, 6)
      ..arcToPoint(Offset(16, 10), radius: Radius.circular(holeRadius))
      ..lineTo(16, 14)
      ..arcToPoint(Offset(16, 18), radius: Radius.circular(holeRadius))
      ..lineTo(16, 22)
      ..arcToPoint(Offset(16, 26), radius: Radius.circular(holeRadius))
      ..arcToPoint(Offset(16, 22), radius: Radius.circular(holeRadius))
      ..lineTo(16, 18)
      ..arcToPoint(Offset(16, 14), radius: Radius.circular(holeRadius))
      ..lineTo(16, 10)
      ..arcToPoint(Offset(16, 6), radius: Radius.circular(holeRadius))
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class MoreIcon extends StatelessWidget {
  MoreIcon({
    required this.foregroundColor,
    required this.backgroundColor,
    this.widthHeight = 40.0,
  });

  final Color foregroundColor;
  final Color backgroundColor;
  final double widthHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: CircleBorder(
          side: BorderSide(
        color: Theme.of(context).brightness == Brightness.dark
            ? foregroundColor
            : backgroundColor,
      )),
      color: backgroundColor,
      child: SizedBox(
        width: widthHeight,
        height: widthHeight,
        child: Icon(FeatherIcons.moreVertical, color: foregroundColor),
      ),
    );
    // return PhysicalShape(
    //   clipper: MoreIconPath(),
    //   color: color,
    //   child: const SizedBox(width: 32.0, height: 32.0),
    // );
  }
}
