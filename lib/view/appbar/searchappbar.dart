import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:sttds/services/searchcontroller.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/view/setting/searchsettings.dart';
import 'package:sttds/utilities/canvasbutton.dart';

typedef SearchCallback = Function();

class SearchAppBar extends StatefulWidget with PreferredSizeWidget {
  const SearchAppBar({
    required this.searchController,
  });

  final SearchController searchController;

  @override
  State<StatefulWidget> createState() {
    return SearchAppBarState();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SearchAppBarState extends State<SearchAppBar> {
  //with SingleTickerProviderStateMixin
  /// Controller used to manage search TextField
  final TextEditingController searchTextFieldController =
      TextEditingController();

  String searchResult = "";

  void updateSuffix() {
    setState(() => searchResult = widget.searchController.newSearchResult);
  }

  @override
  void initState() {
    widget.searchController.addListener(updateSuffix);
    super.initState();
  }

  @override
  void dispose() {
    widget.searchController.removeListener(updateSuffix);
    super.dispose();
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kMinInteractiveDimension),
      child: AppBar(
        leading: menuButton,
        titleSpacing: 0.0,
        title: searchTextField,
        actions: [searchForwardButton],
      ),
    );
  }

  Widget get searchTextField {
    return Padding(
      padding: EdgeInsets.only(
        left: 5.0,
        right: 5.0,
      ),
      child: TextField(
        textAlign: TextAlign.center,
        controller: searchTextFieldController,
        onChanged: (s) => widget.searchController.resetSearchResults(),
        onSubmitted: (s) => widget.searchController.doSearch(context, s, true),
        enableSuggestions: false,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.search,
        autofocus: false,
        decoration: InputDecoration(
          suffixText: searchResult,
          hintText: 'find...',
        ),
      ),
    );
  }

  Widget get menuButton {
    return CanvasButton(
      onTap: () => Scaffold.of(context).openDrawer(),
      // tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
      icon: FeatherIcons.menu,
    );
  }

  Widget get searchForwardButton {
    return CanvasButton(
      onTap: () => widget.searchController
          .doSearch(context, searchTextFieldController.text, true),
      onLongPress: () => showSearchSettingDialog(),
      // tooltip: "Search from selected node",
      icon: Icons.search,
    );
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
}
