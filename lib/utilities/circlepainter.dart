import 'package:flutter/material.dart';

/// Draws a circle if placed into a square widget.
class CirclePainter extends CustomPainter {
  CirclePainter({
    required this.color,
    required this.diameter,
  });

  final Color color;
  final double diameter;

  late final _paint = Paint()
    ..color = color
    ..strokeWidth = 1
    // Use [PaintingStyle.fill] if you want the circle to be filled, PaintingStyle.stroke for an empty circle
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(
        -8,
        24 - (diameter / 2),
        diameter,
        diameter,
      ),
      _paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
