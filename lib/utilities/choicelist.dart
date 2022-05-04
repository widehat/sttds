import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// class for the return value
class ChoiceListItem {
  ChoiceListItem([
    this.displayText = "",
    this.id = -1,
  ]);

  String displayText;
  int id;
}

typedef ListItemClicked = void Function(ChoiceListItem listItem);

class ChoiceList extends StatefulWidget {
  const ChoiceList({
    required this.predefinedChoiceList,
    this.onPressed,
  });

  final List<ChoiceListItem> predefinedChoiceList;
  final ListItemClicked? onPressed;

  @override
  _ChoiceListState createState() => _ChoiceListState();
}

class _ChoiceListState extends State<ChoiceList> {
  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final double largePadding = 10.0;
  final double smallPadding = 2.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: dialogBorderRadius,
      ),
      child: Column(
        children: widget.predefinedChoiceList
            .asMap()
            .entries
            .map((MapEntry<int, ChoiceListItem> entry) {
          return InkWell(
            onTap: () {
              if (widget.onPressed == null) {
                Navigator.of(context).pop(entry.value);
              } else {
                widget.onPressed!(entry.value);
              }
            },
            splashColor: Theme.of(context).accentColor,
            child: Container(
              constraints: BoxConstraints(
                minHeight: 48.0,
              ),
              padding: EdgeInsets.only(
                left: 20.0,
                right: 10.0,
              ),
              decoration: entry.key == 0
                  ? null
                  : BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 0,
                        ),
                      ),
                    ),
              alignment: Alignment.centerLeft,
              child: textButton(entry.value, entry.key),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget textButton(ChoiceListItem entry, int index) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
      ),
      child: Text(
        entry.displayText,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).popupMenuTheme.textStyle,
      ),
    );
  }
}
