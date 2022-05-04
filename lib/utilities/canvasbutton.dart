import 'package:flutter/material.dart';

class CanvasButton extends StatelessWidget {
  CanvasButton({
    required this.onTap,
    this.onLongPress,
    this.tooltip = "",
    this.boxHeightWidth = 48.0,
    this.alignment = Alignment.center,
    required this.icon,
    this.color,
    this.backgroundColor = Colors.transparent,
    this.backgroundShape,
    this.iconSize = 24.0,
  });

  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final String tooltip;
  final double boxHeightWidth;
  final AlignmentGeometry alignment;
  final IconData icon;
  final Color? color;
  final Color backgroundColor;
  final ShapeBorder? backgroundShape;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (tooltip.isEmpty) return button;
    return Tooltip(message: tooltip, child: button);
  }

  Widget get button {
    return SizedBox(
      width: boxHeightWidth,
      height: boxHeightWidth,
      child: Material(
        shape: backgroundShape,
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Align(
            alignment: alignment,
            child: Icon(
              icon,
              color: color,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
