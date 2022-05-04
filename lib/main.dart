import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sttds/services/lifecyclemanager.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/view/appbar/searchappbar.dart';
import 'package:sttds/services/searchcontroller.dart';
import 'package:sttds/view/body/datatree.dart';
import 'package:sttds/view/drawer/appdrawer.dart';
import 'package:sttds/viewmodel/body/datatreeviewmodel.dart';
import 'package:sttds/services/securestorage.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/theme/thememanager.dart';
import 'package:sttds/view/authentication/appauthentication.dart';
import 'package:sttds/services/snackbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STTDS',
      theme: ThemeManager.lightTheme,
      darkTheme: ThemeManager.darkTheme,
      home: MyHomePage(title: 'Simple Text Tree Data Store'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum AppStatus { initial, loading, ready }

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  /// search controller
  SearchController searchController = SearchController();

  /// Singleton for the datatree object
  DataTreeViewModel dataTreeViewModel = DataTreeViewModel();

  /// Settings singleton
  AppSettings get appSettings => AppSettings();

  /// snackbar implementation singleton
  AppSnackBar get appSnackBar => AppSnackBar();

  /// Secure Storage singleton
  SecureStorageService get secureStorage => SecureStorageService();

  /// Save flag animation mechanism
  double saveOpacity = 0.0;
  void flashSave() => setState(() => saveOpacity = 1);

  /// flag for displaying data
  AppStatus status = AppStatus.initial;

  @override
  void initState() {
    appSnackBar.flashSave = flashSave;
    searchController.dataTreeViewModel = dataTreeViewModel;
    super.initState();
  }

  /// Build the screen
  @override
  Widget build(BuildContext context) {
    // pass the context to the snack bar so it can show messages
    appSnackBar.context = context;
    if (status == AppStatus.initial) {
      AppAuthentication appAuthentication = AppAuthentication(context: context);
      appAuthentication.initialiseSettings().then((bool hasAuthenticated) {
        if (hasAuthenticated == false) {
          // quit application
          exitApplication();
          return;
        }
        // if manual authentication dialog is still open close it
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        setState(() => status = AppStatus.loading);
        dataTreeViewModel.load(context).then((_) {
          setState(() => status = AppStatus.ready);
        }).catchError((e) {
          // quit application
          exitApplication();
          return;
        });
      });
    }
    return SafeArea(
      bottom: true,
      child: AnimatedTheme(
        duration: Duration(milliseconds: 1000),
        data: Theme.of(context),
        child: scaffold(),
      ),
    );
  }

  Widget scaffold() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).bottomAppBarColor,
        systemNavigationBarIconBrightness:
            Theme.of(context).brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
      ),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: status == AppStatus.initial
          ? null
          : SearchAppBar(
              searchController: searchController,
            ),
      drawer: AppDrawer(
        dataTreeViewModel: dataTreeViewModel,
        searchController: searchController,
      ),
      body: status == AppStatus.ready ? appData : appLogo,
      floatingActionButton: saved,
    );
  }

  Widget get appData {
    return LifeCycleManager(
      dataTreeViewModel: dataTreeViewModel,
      child: DataTree(
        dataTreeViewModel: dataTreeViewModel,
        searchController: searchController,
      ),
    );
  }

  Widget get appLogo {
    return Center(
      child: status == AppStatus.initial
          ? Image.asset(
              'assets/images/sttds_logo.png',
              scale: 4.0,
            )
          : Icon(
              Icons.hourglass_bottom_outlined,
              size: 32,
              color: Theme.of(context).accentColor,
            ),
    );
  }

  Widget get saved {
    return AnimatedOpacity(
      opacity: saveOpacity,
      duration: Duration(milliseconds: 1250),
      curve: Curves.easeInOutQuart,
      onEnd: () => setState(() => saveOpacity = 0),
      child: FloatingActionButton(
        onPressed: () {},
        mini: false,
        child: Icon(
          FeatherIcons.save,
        ),
      ),
    );
  }

  Future<void> exitApplication() async {
    // quit application
    Future.delayed(const Duration(milliseconds: 100), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }
}
