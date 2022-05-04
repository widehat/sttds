import 'package:flutter/material.dart';
import 'package:sttds/services/file.dart';
import 'package:sttds/services/securestorage.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/utilities/canvasbutton.dart';
import 'package:sttds/utilities/feathericons.dart';

class AuthenticateResult {
  AuthenticateResult([
    this.isAuthenticated = false,
    this.needToAuthenticate = false,
  ]);

  final bool isAuthenticated;
  final bool needToAuthenticate;
}

class AuthenticateDialogBox extends StatefulWidget {
  AuthenticateDialogBox({
    Key? key,
    required this.canShowBiometricAuthentication,
    this.cypherBytes,
    // this.errorObject,
  }) : super(key: key);

  final bool canShowBiometricAuthentication;
  final List<int>? cypherBytes;
  // final Object? errorObject;

  @override
  _AuthenticateDialogBoxState createState() => _AuthenticateDialogBoxState();
}

class _AuthenticateDialogBoxState extends State<AuthenticateDialogBox> {
  /// header bar height
  final double headerHeight = 48.0;

  /// Divider
  final Widget divider = SizedBox(height: 10.0);

  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final double largePadding = 10.0;
  final double smallPadding = 5.0;

  /// Defines form key
  final formKey = GlobalKey<FormState>();

  /// Defines if dialog is for a new node or editing an existing node
  bool isNew = false;

  /// Application settings
  AppSettings get appSettings => AppSettings();

  /// Secure Storage
  SecureStorageService get secureStorage => SecureStorageService();

  /// File handling
  FileManager get fileManager => FileManager();

  /// key validator message
  String? keyValidator;

  /// Divider
  final Widget verticalDivider = SizedBox(height: 10.0);
  final Widget horizontalDivider = SizedBox(width: 10.0);

  final String title = "Key";

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final encryptionKeyController = TextEditingController();

  // shows/hides the user entered password
  bool obscurePassword = false;

  @override
  void initState() {
    encryptionKeyController.text = "";
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    encryptionKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: dialogBody,
    );
  }

  /// Dialog box main contents
  Widget get dialogBody {
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(
          top: 58.0,
        ),
        child: ClipRRect(
          borderRadius: dialogBorderRadius,
          child: Material(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    verticalDivider,
                    encryptionKey,
                    verticalDivider,
                    // errorMessage,
                    // verticalDivider,
                  ],
                ),
              ),
            ),
          ),
        ),
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
        leading:
            widget.canShowBiometricAuthentication ? switchToBiometrics : null,
        automaticallyImplyLeading: false,
        toolbarHeight: headerHeight,
        elevation: 0.0,
        titleSpacing: widget.canShowBiometricAuthentication ? 0.0 : 20.0,
        title: heading,
        actions: [
          submitButton,
        ],
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

  Widget get switchToBiometrics {
    return Visibility(
      visible: widget.canShowBiometricAuthentication,
      child: CanvasButton(
        onTap: () => Navigator.of(context).pop(AuthenticateResult(false, true)),
        icon: // Icons.fingerprint_outlined,
            FeatherIcons.shield,
        tooltip: "Biometric Authentication",
      ),
    );
  }

  Widget get submitButton {
    return CanvasButton(
      onTap: () async {
        await checkKey();
        if (formKey.currentState!.validate()) {
          // break out of authentication loop
          // with authentication
          Navigator.of(context).pop(AuthenticateResult(true, false));
        }
      },
      icon: FeatherIcons.check,
      tooltip: "Submit",
    );
  }

  Widget get encryptionKey {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 10.0,
        bottom: 10.0,
      ),
      child: TextFormField(
        onChanged: (_) {
          if (keyValidator != null) {
            keyValidator = null;
            formKey.currentState!.validate();
          }
        },
        onFieldSubmitted: (_) async {
          await checkKey();
          if (formKey.currentState!.validate()) {
            // break out of authentication loop
            // with authentication
            Navigator.of(context).pop(AuthenticateResult(true, false));
          }
        },
        obscureText: obscurePassword,
        autocorrect: false,
        enableSuggestions: false,
        controller: encryptionKeyController,
        autofocus: true,
        textCapitalization: TextCapitalization.none,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          labelText: "Password (File Encryption Key)",
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                obscurePassword = !obscurePassword;
              });
            },
          ),
        ),
        maxLines: 1,
        validator: (value) {
          return keyValidator;
        },
      ),
    );
  }

  Future<void> checkKey() async {
    const String retryMessage = "incorrect key, please try again";
    // if the cypherBytes paramneter is null then validate by
    // comparing the entered text against the password stored in
    // secure storage.
    // If the cypherBytes paramneter is not null then it's not
    // really a validation scenario. Instead we need to verfiy the
    // entered password by using it to try to decrypt the byte list
    bool isOk = false;
    if (widget.cypherBytes == null) {
      isOk = await secureStorage.getEncryptionPassword() ==
          encryptionKeyController.text;
    } else {
      isOk = (await fileManager.decryptBytes(
              widget.cypherBytes ?? [], encryptionKeyController.text))
          .isNotEmpty;
      if (isOk) {
        // store the password insecure storage for future use
        await secureStorage.setEncryptionPassword(encryptionKeyController.text);
      }
    }
    keyValidator = isOk ? null : retryMessage;
  }
}
