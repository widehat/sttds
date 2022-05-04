import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sttds/viewmodel/body/datatreeviewmodel.dart';

class LifeCycleManager extends StatefulWidget {
  LifeCycleManager({
    Key? key,
    required this.dataTreeViewModel,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final DataTreeViewModel dataTreeViewModel;

  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      widget.dataTreeViewModel.storeExpandedNodes();
    } else if (state == AppLifecycleState.resumed) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).bottomAppBarColor,
          systemNavigationBarIconBrightness:
              Theme.of(context).brightness == Brightness.light
                  ? Brightness.dark
                  : Brightness.light,
        ),
      );
    }
  }
}
