import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/utilities/choicelist.dart';
import 'package:sttds/viewmodel/body/datatreeviewmodel.dart';
import 'package:sttds/services/securestorage.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/utilities/canvasbutton.dart';

class EncryptionSettingDialogBox extends StatefulWidget {
  const EncryptionSettingDialogBox({
    required this.dataTreeViewModel,
  });

  final DataTreeViewModel dataTreeViewModel;

  @override
  _EncryptionSettingDialogBoxState createState() =>
      _EncryptionSettingDialogBoxState();
}

class _EncryptionSettingDialogBoxState
    extends State<EncryptionSettingDialogBox> {
  /// header bar height
  final double headerHeight = 48.0;

  /// Divider
  final Widget topPadding = SizedBox(height: 48.0);
  final Widget horizontalDivider = SizedBox(width: 10.0);
  final Widget verticalDivider = SizedBox(height: 15.0);
  final Widget smallVerticalDivider = SizedBox(height: 8.0);

  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final double veryLargePadding = 20.0;
  final double largePadding = 10.0;
  final double smallPadding = 5.0;

  /// Application settings
  AppSettings get appSettings => AppSettings();

  /// Secure Storage
  SecureStorageService get secureStorage => SecureStorageService();

  /// page title
  final String title = "Encryption key";

  /// Choice List
  List<ChoiceListItem> choiceList = [];
  ChoiceListItem busy = ChoiceListItem("Please wait...", 0);
  ChoiceListItem setKey = ChoiceListItem("Set a Data File Encryption Key", 1);
  ChoiceListItem changeKey = ChoiceListItem("Change Encryption Key", 2);
  ChoiceListItem clearKey = ChoiceListItem("Remove Encryption Key", 3);

  /// error text
  String _errorText = "";
  String get errorText => _errorText;
  set errorText(newText) {
    if (newText != _errorText) {
      setState(() => _errorText = newText);
    }
  }

  /// Widgets
  List<Widget> bodyWidgetList = [];
  int level = 0;

  /// encryption status
  bool hasUserDefinedPassKey = false;
  bool clearPassKey = false;

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final TextEditingController currentKeyController = TextEditingController();
  final TextEditingController newKeyController = TextEditingController();
  final FocusNode currentKeyFocusNode = FocusNode();
  final FocusNode newKeyFocusNode = FocusNode();

  void updateDisplay() {
    _errorText = "";
    if (level == 0 && hasUserDefinedPassKey == true) {
      choiceList = [changeKey, clearKey];
      setState(() => bodyWidgetList = [showChoices]);
    } else if (level == 0 && hasUserDefinedPassKey == false) {
      choiceList = [setKey];
      setState(() => bodyWidgetList = [showChoices]);
    } else if (level == 1 && hasUserDefinedPassKey == false) {
      // user is requesting to specify a Pass Key
      setState(() => bodyWidgetList = [
            verticalDivider,
            newKeyString,
            verticalDivider,
          ]);
    } else if (level == 1 &&
        hasUserDefinedPassKey == true &&
        clearPassKey == true) {
      // user is requesting to clear an existing user defined Pass Key
      setState(() => bodyWidgetList = [
            verticalDivider,
            currentKeyString,
            verticalDivider,
          ]);
    } else if (level == 1 &&
        hasUserDefinedPassKey == true &&
        clearPassKey == false) {
      // user is requesting to change an existing user defined Pass Key
      setState(() => bodyWidgetList = [
            verticalDivider,
            currentKeyString,
            smallVerticalDivider,
            Divider(),
            verticalDivider,
            newKeyString,
            verticalDivider,
          ]);
    }
  } //O0oLl1iIwWvVjJkK

  @override
  void initState() {
    newKeyController.text = "";
    secureStorage.getEncryptionPassword().then((value) {
      hasUserDefinedPassKey = (value != appSettings.defaultPassword);
      currentKeyController.text =
          hasUserDefinedPassKey ? "" : appSettings.defaultPassword;
      updateDisplay();
    });
    bodyWidgetList = [
      verticalDivider,
      processing,
      verticalDivider,
    ];
    super.initState();
  }

  @override
  void dispose() {
    currentKeyController.dispose();
    newKeyController.dispose();
    currentKeyFocusNode.dispose();
    newKeyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
        child: dialogBody,
      ),
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
            body,
            errorMessage,
          ],
        ),
        topBanner,
      ],
    );
  }

  Widget get body {
    return ClipRRect(
      borderRadius: dialogBorderRadius,
      child: Material(
        child: SingleChildScrollView(
          child: Column(
            children: bodyWidgetList,
          ),
        ),
      ),
    );
  }

  Widget get comment {
    return ClipRRect(
      borderRadius: dialogBorderRadius,
      child: Material(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.0,
              right: 20.0,
            ),
            child: Text(
              "The Encryption Key is used to encrypt your data file. If you are not using biometric authentication, eg finger print or face recognition, or if the device's biometric tools are not working, then you will have to sign in using this password.",
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ),
      ),
    );
  }

  Widget get currentKeyString {
    return Padding(
      padding: EdgeInsets.only(
        left: veryLargePadding,
        right: largePadding,
      ),
      child: TextField(
        onChanged: (_) => errorText = "",
        onSubmitted: (_) {
          if (clearPassKey == false) {
            newKeyFocusNode.requestFocus();
          } else {
            doSave();
          }
        },
        autocorrect: false,
        enableSuggestions: false,
        controller: currentKeyController,
        autofocus: true,
        focusNode: currentKeyFocusNode,
        textCapitalization: TextCapitalization.none,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          labelText: "CURRENT ENCRYPTION KEY",
        ),
        maxLines: 1,
        scrollPadding: const EdgeInsets.all(20.0),
      ),
    );
  }

  Widget get newKeyString {
    return Padding(
      padding: EdgeInsets.only(
        left: veryLargePadding,
        right: largePadding,
      ),
      child: TextField(
        onChanged: (_) => errorText = "",
        onSubmitted: (_) {
          if (hasUserDefinedPassKey == true) {
            currentKeyFocusNode.requestFocus();
          } else {
            doSave();
          }
        },
        autocorrect: false,
        focusNode: newKeyFocusNode,
        enableSuggestions: false,
        controller: newKeyController,
        autofocus: true,
        textCapitalization: TextCapitalization.none,
        style: Theme.of(context).textTheme.bodyText2,
        decoration: InputDecoration(
          labelText: "NEW ENCRYPTION KEY",
        ),
        maxLines: 1,
        scrollPadding: const EdgeInsets.all(20.0),
      ),
    );
  }

  Widget get errorMessage {
    return Visibility(
      visible: errorText.isNotEmpty,
      child: Padding(
        padding: EdgeInsets.all(veryLargePadding),
        child: Text(
          errorText,
        ),
      ),
    );
  }

  /// Top banner. Comprises a Back button and a title heading
  Widget get topBanner {
    return SizedBox(
      height: headerHeight,
      child: AppBar(
        primary: false,
        leading: closeButton,
        toolbarHeight: headerHeight,
        elevation: 0.0,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
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

  Widget get closeButton {
    return CanvasButton(
      onTap: () {
        if (level == 0) {
          Navigator.of(context).pop();
        } else {
          level = 0;
          updateDisplay();
        }
      },
      icon: level == 0 ? FeatherIcons.arrowLeft : FeatherIcons.x,
      tooltip: level == 0 ? "Back" : "Cancel",
    );
  }

  Widget get submitButton {
    return Visibility(
      visible: level == 1,
      child: CanvasButton(
        onTap: () => doSave(),
        icon: FeatherIcons.check,
        tooltip: "Save",
      ),
    );
  }

  Widget get processing {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget get showChoices {
    return ChoiceList(
      predefinedChoiceList: choiceList,
      onPressed: (ChoiceListItem choice) => processChoice(choice),
    );
  }

  void processChoice(ChoiceListItem choice) {
    switch (choice.id) {
      case 0:
        {
          // this is the waiting message
        }
        break;
      case 1:
        {
          level = 1;
          updateDisplay();
        }
        break;
      case 2:
        {
          level = 1;
          clearPassKey = false;
          updateDisplay();
        }
        break;
      case 3:
        {
          level = 1;
          clearPassKey = true;
          updateDisplay();
        }
        break;
      default:
        {}
        break;
    }
  }

  Future<void> doSave() async {
    // if changing or removing existing password first
    // check that entered password matches saved password
    if (hasUserDefinedPassKey) {
      String password = await secureStorage.getEncryptionPassword();
      if (password != currentKeyController.text) {
        errorText =
            'The current key does not match the value entered\n\nPlease re-enter';
        return;
      }
    }
    String newPassword = "";
    // if clearing the password reset the actual password to be the default
    if (clearPassKey) {
      newPassword = appSettings.defaultPassword;
    } else {
      // otherwise, if setting or changing password, check that it's not empty
      if (newKeyController.text.isEmpty) {
        errorText = 'The new key can not be blank';
        return;
      } else {
        newPassword = newKeyController.text;
      }
    }
    // update secure storage password
    await secureStorage.setEncryptionPassword(newPassword);
    // save data immediately using the new password
    await widget.dataTreeViewModel.save();
    // leave page
    Navigator.of(context).pop();
  }
}
