import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sttds/services/searchcontroller.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/view/setting/settingshome.dart';
import 'package:sttds/viewmodel/body/datatreeviewmodel.dart';
import 'package:package_info/package_info.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({
    required this.dataTreeViewModel,
    required this.searchController,
  });

  final DataTreeViewModel dataTreeViewModel;
  final SearchController searchController;

  /// Settings singleton
  //final AppPackage get appPackage => AppPackage();

  /// Build the screen
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).bottomAppBarColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
    );
    return Drawer(
      child: SingleChildScrollView(
        child: IntrinsicHeight(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 48.0,
            ),
            child: Column(
              children: [
                DrawerHeader(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'STTDS',
                        style: Theme.of(context).textTheme.headline5,
                        textAlign: TextAlign.center,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints.expand(
                          height: 10.0,
                        ),
                      ),
                      Text(
                        'Simple Text Tree Data Store',
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(FeatherIcons.settings),
                  title: Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    showSettingDialog(context);
                  },
                ),
                ListTile(
                  leading: Icon(FeatherIcons.info),
                  title: Text('About'),
                  onTap: () async {
                    Navigator.pop(context);
                    PackageInfo packageInfo = await PackageInfo.fromPlatform();
                    showAboutDialog(
                      context: context,
                      applicationIcon: Image.asset(
                          'assets/images/sttds_logo.png',
                          scale: 4.0),
                      applicationName: packageInfo.appName.toUpperCase(),
                      applicationVersion: packageInfo.version,
                      applicationLegalese: 'Richard Harper',
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 40.0,
                          ),
                          child: Center(
                            child: SelectableText(
                              'https://widehats.weebly.com/sttds',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Spacer(),
                ListTile(
                  leading: Icon(FeatherIcons.downloadCloud),
                  title: Text('Import from clipboard'),
                  onTap: () {
                    Navigator.pop(context);
                    dataTreeViewModel.import();
                  },
                ),
                ListTile(
                  leading: Icon(FeatherIcons.cornerDownRight),
                  title: Text('Insert sample data 1'),
                  onTap: () async {
                    Navigator.pop(context);
                    dataTreeViewModel.loadSampleData1();
                  },
                ),
                ListTile(
                  leading: Icon(FeatherIcons.cornerDownRight),
                  title: Text('Insert sample data 2'),
                  onTap: () async {
                    Navigator.pop(context);
                    dataTreeViewModel.loadSampleData2();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showSettingDialog(BuildContext context) async {
    // show dialog
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return SettingsHomeDialogBox(
            dataTreeViewModel: dataTreeViewModel,
            searchController: searchController,
          );
        });
  }
}
