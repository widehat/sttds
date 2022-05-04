import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sttds/services/searchcontroller.dart';
// import 'package:sttds/utilities/feathericons.dart';
// import 'package:sttds/utilities/canvasbutton.dart';
import 'package:sttds/utilities/appswitch.dart';
import 'package:sttds/services/settings.dart';

class SearchSettingsDialogBox extends StatefulWidget {
  const SearchSettingsDialogBox({
    required this.searchController,
  });

  final SearchController searchController;

  @override
  _SearchSettingsDialogBoxState createState() =>
      _SearchSettingsDialogBoxState();
}

class _SearchSettingsDialogBoxState extends State<SearchSettingsDialogBox> {
  /// header bar height
  final double headerHeight = 48.0;

  /// Divider
  final Widget topPadding = SizedBox(height: 48.0);
  final Widget verticalDivider = SizedBox(height: 10.0);
  final Widget horizontalDivider = SizedBox(width: 10.0);

  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final double largePadding = 10.0;
  final double smallPadding = 5.0;

  AppSettings get appSettings => AppSettings();

  final String title = "Search Settings";

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
        Container(
          margin: EdgeInsets.only(
            top: 58.0,
          ),
          child: ClipRRect(
            borderRadius: dialogBorderRadius,
            child: Material(
              child: SingleChildScrollView(
                child: Column(
                  // shrinkWrap: true,
                  children: [
                    SettingSwitch(
                      onChanged: (onOff) {
                        appSettings.caseSensitive = onOff;
                        widget.searchController.setSearchResults(null, null);
                      },
                      initialValue: appSettings.caseSensitive,
                      label: "Case Sensitive",
                      onValue: "Match on case",
                      offValue: "Ignore case",
                    ),
                    SettingSwitch(
                      onChanged: (onOff) {
                        appSettings.searchTitle = onOff;
                        widget.searchController.setSearchResults(null, null);
                      },
                      initialValue: appSettings.searchTitle,
                      label: "Title",
                      onValue: "Search titles",
                      offValue: "Exclude titles when searching",
                    ),
                    SettingSwitch(
                      onChanged: (onOff) {
                        appSettings.searchData = onOff;
                        widget.searchController.setSearchResults(null, null);
                      },
                      initialValue: appSettings.searchData,
                      label: "Data value",
                      onValue: "Searrch data values",
                      offValue: "Exclude data values when searching",
                    ),
                    SettingSwitch(
                      onChanged: (onOff) {
                        appSettings.searchNote = onOff;
                        widget.searchController.setSearchResults(null, null);
                      },
                      initialValue: appSettings.searchNote,
                      label: "Note",
                      onValue: "Search notes",
                      offValue: "Exclude notes when searching",
                    ),
                  ],
                ),
              ),
            ),
          ),
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
