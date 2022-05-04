import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:cryptography/cryptography.dart';
import 'package:sttds/services/securestorage.dart';
import 'package:sttds/services/snackbar.dart';
import 'package:sttds/view/authentication/encryptionkeydialog.dart';

class FileManager {
  static final FileManager _singleton = FileManager._internal();

  factory FileManager() {
    return _singleton;
  }

  static final String defaultData = '[{"nm": "My Data"}]';
  static final String decrpytionError = "Decryption Error";

  /// Authentication control
  bool hasAuthenticated = false;
  bool mustAuthenticate = true;

  FileManager._internal();

  /// Secure Storage
  SecureStorageService get secureStorage => SecureStorageService();

  /// Emcryption/decryption class
  final Pbkdf2 pbkdf2 =
      Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 1000, bits: 256);

  /// file name
  static final String filename = "sttds.dat.aes";

  /// SnackBar messages
  AppSnackBar get appSnackBar => AppSnackBar();

  // Salt/nonce
  final List<int> nonce = Utf8Encoder().convert("Wpu%4!A?z#n&e^sX");

  Future<Directory> get tempDirectory async {
    return await getTemporaryDirectory();
  }

  Future<Directory> get appDocumentsDirectory async {
    return await getApplicationDocumentsDirectory();
  }

  Future<Directory> get appSupportDirectory async {
    return await getApplicationSupportDirectory();
  }

  Future<Directory> get appLibraryDirectory async {
    return await getLibraryDirectory();
  }

  Future<Directory?> get externalDocumentsDirectory async {
    return await getExternalStorageDirectory();
  }

  Future<List<Directory>?> externalStorageDirectories(
      StorageDirectory type) async {
    return await getExternalStorageDirectories(type: type);
  }

  Future<List<Directory>?> get externalCacheDirectories async {
    return await getExternalCacheDirectories();
  }

  final AesCbc algorithm = AesCbc.with256bits(macAlgorithm: Hmac.sha256());

  Future<String> readFileData(BuildContext context) async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$filename');
      String clearText = "";
      if (await file.exists() == false) {
        return defaultData;
      }
      List<int> cipherBytes = await file.readAsBytes();
      clearText = await doDecryption(cipherBytes);
      if (clearText == decrpytionError) {
        // oh dear the stored encryption/decryption key is not working
        // this maybe because the secure folder is lost. Need to prompt
        // user to enter the key. Loop so the user can keep retrying
        while (mustAuthenticate == true && hasAuthenticated == false) {
          await userKeyEntry(context);
        }
        if (hasAuthenticated == false) {
          // this means the user has hit the BACK button
          // ie the dialog box has closed but user has not
          // entered the correct password
          return "";
        }
        clearText = await doDecryption(cipherBytes);
      }
      return clearText;
    } catch (e) {
      appSnackBar.showMessage(
          content: Text("ERROR READING FILE\n\n$e"), replaceCurrent: true);
      return "";
    }
  }

  Future<String> doDecryption(List<int> cipherBytes) async {
    List<int> clearBytes = [];
    String clearText = "";
    try {
      clearBytes = await decryptBytes(cipherBytes);
      if (clearBytes.isEmpty) {
        clearText = decrpytionError;
      } else {
        clearText = String.fromCharCodes(clearBytes);
      }
    } catch (e) {
      clearText = decrpytionError;
      appSnackBar.showMessage(
        content: Text("ERROR DECODING DATA FILE\n\n$e"),
      );
    }
    return clearText;
  }

  Future<List<int>> decryptBytes(List<int> cipherBytes,
      [String password = ""]) async {
    List<int> clearBytes = [];
    if (cipherBytes.isEmpty) {
      return clearBytes;
    }
    SecretKey secretKey = await getKey(password);
    Mac mac = await Hmac.sha256()
        .calculateMac(cipherBytes, secretKey: secretKey, nonce: nonce);
    SecretBox secretBox = SecretBox(cipherBytes, nonce: nonce, mac: mac);
    try {
      clearBytes = await algorithm.decrypt(secretBox, secretKey: secretKey);
    } catch (e) {
      // don't really need to report the error here as there are only two
      // outcomes - it's failed, an empty byte list is returned,
      // or it's been successful, a non zero length byte list is returned
      appSnackBar.showMessage(
        content: Text("DECRYPTION ERROR\n\nRe-enter key manually"),
      );
    }
    return clearBytes;
  }

  Future<void> userKeyEntry(BuildContext context) async {
    return showDialog<AuthenticateResult>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AuthenticateDialogBox(
            canShowBiometricAuthentication: false,
            // errorObject: errorObject,
          );
        }).then((userResponse) {
      hasAuthenticated =
          userResponse == null ? false : userResponse.isAuthenticated;
      mustAuthenticate =
          userResponse == null ? false : userResponse.needToAuthenticate;
    });
  }

  Future<void> writeFileData(String json) async {
    try {
      SecretBox encodedJson = await doEncryption(json);
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/$filename');
      File result = await file.writeAsBytes(encodedJson.cipherText);
      if (result.existsSync()) appSnackBar.flashSave();
    } catch (e) {
      appSnackBar.showMessage(
        content: Text("UNABLE TO SAVE DATA FILE\n\n$e"),
      );
    }
    return;
  }

  Future<SecretBox> doEncryption(String clearText) async {
    SecretKey secretKey = await getKey(); // algorithm.newSecretKey();
    return await algorithm.encrypt(
      Utf8Encoder().convert(clearText),
      secretKey: secretKey,
      nonce: nonce,
    );
  }

  Future<SecretKey> getKey([String password = ""]) async {
    // Password we want to hash
    final secretKey = SecretKey(
      Utf8Encoder().convert(password.isEmpty
          ? await secureStorage.getEncryptionPassword()
          : password),
    );

    Pbkdf2 pbkdf2 =
        Pbkdf2(macAlgorithm: Hmac.sha256(), iterations: 1000, bits: 256);

    // Calculate a hash that can be stored in the database
    final SecretKey newSecretKey = await pbkdf2.deriveKey(
      secretKey: secretKey,
      nonce: nonce,
    );

    return newSecretKey;
  }
}
