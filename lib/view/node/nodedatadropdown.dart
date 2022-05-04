import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sttds/utilities/feathericons.dart';
// import 'package:sttds/utilities/canvasbutton.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/utilities/choicelist.dart';
import 'package:sttds/utilities/appbuttonoption.dart';

/// This enumeration is for the action item buttons
enum RandomStringChoice {
  digit,
  upperCase,
  lowerCase,
  special,
}

class RandomToggleButtonOption extends AppButtonOption {
  RandomToggleButtonOption({
    required this.type,
    required this.charSet,
    required this.selected,
    required Widget icon,
    required String tooltip,
    required String text,
  }) : super(icon: icon, tooltip: tooltip, text: text);

  /// Enumeration value that identifies the button pressed when
  /// user clicks on a button
  final RandomStringChoice type;
  final String charSet;
  bool selected;
}

class NodeDataDropdownDialogBox extends StatefulWidget {
  const NodeDataDropdownDialogBox({
    Key? key,
    this.dialogTitle = "",
    this.randomOption = false,
    this.predefinedChoiceList = const [],
  }) : super(key: key);

  final String dialogTitle;
  final bool randomOption;
  final List<ChoiceListItem> predefinedChoiceList;

  @override
  _NodeDataDropdownDialogBoxState createState() =>
      _NodeDataDropdownDialogBoxState();
}

class _NodeDataDropdownDialogBoxState extends State<NodeDataDropdownDialogBox> {
  /// App Settings singleton;
  AppSettings get appSettings => AppSettings();

  /// header bar height
  final double headerHeight = 48.0;

  /// Divider
  final Widget verticalDivider = SizedBox(height: 10.0);
  final Widget horizontalDivider = SizedBox(width: 10.0);

  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final double largePadding = 10.0;
  final double smallPadding = 5.0;

  /// List to identifdy which toggle button has exclusive selection
  List<bool> isSelected = [];
  List<bool> isLengthSelected = [false, false, false];

  /// Length of random text
  int get randomStringLength => appSettings.randomLength;
  set randomStringLength(int newLength) => appSettings.randomLength = newLength;

  /// EasyReadCharactersv
  bool easyReadCharacterts = false;

  /// List of option style buttons
  /// The order of this list defines the order
  /// that the buttons are displayed
  List<RandomToggleButtonOption> optionButtonList = [];

  /// This is the list of choices the user can make,
  /// it's a combination of the random string generated
  /// by the random opotions and a predefined string
  List<ChoiceListItem> choiceList = [ChoiceListItem()];

  final String title = "Data value";

  dynamic toggleButtonStyle = TextStyle();

