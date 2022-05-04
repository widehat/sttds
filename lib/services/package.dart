import 'package:package_info/package_info.dart';

class AppPackage {
  static final AppPackage _singleton = AppPackage._internal();

  factory AppPackage() {
    return _singleton;
  }

  AppPackage._internal();

  late final PackageInfo packageInfo;

  Future<void> setPackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}
