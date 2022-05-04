import 'package:flutter/material.dart';
import 'package:sttds/model/itemmodel.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/services/scrollmanager.dart';
import 'package:sttds/services/snackbar.dart';
import 'package:sttds/viewmodel/body/datatreeviewmodel.dart';

class SearchData {
  SearchData([
    int index = 0,
    List<int> indexTree = const <int>[],
    String textToSearch = "",
  ]) {
    this.index = index;
    this.indexTree = indexTree;
    this.textToSearch = textToSearch;
  }

  int index = 0;
  List<int> indexTree = [];
  String textToSearch = "";
}

class SearchController extends ChangeNotifier {
  SearchController();

  // Search Properties
  /// [isModified] flag to identify if this search
  /// is the same as last time
  bool isModified = false;

  int? _searchResultsCount;
  int? get searchResultsCount => _searchResultsCount;
  set searchResultsCount(int? newsearchResultsCount) {
    if ((_searchResultsCount == null && newsearchResultsCount != null) ||
        (_searchResultsCount != null && newsearchResultsCount == null) ||
        (_searchResultsCount != newsearchResultsCount)) {
      _searchResultsCount = newsearchResultsCount;
      _searchResultsCountChanged = true;
    }
  }

  int? _searchIndex;
  int? get searchIndex => _searchIndex;
  set searchIndex(int? newSearchIndex) {
    if ((_searchIndex == null && newSearchIndex != null) ||
        (_searchIndex != null && newSearchIndex == null) ||
        (_searchIndex != newSearchIndex) ||
        _searchResultsCountChanged) {
      _searchIndex = newSearchIndex;
      _searchResultsCountChanged = false;
      newSearchResult = '${_searchIndex ?? "-"}/${_searchResultsCount ?? "-"}';
      notifyListeners();
    }
  }

  String newSearchResult = "-/-";

  /// flattened data for searching
  List<SearchData> searchData = [];
  String lastSearchText = "";
  bool lastCaseSensitive = false;
  List<SearchData> currentResultSet = [];
  int currentMatchIndex = 0;

  /// Application Settings singleton
  AppSettings get appSettings => AppSettings();

  /// Snackbar singleton
  AppSnackBar get appSnackBar => AppSnackBar();

  /// DataTreeController
  late final DataTreeViewModel dataTreeViewModel;

  void resetData() {
    searchData = [];
    setSearchResults(null, null);
  }

  void addChildrenToListRecursive(
      List<ItemModel> children, List<int> indexTreeStem) {
    for (int i = 0; i < children.length; i++) {
      List<int> indexTree = List.from(indexTreeStem);
      indexTree.add(i);
      searchData.add(SearchData(
          searchData.length, indexTree, children[i].toSearchString()));
      if (children[i].children.isNotEmpty) {
        addChildrenToListRecursive(children[i].children, indexTree);
      }
    }
  }

  int numberSearchMatches() =>
      // currentResultSet.isEmpty == null ? 0 : currentResultSet.length;
      currentResultSet.length;

  void buildFlatList(List<ItemModel> itemData) {
    // build the flat list fropmn the hierarchical list

    // recursively process children
    addChildrenToListRecursive(itemData[0].children, []);
  }

  void rebuildFlatList(List<ItemModel> itemData) {
    // build the flat list fropmn the hierarchical list

    // clear existing data
    resetData();

    // recursively process children
    buildFlatList(itemData);
  }

  int getCurrentMatchIndex(List<int> selectedNodeLocation) {
    int comparison;
    int index;
    for (index = 0; index < currentResultSet.length; index++) {
      comparison = compareIndexTrees(
          selectedNodeLocation, currentResultSet[index].indexTree);
      if (comparison == -1) break;
      if (comparison == 0) {
        return index;
      }
    }
    return index - 1;
  }

  int compareIndexTrees(List<int> a, List<int> b) {
    int limit = a.length < b.length ? a.length : b.length;
    for (int i = 0; i < limit; i++) {
      if (a[i] > b[i]) return 1;
      if (a[i] < b[i]) return -1;
    }
    return a.length - b.length;
  }

