import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static final AppSettings _singleton = AppSettings._internal();

  factory AppSettings() {
    return _singleton;
  }

  AppSettings._internal();

  // Settings
  int _randomLength = 12;
  bool _includeLowerCase = true;
  bool _includeUpperCase = true;
  bool _includeDigit = true;
  bool _includeSpecial = false;
  bool _caseSensitive = false;
  bool _searchTitle = true;
  bool _searchData = true;
  bool _searchNote = false;
  bool _maskValues = false;
  bool _useAvailableBiometrics = false;
  String _lowerCaseCharSet = 'abcdefghijklmnopqrstuvwxyz';
  String _upperCaseCharSet = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
  String _digitCharSet = '1234567890';
  String _specialCharSet = '!@#\$%^&*?_-';
  String _selectedNodeId = '';
  List<String> _titleShortcutList = [];
  List<String> _dataShortcutList = [];
  List<String> _expandedNodeList = [];

  Future<void> initialiseSharedPreferences() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    _randomLength = sharedPreferences.getInt("randomLength") ?? 12;
    _includeLowerCase = sharedPreferences.getBool("includeLowerCase") ?? true;
    _includeUpperCase = sharedPreferences.getBool("includeUpperCase") ?? true;
    _includeDigit = sharedPreferences.getBool("includeDigit") ?? true;
    _includeSpecial = sharedPreferences.getBool("includeSpecial") ?? false;
    _caseSensitive = sharedPreferences.getBool("caseSensitive") ?? false;
    _searchTitle = sharedPreferences.getBool("searchTitle") ?? true;
    _searchData = sharedPreferences.getBool("searchData") ?? true;
    _searchNote = sharedPreferences.getBool("searchNote") ?? false;
    _maskValues = sharedPreferences.getBool("maskValues") ?? false;
    _useAvailableBiometrics =
        sharedPreferences.getBool("useAvailableBiometrics") ?? false;
    _lowerCaseCharSet = sharedPreferences.getString("lowerCaseCharSet") ??
        'abcdefghijklmnopqrstuvwxyz';
    _upperCaseCharSet = sharedPreferences.getString("upperCaseCharSet") ??
        'ABCDEFGHJKLMNPQRSTUVWXYZ';
    _digitCharSet = sharedPreferences.getString("digitCharSet") ?? '1234567890';
    _specialCharSet =
        sharedPreferences.getString("specialCharSet") ?? '!@#\$%^&*?_-';
    _selectedNodeId = sharedPreferences.getString("selectedNodeId") ?? '';
    _titleShortcutList = sharedPreferences.getStringList("titleShortcutList") ??
        ["Email", "Password", "Change this in settings"];
    _dataShortcutList = sharedPreferences.getStringList("dataShortcutList") ??
        ["Change this in settings"];
    _expandedNodeList =
        sharedPreferences.getStringList("expandedNodeList") ?? ["[0].0"];
  }

  /// Getters
  String get defaultPassword => " " * 32; //"                                ";
  int get randomLength => _randomLength;
  bool get includeLowerCase => _includeLowerCase;
  bool get includeUpperCase => _includeUpperCase;
  bool get includeDigit => _includeDigit;
  bool get includeSpecial => _includeSpecial;
  bool get caseSensitive => _caseSensitive;
  bool get searchTitle => _searchTitle;
  bool get searchData => _searchData;
  bool get searchNote => _searchNote;
  bool get maskValues => _maskValues;
  bool get useAvailableBiometrics => _useAvailableBiometrics;
  String get lowerCaseCharSet => _lowerCaseCharSet;
  String get upperCaseCharSet => _upperCaseCharSet;
  String get digitCharSet => _digitCharSet;
  String get specialCharSet => _specialCharSet;
  String get selectedNodeId => _selectedNodeId;
  List<String> get titleShortcutList => _titleShortcutList;
  List<String> get dataShortcutList => _dataShortcutList;
  List<String> get expandedNodeList => _expandedNodeList;

  /// Setters

  set randomLength(int newRandomLength) {
    _randomLength = newRandomLength;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setInt('randomLength', newRandomLength));
  }

  set includeLowerCase(bool newIncludeLowerCase) {
    _includeLowerCase = newIncludeLowerCase;
    SharedPreferences.getInstance().then(
        (prefs) => prefs.setBool('includeLowerCase', newIncludeLowerCase));
  }

  set includeUpperCase(bool newIncludeUpperCase) {
    _includeUpperCase = newIncludeUpperCase;
    SharedPreferences.getInstance().then(
        (prefs) => prefs.setBool('includeUpperCase', newIncludeUpperCase));
  }

  set includeDigit(bool newIncludeDigit) {
    _includeDigit = newIncludeDigit;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('includeDigit', newIncludeDigit));
  }

  set includeSpecial(bool newIncludeSpecial) {
    _includeSpecial = newIncludeSpecial;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('includeSpecial', newIncludeSpecial));
  }

  set lowerCaseCharSet(String newLowerCaseCharSet) {
    _lowerCaseCharSet = newLowerCaseCharSet;
    SharedPreferences.getInstance().then(
        (prefs) => prefs.setString('lowerCaseCharSet', newLowerCaseCharSet));
  }

  set upperCaseCharSet(String newUpperCaseCharSet) {
    _upperCaseCharSet = newUpperCaseCharSet;
    SharedPreferences.getInstance().then(
        (prefs) => prefs.setString('upperCaseCharSet', newUpperCaseCharSet));
  }

  set digitCharSet(String newDigitCharSet) {
    _digitCharSet = newDigitCharSet;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('digitCharSet', newDigitCharSet));
  }

  set specialCharSet(String newSpecialCharSet) {
    _specialCharSet = newSpecialCharSet;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('specialCharSet', newSpecialCharSet));
  }

  set caseSensitive(bool newCaseSensitive) {
    _caseSensitive = newCaseSensitive;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('caseSensitive', newCaseSensitive));
  }

  set searchTitle(bool newSearchTitle) {
    _searchTitle = newSearchTitle;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('searchTitle', newSearchTitle));
  }

  set searchData(bool newSearchData) {
    _searchData = newSearchData;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('searchData', newSearchData));
  }

  set searchNote(bool newSearchNote) {
    _searchNote = newSearchNote;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('searchNote', newSearchNote));
  }

  set titleShortcutList(List<String> newTitleShortcutList) {
    _titleShortcutList = newTitleShortcutList;
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setStringList('titleShortcutList', newTitleShortcutList));
  }

  set dataShortcutList(List<String> newDataShortcutList) {
    _dataShortcutList = newDataShortcutList;
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setStringList('dataShortcutList', newDataShortcutList));
  }

  set maskValues(bool newMaskValues) {
    _maskValues = newMaskValues;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setBool('maskValues', newMaskValues));
  }

  set useAvailableBiometrics(bool newUseAvailableBiometrics) {
    _useAvailableBiometrics = newUseAvailableBiometrics;
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setBool('useAvailableBiometrics', newUseAvailableBiometrics));
  }

  set expandedNodeList(List<String> newExpandedNodeList) {
    _expandedNodeList = newExpandedNodeList;
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setStringList('expandedNodeList', newExpandedNodeList));
  }

  set selectedNodeId(String newSelectedNodeId) {
    _selectedNodeId = newSelectedNodeId;
    SharedPreferences.getInstance()
        .then((prefs) => prefs.setString('selectedNodeId', newSelectedNodeId));
  }
}
