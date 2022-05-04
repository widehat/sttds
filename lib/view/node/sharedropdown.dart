import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:sttds/utilities/feathericons.dart';
// import 'package:sttds/utilities/canvasbutton.dart';
import 'package:sttds/utilities/choicelist.dart';

class ShareDropdownDialogBox extends StatefulWidget {
  const ShareDropdownDialogBox({
    Key? key,
    required this.shareChoiceList,
  }) : super(key: key);

  final List<ChoiceListItem> shareChoiceList;

  @override
  _ShareDropdownDialogBoxState createState() => _ShareDropdownDialogBoxState();
}

class _ShareDropdownDialogBoxState extends State<ShareDropdownDialogBox> {
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

  final String title = "Share";

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: dialogBody,
    );
  }

  /// Dialog box main contents
  Widget get dialogBody {
    return Stack(
      children: [
        ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: headerHeight,
            ),
            verticalDivider,
            ChoiceList(
              predefinedChoiceList: widget.shareChoiceList,
            ),
          ],
        ),
        topBanner,
      ],
    );
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
  //     tooltip: "Close",
  //   );
  // }
}
