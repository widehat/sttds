import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SettingButton extends StatefulWidget {
  const SettingButton({
    required this.onTap,
    required this.title,
    required this.subTitle,
    required this.icon,
  });

  final VoidCallback onTap;
  final String title;
  final String subTitle;
  final Icon icon;

  @override
  _SettingButtonState createState() => _SettingButtonState();
}

class _SettingButtonState extends State<SettingButton> {
  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final EdgeInsets settingPadding = EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 20.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: dialogBorderRadius,
      child: Material(
        child: InkWell(
          onTap: widget.onTap,
          child: Padding(
            padding: settingPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: widget.icon,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        widget.subTitle,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
