import 'package:flutter/material.dart';
import 'package:sttds/services/securestorage.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/view/authentication/encryptionkeydialog.dart';

class AppAuthentication {
  AppAuthentication({
    required this.context,
  });

  final BuildContext context;

  /// Settings singleton
  AppSettings get appSettings => AppSettings();

  /// Secure Storage singleton
  SecureStorageService get secureStorage => SecureStorageService();

  /// Authentication control
  bool hasAuthenticated = false;
  // keepTryingToAuthenticate allows differentiation between user trying to
  // atuthenticate versus user giving up and wishing to quit the app
  // keepTryingToAuthenticate == true - user needs to authenticate so app
  //   will loop until that's achieved
  // keepTryingToAuthenticate == false - user has decided to give up
  //   authentication so the app should close
  bool keepTryingToAuthenticate = true;
  bool canShowBiometricAuthentication = false;
  Object? errorObject;

  final TextEditingController encryptionKeyController = TextEditingController();

  Future<bool> initialiseSettings() async {
    await appSettings.initialiseSharedPreferences();
    // check if there is a user defined encryption key
    String storedEncryptionKey = await secureStorage.getEncryptionPassword();

    if (storedEncryptionKey == appSettings.defaultPassword) {
      // no encryption key is stored or the secure storage file is missing
      // So, first try to decrypt using a blank key. If that fails
      // then need to prompt user for the decryption key value - this
      // step is done within the load method itself
      // So, for now only need to report that authentication is successfukl
      // ie there is no need for biometric authentication
      hasAuthenticated = true;
    } else {
      // a secure encryption key exists so the user either needs to
      // use biometric authentication, if enabled, or manually enter it.
      // determine if biometic authentication is enabled
      canShowBiometricAuthentication =
          await secureStorage.areBiometricsEnabled() &&
              appSettings.useAvailableBiometrics;
      // keep looping intil authentication is successful
      while (keepTryingToAuthenticate == true && hasAuthenticated == false) {
        // need to authenticate the user
        if (canShowBiometricAuthentication) {
          // has user requested biometric authentication AND it's enabled
          errorObject = null;
          hasAuthenticated = await secureStorage.authenticate();
        }
        if (hasAuthenticated == false) {
          // get error object
          // errorObject = localAuth.errorObject;
          // ask for manual encryption key entry
          // the manual authentication procedure sets both flags
          // ie mustAuthenticate and hasAuthenticated
          await manualauthentication();
        }
      }
    }
    return hasAuthenticated;
  }

  Future<void> manualauthentication() async {
    return showDialog<AuthenticateResult>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AuthenticateDialogBox(
            canShowBiometricAuthentication: canShowBiometricAuthentication,
            // errorObject: errorObject,
          );
        }).then((userResponse) {
      hasAuthenticated =
          userResponse == null ? false : userResponse.isAuthenticated;
      keepTryingToAuthenticate =
          userResponse == null ? false : userResponse.needToAuthenticate;
    });
  }
}
