import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeManager {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
      primaryColor: Color(0xff498ba7),
      primaryColorBrightness: Brightness.light,
      accentColor: Color(0xff498ba7),
      // dialogBackgroundColor: Color(0xffEEEEEE),
      bottomAppBarColor: Color(0xffEEEEEE),
      scaffoldBackgroundColor: Color(0xffffffff),
      disabledColor: Color(0xffBABABA),
      selectedRowColor: Color(0xffDBEAEF),
      dividerColor: Colors.black87,
      highlightColor: Color(0xafDBEAEF),
      splashColor: Color(0xff498ba7),
      canvasColor: Color(0xffffffff),
      shadowColor: Color(0xff666666),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 16.0,
        ),
        bodyText2: TextStyle(
          fontFamily: 'Monospace',
          fontSize: 17.0,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: Colors.orangeAccent,
        selectionHandleColor: Colors.orangeAccent,
      ),
      appBarTheme: AppBarTheme(
        color: Color(0xffEEEEEE),
        elevation: 8.0,
        actionsIconTheme: IconThemeData(
          size: 24.0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        isCollapsed: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(right: 2.0),
        suffixStyle: TextStyle(
          color: Color(0xff262626),
          fontSize: 12.0,
        ),
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        labelStyle: TextStyle(
          fontFamily: "Roboto",
          fontSize: 16.0,
          color: Color(0x88000000), // Color(0xff498ba7),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        preferBelow: false,
      ),
      buttonTheme: ButtonThemeData(
        splashColor: Color(0xff498ba7),
        textTheme: ButtonTextTheme.primary,
        minWidth: 48.0,
        height: 48.0,
        alignedDropdown: false,
        layoutBehavior: ButtonBarLayoutBehavior.constrained,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor:
            Colors.black, // Theme.of(context).textTheme.caption.color,
        fillColor: Color(0xafDBEAEF), // Theme.of(context).highlightColor,
        borderColor: Color(0xff498ba7), // Theme.of(context).accentColor,
        selectedBorderColor:
            Color(0xff498ba7), // Theme.of(context).accentColor,
        splashColor: Color(0xff498ba7), // Theme.of(context).accentColor,
      ),
      toggleableActiveColor: Color(0xff498ba7),
      cardTheme: CardTheme(
        color: Color(0xfffffffff),
        elevation: 0.0,
        margin: EdgeInsets.only(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          bottom: 1.0,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontFamily: 'Monospace',
          fontSize: 18.0,
          color: Colors.white,
        ),
        actionTextColor: Color(0xff519aba),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xffffffff),
        foregroundColor: Colors.black,
        elevation: 0.0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Color(0xff498ba7)),
          overlayColor: MaterialStateProperty.all(Color(0xffDBEAEF)),
          padding: MaterialStateProperty.all(EdgeInsets.only(
            top: 20.0,
            bottom: 20.0,
          )),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Color(0xffEEEEEE),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xff498ba7),
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      visualDensity: VisualDensity(vertical: 0.5, horizontal: 0.5),
      primaryColor: Color(0xff519aba),
      primaryColorBrightness: Brightness.dark,
      accentColor: Color(0xff519aba),
      // dialogBackgroundColor: Colors.black,
      bottomAppBarColor: Colors.black,
      scaffoldBackgroundColor: Color(0xff1e1e1e),
      disabledColor: Color(0xff545454),
      selectedRowColor: Color(0xff243d47), // Color(0xff283642),
      dividerColor: Colors.white70,
      highlightColor: Color(0x7f519aba),
      splashColor: Color(0xff519aba),
      canvasColor: Color(0xff1e1e1e),
      shadowColor: Color(0xffBBBBBB),
      textTheme: TextTheme(
        bodyText1: TextStyle(
          fontSize: 16.0,
          color: Color(0xffd8d8d8),
          fontWeight: FontWeight.w500,
        ),
        bodyText2: TextStyle(
          fontFamily: 'Monospace',
          fontSize: 18.0,
          color: Color(0xffd8d8d8),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Colors.deepOrange[800],
        selectionHandleColor: Colors.deepOrange[800],
      ),
      appBarTheme: AppBarTheme(
        color: Colors.black,
        elevation: 8.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        isCollapsed: true,
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(right: 2.0),
        suffixStyle: TextStyle(
          color: Color(0xffd8d8d8),
          fontSize: 12.0,
        ),
        hintStyle: TextStyle(
          fontStyle: FontStyle.italic,
        ),
        labelStyle: TextStyle(
          fontFamily: "Roboto",
          fontSize: 16.0,
          color: Color(0x88ffffff), // Color(0xff519aba),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        preferBelow: false,
      ),
      buttonTheme: ButtonThemeData(
        splashColor: Color(0xff519aba),
        textTheme: ButtonTextTheme.primary,
        minWidth: 48.0,
        height: 48.0,
        alignedDropdown: false,
        layoutBehavior: ButtonBarLayoutBehavior.constrained,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        padding: EdgeInsets.zero,
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
        selectedColor:
            Colors.white, // Theme.of(context).textTheme.caption.color,
        fillColor: Color(0x7f519aba), // Theme.of(context).highlightColor,
        borderColor: Color(0xff519aba), // Theme.of(context).accentColor,
        selectedBorderColor:
            Color(0xff519aba), // Theme.of(context).accentColor,
        splashColor: Color(0xff519aba), // Theme.of(context).accentColor,
      ),
      toggleableActiveColor: Color(0xff519aba),
      cardTheme: CardTheme(
        color: Color(0xff1e1e1e),
        elevation: 0.0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontFamily: 'Monospace',
          fontSize: 18.0,
          color: Colors.black,
        ),
        actionTextColor: Color(0xff498ba7),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xff1e1e1e),
        foregroundColor: Colors.white,
        elevation: 0.0,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Color(0xff519aba)),
          overlayColor: MaterialStateProperty.all(Color(0xff283642)),
          padding: MaterialStateProperty.all(EdgeInsets.only(
            top: 20.0,
            bottom: 20.0,
          )),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Color(0xff519aba),
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }
}