  @override
  void initState() {
    optionButtonList = [
      RandomToggleButtonOption(
        type: RandomStringChoice.lowerCase,
        charSet: appSettings.lowerCaseCharSet,
        selected: appSettings.includeLowerCase,
        icon: SizedBox(
          width: 48.0,
          child: Center(
            child: Text(
              "abc",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.2,
              style: toggleButtonStyle,
            ),
          ),
        ),
        tooltip: "Include lower case characters",
        text: "lower",
      ),
      RandomToggleButtonOption(
        type: RandomStringChoice.upperCase,
        charSet: appSettings.upperCaseCharSet,
        selected: appSettings.includeUpperCase,
        icon: SizedBox(
          width: 48.0,
          child: Center(
            child: Text(
              "ABC",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.2,
              style: toggleButtonStyle,
            ),
          ),
        ),
        tooltip: "Include upper case characters",
        text: "upper",
      ),
      RandomToggleButtonOption(
        type: RandomStringChoice.digit,
        charSet: appSettings.digitCharSet,
        selected: appSettings.includeDigit,
        icon: SizedBox(
          width: 48.0,
          child: Center(
            child: Text(
              "123",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.2,
              style: toggleButtonStyle,
            ),
          ),
        ),
        tooltip: "Include digits",
        text: "digit",
      ),
      RandomToggleButtonOption(
        type: RandomStringChoice.special,
        charSet: appSettings.specialCharSet,
        selected: appSettings.includeSpecial,
        icon: SizedBox(
          width: 48.0,
          child: Center(
            child: Text(
              "[*!",
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.2,
              style: toggleButtonStyle,
            ),
          ),
        ),
        tooltip: "Include special characters",
        text: "special",
      ),
    ];

    for (int i = 0; i < optionButtonList.length; i++) {
      isSelected.add(optionButtonList[i].selected);
    }
    // append the predefined list to the random list member
    choiceList[0].displayText = newRandomTextString();
    choiceList.addAll(widget.predefinedChoiceList);

    // randomTextString = newRandomTextString();

    super.initState();
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
      ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: headerHeight,
          ),
          randomNumberGroup,
          verticalDivider,
          ChoiceList(
            predefinedChoiceList: choiceList,
          ),
        ],
      ),
      topBanner,
    ]);
  }

  Widget get topBanner {
    return SizedBox(
      height: headerHeight,
      child: AppBar(
        primary: false,
        // leading: closeButton,
        toolbarHeight: headerHeight,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: heading,
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

  // Widget get closeButton {
  //   return CanvasButton(
  //     onTap: () => Navigator.of(context).pop(),
  //     icon: FeatherIcons.x,
  //     tooltip: "Cancel",
  //   );
  // }

  Widget get randomNumberGroup {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: dialogBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: largePadding,
          bottom: largePadding,
        ),
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: largePadding * 4,
          runSpacing: largePadding,
          children: [
            randomOptions,
            randomTextLength,
          ],
        ),
      ),
    );
  }

  Widget get randomOptions {
    toggleButtonStyle = TextStyle(
      fontFamily: Theme.of(context).textTheme.bodyText2?.fontFamily,
      fontSize: Theme.of(context).textTheme.bodyText2?.fontSize,
      fontWeight: FontWeight.w500,
    );
    return ToggleButtons(
      onPressed: (int index) => selectOption(index),
      borderRadius: dialogBorderRadius,
      isSelected: isSelected,
      children: [
        Tooltip(
          message: optionButtonList[0].tooltip,
          child: optionButtonList[0].icon,
        ),
        Tooltip(
          message: optionButtonList[1].tooltip,
          child: optionButtonList[1].icon,
        ),
        Tooltip(
          message: optionButtonList[2].tooltip,
          child: optionButtonList[2].icon,
        ),
        Tooltip(
          message: optionButtonList[3].tooltip,
          child: optionButtonList[3].icon,
        ),
      ],
    );
  }

  Widget get randomTextLength {
    return ToggleButtons(
        color: Theme.of(context).accentColor,
        onPressed: (int index) async {
          randomStringLength = randomStringLength - 1 + index;
          await update();
        },
        isSelected: isLengthSelected,
        children: [
          Tooltip(
            message: "Reduce length by one",
            child: Icon(FeatherIcons.minus),
          ),
          Tooltip(
            message: "Refresh random text",
            child: SizedBox(
              width: 48.0,
              child: Center(
                child: Text(
                  "$randomStringLength",
                  style: TextStyle(
                    fontFamily:
                        Theme.of(context).textTheme.bodyText2!.fontFamily,
                    fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  textScaleFactor: 1.2,
                ),
              ),
            ),
          ),
          Tooltip(
            message: "Increase length by one",
            child: Icon(FeatherIcons.plus),
          ),
        ]);
  }

  Future<void> selectOption(int index) async {
    int count = 0;
    isSelected.forEach((bool val) {
      if (val) count++;
    });
    if (isSelected[index] && count < 2) return;

    isSelected[index] = !isSelected[index];
    optionButtonList[index].selected = isSelected[index];
    switch (optionButtonList[index].type) {
      case RandomStringChoice.digit:
        {
          appSettings.includeDigit = optionButtonList[index].selected;
        }
        break;
      case RandomStringChoice.upperCase:
        {
          appSettings.includeUpperCase = optionButtonList[index].selected;
        }
        break;
      case RandomStringChoice.lowerCase:
        {
          appSettings.includeLowerCase = optionButtonList[index].selected;
        }
        break;
      case RandomStringChoice.special:
        {
          appSettings.includeSpecial = optionButtonList[index].selected;
        }
        break;
      default:
        {}
        break;
    }
    await update();
  }

  String newRandomTextString() {
    String newRandomString = "";
    int startPos = 0;
    String baseText = "";
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) baseText = baseText + optionButtonList[i].charSet;
    }
    if (baseText.isEmpty) return "";
    for (int i = 0; i < randomStringLength; i++) {
      startPos = Random.secure().nextInt(baseText.length);
      newRandomString =
          newRandomString + baseText.substring(startPos, startPos + 1);
    }
    return newRandomString;
  }

  Future<void> update() async {
    setState(() {
      choiceList[0].displayText = newRandomTextString();
    });
  }
}
