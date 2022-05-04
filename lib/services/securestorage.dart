// import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/material.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/services/snackbar.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

typedef AsyncValueSetter<T> = Future<void> Function(T value);

class SecureStorageService {
  static final SecureStorageService _singleton =
      SecureStorageService._internal();

  factory SecureStorageService() {
    return _singleton;
  }

  SecureStorageService._internal();

  Object? errorObject;

  /// Application settings
  AppSettings get appSettings => AppSettings();

/*
  // Biometric Storage
  BiometricStorage get bioStorage => BiometricStorage();

  Future<void> writeSecureData(String key, String value) async {
    try {
      BiometricStorageFile file = await bioStorage.getStorage(key,
          options: StorageFileInitOptions(
            authenticationRequired: false,
          ));
      await file.write(value);
    } catch (e) {
      AppSnackBar().showMessage(
        content: Text("SECURE STORAGE WRITE ERROR:\n\n$e"),
        replaceCurrent: false,
        milliseconds: 10000,
      );
    }
  }

  Future<String?> readSecureData(String key) async {
    try {
      BiometricStorageFile file = await bioStorage.getStorage(key,
          options: StorageFileInitOptions(
            authenticationRequired: false,
          ));
      return await file.read();
    } catch (e) {
      AppSnackBar().showMessage(
        content: Text("SECURE STORAGE READ ERROR:\n\n$e"),
        replaceCurrent: false,
        milliseconds: 10000,
      );
    }
  }

  Future<bool> areBiometricsAvailable() async {
    CanAuthenticateResponse canAuthenticate =
        await bioStorage.canAuthenticate();
    if (canAuthenticate == CanAuthenticateResponse.errorNoBiometricEnrolled ||
        canAuthenticate == CanAuthenticateResponse.success) {
      return true;
    }
    return false;
  }

  Future<bool> areBiometricsEnabled() async {
    return await bioStorage.canAuthenticate() ==
        CanAuthenticateResponse.success;
  }

  Future<bool> authenticate({String key = 'authentication'}) async {
    try {
      errorObject = null;
      BiometricStorageFile file = await bioStorage.getStorage(
        key,
        androidPromptInfo: AndroidPromptInfo(
          confirmationRequired: false,
        ),
      );
      await file.write('ok');
      return true;
    } catch (e) {
      errorObject = e;
      if (e
          .toString()
          .contains("android-keystore://authentication_master_key exists")) {
        return true;
      }
      return false;
    }
  }
*/

  Future<String> getEncryptionPassword() async {
    return await readSecureData('encryptionPassword') ??
        appSettings.defaultPassword;
  }

  Future<void> setEncryptionPassword(String newEncryptionPassword) async {
    await writeSecureData('encryptionPassword', newEncryptionPassword);
  }

  // Local Authentication Service
  final LocalAuthentication authenticationService = LocalAuthentication();

  // Secure Storage using AES
  final secureStorageService = FlutterSecureStorage();

  Future<void> writeSecureData(String key, String value) async {
    try {
      await secureStorageService.write(key: key, value: value);
    } catch (e) {
      AppSnackBar().showMessage(
        content: Text("SECURE STORAGE WRITE ERROR:\n\n$e"),
        replaceCurrent: false,
        milliseconds: 10000,
      );
    }
  }

  Future<String?> readSecureData(String key) async {
    String? value;
    try {
      value = await secureStorageService.read(key: key);
    } catch (e) {
      AppSnackBar().showMessage(
        content: Text("SECURE STORAGE READ ERROR:\n\n$e"),
        replaceCurrent: false,
        milliseconds: 10000,
      );
    }
    return value;
  }

  Future<bool> areBiometricsAvailable() async {
    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await authenticationService.canCheckBiometrics;
    } catch (e) {
      AppSnackBar().showMessage(
        content: Text("ERROR ACCESSING BIOMETRIC INFO:\n\n$e"),
        replaceCurrent: false,
        milliseconds: 10000,
      );
    }
    return canCheckBiometrics;
  }

  Future<bool> areBiometricsEnabled() async {
    // get a list of available biometrics
    List<BiometricType> availableBiometrics = <BiometricType>[];
    try {
      availableBiometrics =
          await authenticationService.getAvailableBiometrics();
    } catch (e) {
      AppSnackBar().showMessage(
        content: Text("ERROR ENUMERATING BIOMETRIC OPTIONS:\n\n$e"),
        replaceCurrent: false,
        milliseconds: 10000,
      );
    }
    return availableBiometrics.isNotEmpty;
  }

  Future<bool> authenticate({String key = 'authentication'}) async {
    bool authenticated = false;
    try {
      authenticated = await authenticationService.authenticate(
        localizedReason: 'Authentication is required',
        useErrorDialogs: true,
        stickyAuth: false,
        sensitiveTransaction: false,
        biometricOnly: true,
      );
    } catch (e) {
      AppSnackBar().showMessage(
        content: Text("AUTHENTICATION ERROR:\n\n$e"),
        replaceCurrent: false,
        milliseconds: 2000,
      );
    }
    return authenticated;
  }
}
