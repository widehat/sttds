import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SettingSwitch extends StatefulWidget {
  SettingSwitch({
    required this.onChanged,
    required this.initialValue,
    this.label = "",
    this.onValue = "",
    this.offValue = "",
  });

  final ValueChanged<bool> onChanged;
  final bool initialValue;
  final String label;
  final String onValue;
  final String offValue;

  @override
  _SettingSwitchState createState() => _SettingSwitchState();
}

typedef ReadOnlyCallback = Function(bool);

class _SettingSwitchState extends State<SettingSwitch> {
  bool value = false;

  // Hoizontal Divider
  final Widget horizontalDivider = SizedBox(width: 10.0);

  /// Padding settings
  final double largePadding = 10.0;
  final double smallPadding = 5.0;

  @override
  void initState() {
    value = widget.initialValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => doClick(),
      child: Padding(
        padding: EdgeInsets.only(
          left: largePadding * 2,
          right: largePadding,
          top: smallPadding,
          bottom: smallPadding,
        ),
        child: Row(children: [
          switchLabel,
          horizontalDivider,
          toggleSwitch,
        ]),
      ),
    );
  }

  Widget get switchLabel {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          mainLabel,
          onOffLabel,
        ],
      ),
    );
  }

  Widget get mainLabel {
    return Text(
      widget.label,
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  Widget get onOffLabel {
    return Text(
      value ? widget.onValue : widget.offValue,
      style: TextStyle(
        fontFamily: Theme.of(context).textTheme.caption?.fontFamily,
        fontSize: Theme.of(context).textTheme.caption?.fontSize,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget get toggleSwitch {
    return Switch(
      onChanged: (isOn) => doClick(),
      value: value,
    );
  }

  void doClick() {
    setState(() => value = !value);
    widget.onChanged(value);
  }
}
