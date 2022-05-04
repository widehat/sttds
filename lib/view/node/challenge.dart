import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sttds/view/body/constants.dart';
// import 'package:sttds/utilities/feathericons.dart';
// import 'package:sttds/utilities/canvasbutton.dart';

class ChallengeDialogBox extends StatefulWidget {
  const ChallengeDialogBox({
    Key? key,
    required this.nodePath,
    required this.nodeTitle,
    required this.nodeData,
    required this.showData,
  }) : super(key: key);

  final String nodeData;
  final String nodePath;
  final String nodeTitle;
  final bool showData;

  @override
  _ChallengeDialogBoxState createState() => _ChallengeDialogBoxState();
}

class _ChallengeDialogBoxState extends State<ChallengeDialogBox> {
  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Divider
  final Widget divider = SizedBox(height: 10.0);

  /// header bar height
  final double headerHeight = 48.0;

  /// Padding settings
  final double largePadding = 10.0;

  final double smallPadding = 5.0;

  /// Dialog box main contents
  Widget get dialogBody {
    return Stack(children: [
      ListView(
        shrinkWrap: true,
        children: [
          SizedBox(
            height: headerHeight,
          ),
          nodeText,
          divider,
          characterButtonSet,
        ],
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
      widget.nodeTitle,
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  // Widget get closeButton {
  //   return CanvasButton(
  //     onTap: () => Navigator.of(context).pop(),
  //     icon: FeatherIcons.x,
  //     tooltip: "Close",
  //   );
  // }

  /// TreeView Data
  Widget get nodeText {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: largePadding,
        top: 0.0,
        bottom: smallPadding,
      ),
      child: Text(
        widget.showData ? widget.nodeData : maskedData,
        style: Theme.of(context).textTheme.bodyText2,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// List of buttons one per character in nodeData
  Widget get characterButtonSet {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: dialogBorderRadius,
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(
            left: largePadding,
            right: smallPadding,
            top: largePadding,
            bottom: largePadding,
          ),
          child: Wrap(
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            runSpacing: smallPadding,
            children: widget.nodeData.codeUnits.asMap().entries.map((entry) {
              return Padding(
                  padding: EdgeInsets.only(
                    right: smallPadding,
                  ),
                  child: SimpleToggleButton(
                    buttonText: '${entry.key + 1}',
                    charNumber: entry.key + 1,
                    charText: entry.value == 32
                        ? "space"
                        : String.fromCharCode(entry.value),
                  ));
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: dialogBody,
    );
  }
}

class SimpleToggleButton extends StatefulWidget {
  SimpleToggleButton({
    Key? key,
    required this.buttonText,
    required this.charNumber,
    required this.charText,
  }) : super(key: key);

  final String buttonText;
  final int charNumber;
  final String charText;

  @override
  SimpleToggleButtonState createState() => SimpleToggleButtonState();
}

class SimpleToggleButtonState extends State<SimpleToggleButton> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        setState(() => {pressed = !pressed});
      },
      style: OutlinedButton.styleFrom(
        primary: Theme.of(context).textSelectionTheme.cursorColor,
        backgroundColor:
            pressed ? Theme.of(context).highlightColor : Colors.transparent,
        padding: EdgeInsets.zero,
        minimumSize: Size(
          48.0,
          48.0,
        ),
        side: BorderSide(
          color: Theme.of(context).accentColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 5.0,
          right: 5.0,
        ),
        child: pressed
            ? RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '${widget.charNumber} ',
                      style: Theme.of(context).textTheme.caption,
                    ),
                    TextSpan(
                      text: widget.charText,
                      style: TextStyle(
                        color: Theme.of(context).textSelectionTheme.cursorColor,
                        fontFamily:
                            Theme.of(context).textTheme.bodyText2!.fontFamily,
                        fontSize:
                            Theme.of(context).textTheme.bodyText2!.fontSize! *
                                2,
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                '${widget.charNumber}',
                style: Theme.of(context).textTheme.bodyText1,
              ),
      ),
    );
  }
}
