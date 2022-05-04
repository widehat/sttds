import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/utilities/canvasbutton.dart';
import 'package:sttds/services/settings.dart';

class RandomTextSettingsDialogBox extends StatefulWidget {
  const RandomTextSettingsDialogBox();

  @override
  _RandomTextSettingsDialogBoxState createState() =>
      _RandomTextSettingsDialogBoxState();
}

class _RandomTextSettingsDialogBoxState
    extends State<RandomTextSettingsDialogBox> {
  /// header bar height
  final double headerHeight = 48.0;

  /// Divider
  final Widget verticalDivider = SizedBox(height: 10.0);
  final Widget horizontalDivider = SizedBox(width: 10.0);

  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final double smallPadding = 5.0;
  final double largePadding = 10.0;
  final double veryLargePadding = 20.0;

  AppSettings get appSettings => AppSettings();

  final String title = "Random Text Settings";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final TextEditingController upperCaseFieldController =
      TextEditingController();
  final TextEditingController lowerCaseFieldController =
      TextEditingController();
  final TextEditingController digitFieldController = TextEditingController();
  final TextEditingController specialCharFieldController =
      TextEditingController();
  final FocusNode upperCaseFocusNode = FocusNode();
  final FocusNode lowerCaseFocusNode = FocusNode();
  final FocusNode digitFocusNode = FocusNode();
  final FocusNode specialFocusNode = FocusNode();

  @override
  void initState() {
    // Initialise the TextFields
    upperCaseFieldController.text = appSettings.upperCaseCharSet;
    lowerCaseFieldController.text = appSettings.lowerCaseCharSet;
    digitFieldController.text = appSettings.digitCharSet;
    specialCharFieldController.text = appSettings.specialCharSet;

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    upperCaseFieldController.dispose();
    lowerCaseFieldController.dispose();
    digitFieldController.dispose();
    specialCharFieldController.dispose();
    upperCaseFocusNode.dispose();
    lowerCaseFocusNode.dispose();
    digitFocusNode.dispose();
    specialFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: dialogBody,
    );
  }

  /// Dialog box main contents
  Widget get dialogBody {
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(
          top: 58.0,
        ),
        child: ClipRRect(
          borderRadius: dialogBorderRadius,
          child: Material(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  verticalDivider,
                  upperCaseString,
                  verticalDivider,
                  lowerCaseString,
                  verticalDivider,
                  digitString,
                  verticalDivider,
                  spacialCharString,
                  verticalDivider,
                ],
              ),
            ),
          ),
        ),
      ),
      topBanner,
    ]);
  }

  /// Top banner. Comprises a title (left aligned) and a close button (right Aligned)
  Widget get topBanner {
    return SizedBox(
      height: headerHeight,
      child: AppBar(
        primary: false,
        leading: closeButton,
        toolbarHeight: headerHeight,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: heading,
        actions: [
          submitButton,
        ],
      ),
    );
  }

  Widget get heading {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget get closeButton {
    return CanvasButton(
      onTap: () => Navigator.of(context).pop(),
      icon: FeatherIcons.x,
      tooltip: "Cancel",
    );
  }

  Widget get submitButton {
    return CanvasButton(
      onTap: () => doSave(),
      icon: FeatherIcons.check,
      tooltip: "Save",
    );
  }

  Widget get upperCaseString {
    return Padding(
      padding: EdgeInsets.only(
        left: veryLargePadding,
        right: largePadding,
        top: largePadding,
        bottom: largePadding,
      ),
      child: TextField(
        onSubmitted: (_) => lowerCaseFocusNode.requestFocus(),
        autocorrect: false,
        enableSuggestions: false,
        controller: upperCaseFieldController,
        autofocus: true,
        focusNode: upperCaseFocusNode,
        textCapitalization: TextCapitalization.characters,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          labelText: "Upper case characters",
        ),
        maxLines: 1,
        scrollPadding: const EdgeInsets.all(20.0),
        // focusNode: ,
        // decoration = const InputDecoration(): ,
        // TextInputType keyboardType: ,
        // textInputAction: ,
        // textCapitalization = TextCapitalization.none: ,
        // style: ,
        // strutStyle: ,
        // textAlign = TextAlign.start: ,
        // textAlignVertical: ,
        // textDirection: ,
        // readOnly = false: ,
        // ToolbarOptions toolbarOptions: ,
        // showCursor: ,
        // autofocus = false: ,
        // obscuringCharacter = '•': ,
        // obscureText = false: ,
        // SmartDashesType smartDashesType: ,
        // SmartQuotesType smartQuotesType: ,
        // enableSuggestions = true: ,
        // maxLines = 1: ,
        // minLines: ,
        // expands = false: ,
        // maxLength: ,
        // maxLengthEnforced = true: ,
        // onChanged: ,
        // onEditingComplete: ,
        // onSubmitted: ,
        // onAppPrivateCommand: ,
        // inputFormatters: ,
        // enabled: ,
        // cursorWidth = 2.0: ,
        // cursorHeight: ,
        // cursorRadius: ,
        // cursorColor: ,
        // selectionHeightStyle = ui.BoxHeightStyle.tight: ,
        // selectionWidthStyle = ui.BoxWidthStyle.tight: ,
        // keyboardAppearance: ,
        // scrollPadding = const EdgeInsets.all(20.0): ,
        // dragStartBehavior = DragStartBehavior.start: ,
        // enableInteractiveSelection = true: ,
        // onTap: ,
        // mouseCursor: ,
        // buildCounter: ,
        // scrollController: ,
        // scrollPhysics: ,
        // autofillHints: ,
      ),
    );
  }

  Widget get lowerCaseString {
    return Padding(
      padding: EdgeInsets.only(
        left: veryLargePadding,
        right: largePadding,
        top: largePadding,
        bottom: largePadding,
      ),
      child: TextField(
        onSubmitted: (_) => digitFocusNode.requestFocus(),
        autocorrect: false,
        enableSuggestions: false,
        controller: lowerCaseFieldController,
        autofocus: false,
        focusNode: lowerCaseFocusNode,
        textCapitalization: TextCapitalization.none,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          labelText: "Lower case characters",
        ),
        maxLines: 1,
        scrollPadding: const EdgeInsets.all(20.0),
      ),
    );
  }

  Widget get digitString {
    return Padding(
      padding: EdgeInsets.only(
        left: veryLargePadding,
        right: largePadding,
        top: largePadding,
        bottom: largePadding,
      ),
      child: TextField(
        onSubmitted: (_) => specialFocusNode.requestFocus(),
        autocorrect: false,
        enableSuggestions: false,
        controller: digitFieldController,
        autofocus: false,
        focusNode: digitFocusNode,
        textCapitalization: TextCapitalization.characters,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          labelText: "Digits",
        ),
        maxLines: 1,
        scrollPadding: const EdgeInsets.all(20.0),
      ),
    );
  }

  Widget get spacialCharString {
    return Padding(
      padding: EdgeInsets.only(
        left: veryLargePadding,
        right: largePadding,
        top: largePadding,
        bottom: largePadding,
      ),
      child: TextField(
        onSubmitted: (_) => upperCaseFocusNode.requestFocus(),
        autocorrect: false,
        enableSuggestions: false,
        controller: specialCharFieldController,
        autofocus: false,
        focusNode: specialFocusNode,
        textCapitalization: TextCapitalization.characters,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          labelText: "Special characters",
        ),
        maxLines: 1,
        scrollPadding: const EdgeInsets.all(20.0),
      ),
    );
  }

  void doSave() {
    // Capture changes made to the charsets.
    appSettings.upperCaseCharSet = upperCaseFieldController.text;
    appSettings.lowerCaseCharSet = lowerCaseFieldController.text;
    appSettings.digitCharSet = digitFieldController.text;
    appSettings.specialCharSet = specialCharFieldController.text;
    Navigator.of(context).pop();
  }
}
