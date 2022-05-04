import 'package:flutter/material.dart';
import 'package:sttds/services/searchcontroller.dart';
import 'package:sttds/services/securestorage.dart';
import 'package:sttds/utilities/canvasbutton.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/view/setting/encryptionsettings.dart';
import 'package:sttds/view/setting/phraselistsettings.dart';
import 'package:sttds/view/setting/randomtextsettings.dart';
import 'package:sttds/view/setting/searchsettings.dart';
import 'package:sttds/view/setting/authenticationsettings.dart';
import 'package:sttds/utilities/settingbutton.dart';
import 'package:sttds/viewmodel/body/datatreeviewmodel.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/utilities/appswitch.dart';

class SettingsHomeDialogBox extends StatefulWidget {
  SettingsHomeDialogBox({
    required this.dataTreeViewModel,
    required this.searchController,
  });

  final DataTreeViewModel dataTreeViewModel;
  final SearchController searchController;

  @override
  _SettingsHomeDialogBoxState createState() => _SettingsHomeDialogBoxState();
}

class _SettingsHomeDialogBoxState extends State<SettingsHomeDialogBox> {
  /// pointer to Singleton that stores the application settings
  AppSettings get appSettings => AppSettings();

  /// header bar height
  final double headerHeight = 48.0;

  /// Divider
  final Widget topPadding = SizedBox(height: 48.0);
  final Widget verticalDivider = SizedBox(height: 10.0);
  final Widget blank = SizedBox(height: 0.0);
  final Widget smallVerticalDivider = SizedBox(height: 10.0);

  /// Setting padding
  final EdgeInsets settingPadding = EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 20.0);

  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final double largePadding = 10.0;
  final double smallPadding = 5.0;

  /// Authentication
  // LocalAuthenticationService get localAuth => LocalAuthenticationService();
  SecureStorageService get localAuth => SecureStorageService();
  bool biometricsEnabled = false;

  @override
  void initState() {
    localAuth.areBiometricsAvailable().then((value) {
      setState(() => biometricsEnabled = value);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(side: BorderSide.none),
      child: dialogBody,
    );
  }

  /// Dialog box main contents
  Widget get dialogBody {
    return Stack(
      children: [
        SingleChildScrollView(
          child: IntrinsicHeight(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 20.0,
              ),
              child: Column(
                children: [
                  topPadding,
                  smallVerticalDivider,
                  encryptionSetting,
                  verticalDivider,
                  biometricsEnabled ? authenticationSetting : blank,
                  biometricsEnabled ? verticalDivider : blank,
                  maskSetting,
                  verticalDivider,
                  searchSettings,
                  verticalDivider,
                  randomStringSetting,
                  verticalDivider,
                  titlePhraseListSetting,
                  verticalDivider,
                  dataPhraseListSetting,
                  verticalDivider,
                ],
              ),
            ),
          ),
        ),
        topBanner,
      ],
    );
  }

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
      ),
    );
  }

  Widget get heading {
    return Text(
      "Settings",
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget get closeButton {
    return CanvasButton(
      onTap: () => Navigator.of(context).pop(),
      icon: FeatherIcons.x,
      tooltip: "Close",
    );
  }

  Widget get encryptionSetting {
    return SettingButton(
      onTap: () => showEncryptionSettingDialog(),
      title: "File Encryption Key",
      subTitle: "Set, change or remove data file encryption key",
      icon: Icon(
        FeatherIcons.lock,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget get authenticationSetting {
    return SettingButton(
      onTap: () => showAuthenticationSettingDialog(),
      title: "Biometric Authentication",
      subTitle: "App authentication using biometrics",
      icon: Icon(
        // Icons.fingerprint_outlined,
        FeatherIcons.shield,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget get maskSetting {
    return ClipRRect(
      borderRadius: dialogBorderRadius,
      child: Material(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 20.0,
              ),
              child: Icon(
                FeatherIcons.eyeOff,
                color: Theme.of(context).accentColor,
              ),
            ),
            Expanded(
              child: SettingSwitch(
                onChanged: (onOff) {
                  appSettings.maskValues = onOff;
                  widget.dataTreeViewModel.resetWidths();
                  widget.dataTreeViewModel.setTreeViewWidth();
                },
                initialValue: appSettings.maskValues,
                label: "Mask Setting Default",
                onValue: "Hide data values",
                offValue: "Show data values",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget get searchSettings {
    return SettingButton(
      onTap: () => showSearchSettingDialog(),
      title: "Search Settings",
      subTitle: "Match case, include title, data value and notes fields.",
      icon: Icon(
        FeatherIcons.search,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget get randomStringSetting {
    return SettingButton(
      onTap: () => showRandomTextSettingDialog(),
      title: "Random String Settings",
      subTitle:
          "Sets of characters for Upper Case, Lower Case, Digits and Special.",
      // "\nThe mechanism is not smart. It simply adds together all the categories you select and then randomly selects items from the super set until the it has enough characters. So, even if you've requested digits in the reulty it may not select one initially.",
      icon: Icon(
        // Icons.lightbulb_outline,
        FeatherIcons.hash,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget get titlePhraseListSetting {
    return SettingButton(
      onTap: () => showTitlePhraseListSettingDialog(),
      title: "Title Phrase List",
      subTitle: "List of frequently used words or phrases for the title.",
      icon: Icon(
        FeatherIcons.list,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget get dataPhraseListSetting {
    return SettingButton(
      onTap: () => showDataValuePhraseListSettingDialog(),
      title: "Data Value Phrase List",
      subTitle: "List of frequently used words or phrases for the data value.",
      icon: Icon(
        FeatherIcons.list,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Future<void> showEncryptionSettingDialog() async {
    // show dialog
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return EncryptionSettingDialogBox(
            dataTreeViewModel: widget.dataTreeViewModel,
          );
        });
  }

  Future<void> showAuthenticationSettingDialog() async {
    // show dialog
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AuthenticationSettingsDialogBox();
        });
  }

  Future<void> showSearchSettingDialog() async {
    // show dialog
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SearchSettingsDialogBox(
            searchController: widget.searchController,
          );
        });
  }

  Future<void> showRandomTextSettingDialog() async {
    // show dialog
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return RandomTextSettingsDialogBox();
        });
  }

  Future<void> showTitlePhraseListSettingDialog() async {
    // show dialog
    return showDialog<List<String>>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PhraseListSettingsDialogBox(
            title: "Title Phrases",
            phrases: appSettings.titleShortcutList,
          );
        }).then((newList) {
      if (newList == null || newList.isEmpty) return;
      appSettings.titleShortcutList = newList;
    });
  }

  Future<void> showDataValuePhraseListSettingDialog() async {
    // show dialog
    return showDialog<List<String>>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return PhraseListSettingsDialogBox(
            title: "Data Phrases",
            phrases: appSettings.dataShortcutList,
          );
        }).then((newList) {
      if (newList == null || newList.isEmpty) return;
      appSettings.dataShortcutList = newList;
    });
  }
}
