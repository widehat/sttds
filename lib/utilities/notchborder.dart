import 'package:flutter/material.dart';

class NotchBorder extends OutlinedBorder {
  const NotchBorder({BorderSide side = BorderSide.none}) : super(side: side);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(0);

  @override
  ShapeBorder scale(double t) => this;

  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    return NotchBorder(side: side ?? this.side);
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    const double notchRadius = 24;
    const double notchChordHalf = 17.8885;
    double heightHalved = rect.bottom / 2;
    double topOfNotchDy = rect.top + heightHalved - notchChordHalf;
    double bottomOfNotchDy = rect.top + heightHalved + notchChordHalf;
    Offset rightNotchBottomPoint = Offset(rect.right, bottomOfNotchDy);
    // Offset leftNotchTopPoint = Offset(rect.left, topOfNotchDy);

    final path = Path()
      ..moveTo(rect.left, rect.top)
      ..lineTo(rect.right, rect.top)
      ..lineTo(rect.right, topOfNotchDy)
      ..arcToPoint(rightNotchBottomPoint,
          radius: Radius.circular(notchRadius), clockwise: false)
      ..lineTo(rect.right, rect.bottom)
      ..lineTo(rect.left, rect.bottom)
      // ..lineTo(rect.left, bottomOfNotchDy)
      // ..arcToPoint(leftNotchTopPoint,
      //     radius: Radius.circular(notchRadius), clockwise: false)
      ..close();
    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (side.style) {
      case BorderStyle.none:
        break;
      case BorderStyle.solid:
        final paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = side.width
          ..color = side.color;
        canvas.drawPath(getOuterPath(rect), paint);
    }
  }
}
