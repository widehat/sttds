import 'package:flutter/material.dart';

class AppButtonOption {
  AppButtonOption({
    required this.icon,
    this.tooltip = "",
    this.text = "",
  });

  /// Defines image to display for the button
  final Widget icon;

  /// Defines any Text to display on the toggle button
  final String text;

  /// Defines a tooltip to display if user performs a tap and hold
  final String tooltip;
}
