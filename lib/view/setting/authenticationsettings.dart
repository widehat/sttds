import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sttds/services/securestorage.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/utilities/appswitch.dart';

class AuthenticationSettingsDialogBox extends StatefulWidget {
  const AuthenticationSettingsDialogBox();

  @override
  _AuthenticationSettingsDialogBoxState createState() =>
      _AuthenticationSettingsDialogBoxState();
}

class _AuthenticationSettingsDialogBoxState
    extends State<AuthenticationSettingsDialogBox> {
  /// header bar height
  final double headerHeight = 48.0;

  /// Divider
  final Widget horizontalDivider = SizedBox(width: 10.0);
  final Widget verticalDivider = SizedBox(height: 15.0);
  final Widget smallVerticalDivider = SizedBox(height: 10.0);

  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final Widget topPadding = SizedBox(height: 48.0);
  final double veryLargePadding = 20.0;
  final double largePadding = 15.0;
  final double mediumPadding = 10.0;

  /// Application settings
  AppSettings get appSettings => AppSettings();

  /// Secure Storage
  SecureStorageService get secureStorage => SecureStorageService();

  // various configuration flags
  bool isUserDefinedEncryptionKey = false;
  bool biometricsAvailable = false;
  bool biometricsEnabled = false;

  final String title = "Biometric Authentication";

  Future<void> configureFlags() async {
    isUserDefinedEncryptionKey = await secureStorage.getEncryptionPassword() !=
        appSettings.defaultPassword;
    biometricsAvailable = await secureStorage.areBiometricsAvailable();
    if (biometricsAvailable) {
      biometricsEnabled = await secureStorage.areBiometricsEnabled();
    }
    setState(() {});
  }

  @override
  void initState() {
    configureFlags();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).accentColor,
            ),
          ),
          child: dialogBody),
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
                  children: [
                    notAvailable,
                    notApplicable,
                    notEnabled,
                    useAvailableBiometrics,
                    // biometricChoice,
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

  Widget get notAvailable {
    return Visibility(
      visible: biometricsAvailable == false,
      // this use case should never occur as the prior screen
      // will not offer Biometric Authentication as an option
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(veryLargePadding),
          child: Text(
            "Biometric Authentication is not available on this device.",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }

  Widget get notApplicable {
    return Visibility(
      visible:
          isUserDefinedEncryptionKey == false && biometricsAvailable == true,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(veryLargePadding),
          child: Text(
            "Biometric Authentication is available on this device. However, until you set an Encryption Key for the data file, it's not really relevant for this app .",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }

  Widget get notEnabled {
    return Visibility(
      visible: isUserDefinedEncryptionKey == true &&
          biometricsAvailable == true &&
          biometricsEnabled == false,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.all(veryLargePadding),
          child: Text(
            "Biometric Authentication is available on this device. However, it has not yet been enabled.\n\nPlease use your device's system settings to set your preferred Biometic Authentication mechanism.",
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      ),
    );
  }

  Widget get useAvailableBiometrics {
    return Visibility(
      visible: isUserDefinedEncryptionKey == true &&
          biometricsAvailable == true &&
          biometricsEnabled == true,
      child: Padding(
        padding: EdgeInsets.only(
          top: 10.0,
          bottom: 10.0,
        ),
        child: SettingSwitch(
          onChanged: (onOff) {
            appSettings.useAvailableBiometrics = onOff;
          },
          initialValue: appSettings.useAvailableBiometrics,
          label: "Use Biometrics",
          onValue:
              "Use available biometrics, eg fingerprint, for authentication",
          offValue: "Do not use biometrics for authentication",
        ),
      ),
    );
  }
}