  RegExp getRegularExpression(String searchText) {
    const String startNoteSeparator = "≤";
    const String endNoteSeparator = "≥";

    bool includeTitle = appSettings.searchTitle;
    bool includeData = appSettings.searchData;
    bool includeNote = appSettings.searchNote;
    bool caseSensitive = appSettings.caseSensitive;

    // determine the regular expression based on the user settings..
    // as either
    //     title, data or note => currentSearchText
    //     title or data => currentSearchText.*endNoteSeparator
    //     data or note => startNoteSeparator.*currentSearchText
    //     title or note => currentSearchText.*startNoteSeparator|endNoteSeparator.*currentSearchText
    //     title or data => currentSearchText.*endNoteSeparator
    //     title => currentSearchText.*startNoteSeparator
    //     data => startNoteSeparator.*currentSearchText.*endNoteSeparator
    //     note => endNoteSeparator.*currentSearchText

    String regularExpression = "";
    if (includeTitle && includeData && includeNote) {
      regularExpression = searchText;
    } else if (includeTitle && includeData) {
      regularExpression = searchText + ".*" + endNoteSeparator;
    } else if (includeData && includeNote) {
      regularExpression = startNoteSeparator + ".*" + searchText;
    } else if (includeTitle && includeNote) {
      regularExpression = searchText +
          ".*" +
          startNoteSeparator +
          "|" +
          endNoteSeparator +
          ".*" +
          searchText;
    } else if (includeTitle) {
      regularExpression = searchText + ".*" + startNoteSeparator;
    } else if (includeData) {
      regularExpression =
          startNoteSeparator + ".*" + searchText + ".*" + endNoteSeparator;
    } else if (includeNote) {
      regularExpression = endNoteSeparator + ".*" + searchText;
    }
    return RegExp(regularExpression,
        caseSensitive: caseSensitive, dotAll: true);
  }

  bool findNextOccurance(List<ItemModel> itemData, String searchText,
      bool searchForward, bool wasModified, List<int> selectedNodeLocation) {
    RegExp regularExpression;

    if (searchText.isEmpty) {
      // nothing to search
      setSearchResults(null, null);
      return false;
    }

    // if the flattened data list is empty build it
    if (searchData.isEmpty) {
      buildFlatList(itemData);
    }
    // reset result set data
    currentResultSet = [];

    // build regular expression
    regularExpression = getRegularExpression(searchText);

    // loop approach
    int index = 0;
    while (index != -1) {
      index = searchData.indexWhere(
          (element) => element.textToSearch.contains(regularExpression), index);
      if (index != -1) {
        currentResultSet.add(searchData[index]);
        index++;
      }
    }

    if (this.currentResultSet.isEmpty) {
      setSearchResults(0, 0);
      return false;
    } else {
      // determine where currently sselected node exists in the results index and
      // search from there
      currentMatchIndex = getCurrentMatchIndex(selectedNodeLocation);
    }

    currentMatchIndex =
        searchForward ? currentMatchIndex + 1 : currentMatchIndex - 1;
    if (currentMatchIndex >= currentResultSet.length) {
      currentMatchIndex = 0;
    } else if (currentMatchIndex < 0) {
      currentMatchIndex = currentResultSet.length - 1;
    }
    setSearchResults(currentMatchIndex + 1, currentResultSet.length);
    return true;
  }

  void resetSearchResults() {
    setSearchResults(null, null);
    isModified = true;
  }

  void setSearchResults(int? searchIndex, int? searchResultsCount) {
    this.searchResultsCount = searchResultsCount;
    this.searchIndex = searchIndex;
  }

  bool _searchResultsCountChanged = false;

  Future<void> doSearch(
      BuildContext context, String searchText, bool searchForward) async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (await doNodeSearch(searchText, searchForward, isModified)) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null)
        currentFocus.focusedChild!.unfocus();
    }
    isModified = false;
  }

  // wrapper for search processor
  Future<bool> doNodeSearch(
      String searchText, bool searchingForward, bool isNewSearch) async {
    if (findNextMatch(searchText, searchingForward, isNewSearch)) {
      dataTreeViewModel.setTreeViewWidth();
      await NodeViewScrollManager()
          .scrollToIndex(dataTreeViewModel.getNodeIndex());
      return true;
    }
    return false;
  }

  /// Search
  bool findNextMatch(
      String searchText, bool searchForward, bool hasSearchTextChanged) {
    bool areResults;
    List<int> selectedNodePosition = dataTreeViewModel.getNodeIndexTree();
    areResults = findNextOccurance(dataTreeViewModel.data, searchText,
        searchForward, hasSearchTextChanged, selectedNodePosition);
    if (areResults) {
      dataTreeViewModel.expandBranchWithSelect(
          currentResultSet[currentMatchIndex].indexTree);
    } else {
      appSnackBar.showMessage(
          content: Text("No matching records"), milliseconds: 2000);
    }
    return areResults;
  }

  /// Set search index
  /// The search index is the index number of the search results
  /// that corresponds to this node.
  /// If this node doesn't match the search results
  /// it is stored as null and displayed as "-".
  void setSearchIndex() {
    // determine if currrenttly selected node matches a node in the search results set.
    // only need to do this if have current search results
    if (searchResultsCount == null || searchResultsCount == 0) {
    } else {
      List<int> selectedNodePosition = dataTreeViewModel.getNodeIndexTree();
      int comparison;
      for (int i = 0; i < currentResultSet.length; i++) {
        comparison = compareIndexTrees(
            selectedNodePosition, currentResultSet[i].indexTree);
        if (comparison == 0) {
          currentMatchIndex = i;
          searchIndex = i + 1;
          return;
        }
        if (comparison < 0) {
          break;
        }
      }
      // set the search index to null
      searchIndex = null;
    }
  }
}
