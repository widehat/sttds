import 'package:flutter/material.dart';

class AppSnackBar {
  static final AppSnackBar _singleton = AppSnackBar._internal();

  factory AppSnackBar() {
    return _singleton;
  }

  AppSnackBar._internal();

  late BuildContext context;

  void showMessage(
      {required Widget content,
      SnackBarAction? action,
      int milliseconds = 4000,
      bool replaceCurrent = true}) {
    if (replaceCurrent) {
      // remove current Snackbar
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
    }

    // build new Snackbar
    final snackBar = SnackBar(
      duration: Duration(milliseconds: milliseconds),
      content: content,
      action: action,
    );

    // show Snackbar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  /// call back registered by main.dart that
  /// flashes a save icon on the scaffold
  /// in the bottom right hand corner.
  /// The same position as a FAB would appear
  VoidCallback flashSave = () {};
}
