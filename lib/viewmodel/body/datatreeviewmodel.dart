import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:sttds/services/data.dart';
import 'package:sttds/model/itemmodel.dart';
import 'package:sttds/model/nodemodel.dart';
import 'package:sttds/services/file.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/services/scrollmanager.dart';
import 'package:sttds/services/snackbar.dart';
import 'package:sttds/viewmodel/body/nodeviewmodel.dart';
import 'package:sttds/view/body/constants.dart';

typedef SearchCallback = Function(String, bool, bool);
typedef UpdateWidthCallback = void Function();

class DataTreeViewModel extends ChangeNotifier {
  /// Controller for the snackbar and the flash Save button
  AppSnackBar get appSnackBar => AppSnackBar();

  /// Controller for file io
  FileManager get fileManager => FileManager();

  /// Application Settings singleton
  AppSettings get appSettings => AppSettings();

  /// Tree auto scrolling singleton
  NodeViewScrollManager get nodeViewScrollManager => NodeViewScrollManager();

  /// Controller for managing searches
  // late final SearchManager searchManager = SearchManager();

  /// TreeView Controller
  // late final TreeViewController treeViewController;
  NodeViewModel nodeViewModel = NodeViewModel();

  List<NodeModel> get nodeList => nodeViewModel.nodeList;
  List<ItemModel> get data => nodeViewModel.data;
  NodeModel get selectedNode => nodeViewModel.selectedNode;

  // Constants

  // Properties
  double screenWidth = 0.0;
  double newTreeWidth = 0.0;
  double scaleFactor = 0.0;
  BuildContext? context;

  void manageScreenFontAndWidthChanges(BuildContext context) {
    this.context = context;
    double newScreenWidth = MediaQuery.of(context).size.width;
    double newScaleFactor = MediaQuery.of(context).textScaleFactor;
    bool resetWidth = false;

    if (screenWidth != newScreenWidth) {
      screenWidth = newScreenWidth;
      resetWidth = true;
    }
    if (scaleFactor != newScaleFactor) {
      scaleFactor = newScaleFactor;
      resetWidth = true;
      if (scaleFactor != 0) {
        resetWidths();
      }
    }
    if (resetWidth) setTreeViewWidth(context);
  }

  void setTreeViewWidth([BuildContext? context]) {
    context ??= this.context;
    if (context == null) {
      return;
    }
    double nodeWidth = 0.0;
    newTreeWidth = screenWidth.ceilToDouble();

    for (int index = 0; index < nodeList.length; index++) {
      // item = widget.viewController.nodeList[index].item;
      if (nodeList[index].item.width == 0) {
        // have not yet calculated the node's data's width so do that now
        nodeList[index].item.width =
            getElementDataWidth(context, nodeViewModel.nodeList[index].item);
      }
      nodeWidth = nodeList[index].item.width // "width" of node
              +
              (elementLeftPadding + elementRightPadding) // outer padding
              +
              (2 * borderThickness) +
              (nodeList[index].level * levelIndent) // indent
              +
              elementIconWidthHeight // leading icon
              +
              elementNodeMenuButtonWidthHeight +
              rightEdgePadding // trailing icon
          ;
      if (nodeWidth > newTreeWidth) {
        newTreeWidth = nodeWidth.ceilToDouble();
      }
    }
    notifyListeners();
  }

  int getElementDataWidth(BuildContext context, ItemModel item) {
    double titleWidth = 0;
    double dataWidth = 0;
    int noteWidth = 0;
    int nodeWidth;
    // this adjustment seems required it's as if the calculation of the text is not correct??
    // only required when calculating length of data, maybe connected with font family who knows.
    const int adjustment = 0;

    titleWidth = (TextPainter(
            text: TextSpan(
                text: item.nm,
                style: Theme.of(context)
                    .textTheme
                    .subtitle1
                    ?.copyWith(fontWeight: FontWeight.w500)),
            // maxLines: 1,
            textScaleFactor: scaleFactor,
            textDirection: TextDirection.ltr)
          ..layout())
        .size
        .width;

    if (item.vl.isNotEmpty) {
      dataWidth = (TextPainter(
        text: TextSpan(
            text: getDisplayText(item),
            style: Theme.of(context).textTheme.bodyText2),
        textScaleFactor: scaleFactor,
        textDirection: TextDirection.ltr,
      )..layout())
          .size
          .width;
    }

    if (dataWidth > titleWidth) {
      nodeWidth = dataWidth.ceil();
    } else {
      nodeWidth = titleWidth.ceil();
    }

    if (item.vl.isNotEmpty) {
      nodeWidth += elementNodeCopyValueButtonWidth;
    }

    nodeWidth += selectedRowRightEdgePaddingInt;

    nodeWidth += adjustment;

    if (item.nb.isNotEmpty) {
      noteWidth = (screenWidth -
              (elementLeftPadding + elementRightPadding) -
              elementIconWidthHeight -
              (2 * borderThickness))
          .ceil();
    }

    return noteWidth >= nodeWidth ? noteWidth : nodeWidth;
  }

  String getDisplayText(ItemModel item) {
    if (item.vl.isEmpty) return "";
    bool isMasked = item.op == -1 || (appSettings.maskValues && item.op == 0);
    return isMasked ? maskedData : item.vl;
    // return separator + (isMasked ? maskedData : item.vl);
  }

  void resetWidths() {
    nodeViewModel.resetItemWidthRecursive(nodeViewModel.nodeList[0].item);
  }

  bool cannotDrop(NodeModel dragNode, NodeModel targetNode) {
    return nodeViewModel.isAncestor(dragNode, targetNode);
  }

  void expandOrCollapseNode(NodeModel node) {
    nodeViewModel.expandOrCollapse(node);
    // update the treeView's width
    setTreeViewWidth();
  }

  void move(NodeModel targetNode, NodeModel nodeToMove) async {
    nodeViewModel.move(nodeToMove, targetNode);
    // update the treeView's width
    setTreeViewWidth();
    // Save
    save();
    // Scroll to updated item if it's the selected node
    if (nodeToMove == selectedNode) scrollToNode(nodeToMove);
  }

  void duplicateNode(NodeModel node) {
    nodeViewModel.clone(node);
    // Save
    save();
  }

  /// update a node
  void update(NodeModel node, ItemModel newItem) {
    nodeViewModel.update(node, newItem);
    // update the treeView's width
    setTreeViewWidth();
    // Scroll to updated item
    scrollToNode(node);
    // Save
    save();
  }

  /// insert a single new node
  void insert(NodeModel node, ItemModel newItem, [bool selectNewNode = false]) {
    nodeViewModel.insert(node, newItem);
    // update the treeView's width
    setTreeViewWidth();
    // Save
    save();
  }

  /// Delete a node
  Future<void> delete(NodeModel node) async {
    if (canDelete(node) == false) return;
    // duplicate node (in case user changes their mind)
    ItemModel backupItem = nodeViewModel.copyItem(node, false);
    // capture the node's parent
    NodeModel parent = nodeViewModel.getParent(node);
    // delete the node
    nodeViewModel.delete(node);
    // update the treeView's width
    setTreeViewWidth();
    // Show SnackBar giving user a last chance to undo the delete
    appSnackBar.showMessage(
      content: Text(
        '[ ${backupItem.nm} ]\nhas been deleted.',
      ),
      milliseconds: 5000,
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          nodeViewModel.insert(parent, backupItem);
          nodeViewModel.selectNodeWithId(parent, backupItem.id);
          setTreeViewWidth();
          save();
        },
      ),
    );
    save();
  }

  bool canDelete(NodeModel node) {
    if (nodeList.length == 2) {
      appSnackBar.showMessage(
          content: Text("Can't delete all data"), milliseconds: 2500);
      return false;
    } else {
      return true;
    }
  }

  /// Select node
  void selectNode(NodeModel node) {
    nodeViewModel.selectNode(node);
  }

  /// scroll to selected node
  void scrollToNode(NodeModel node) {
    nodeViewScrollManager.scrollToIndex(nodeViewModel.getIndexInTree(node));
  }

  /// Copy node's data/title to clipboard
  Future<void> copy(ItemModel item) async {
    String copyText;
    if (item.vl.isNotEmpty) {
      copyText = item.vl;
    } else {
      copyText = item.nm;
    }
    await copyToClipboard(copyText);
  }

  /// Copy to clipboard
  Future<void> copyToClipboard(String copyText) async {
    await Clipboard.setData(ClipboardData(text: copyText)).whenComplete(() {
      appSnackBar.showMessage(content: Text("Copied"), milliseconds: 1000);
    });
  }

  /// runs after the search has comnpleted
  void searchComplete() async {}

  void insertTopLevelNode(ItemModel newNode) {
    // treeViewController.addTopLevelNode(newNode);
    // tidyUpTreeAndSave(newNode);
  }

  void tidyUpTreeAndSave(ItemModel newNode) {
    // treeViewController.resortTopLevelNodes();
    // treeViewController.selectItem(newNode);
    // treeViewController.updateTree();
    // save();
  }

  /// Read data (specifically text) from the clipboard
  Future<String?> readClipboardText() async {
    final Map<String, dynamic>? result =
        await SystemChannels.platform.invokeMethod(
      'Clipboard.getData',
      Clipboard.kTextPlain,
    );

    if (result == null) return null;

    String? clipboardText = ClipboardData(text: result['text'] as String).text;
    return clipboardText;
  }

  /// Decode Json data.
  /// Determines, using very simplistic methods if should
  /// process as a single node or a list of nodes
  List<ItemModel> decodeJsonText(String json, {bool forceNewIds = false}) {
    var map;
    List<ItemModel> nodeList = [];
    bool isList = false;
    if (json.isEmpty) {
      appSnackBar.showMessage(content: Text('NO DATA'));
      return nodeList;
    }
    String firstChar = json.toString().substring(0, 1);
    if (firstChar == "[") {
      // assume list of items
      isList = true;
    } else if (firstChar == "{") {
      // asssume single item
      isList = false;
    } else {
      // not valid json data
      appSnackBar.showMessage(content: Text('INVALID DATA'));
      return nodeList;
    }
    try {
      map = jsonDecode(json);
      if (isList) {
        map.forEach((item) {
          nodeList.add(ItemModel.fromJson(item, withNewIds: forceNewIds));
        });
      } else {
        nodeList.add(ItemModel.fromJson(map, withNewIds: forceNewIds));
      }
    } catch (e) {
      appSnackBar.showMessage(content: Text('INVALID DATA\n\n$e'));
    }
    return nodeList;
  }

  Future<void> save() async {
    await fileManager.writeFileData(jsonEncode(nodeViewModel.data[0].children));
  }

  int getNodeIndex([NodeModel? node]) {
    node ??= nodeViewModel.selectedNode;
    return nodeViewModel.getIndexInTree(node);
  }

  List<int> getNodeIndexTree([NodeModel? node]) {
    node ??= nodeViewModel.selectedNode;
    return nodeViewModel.getNodeIndexTree(node);
  }

  void expandBranchWithSelect(List<int> indexTree) {
    nodeViewModel.expandBranchWithSelect(indexTree);
  }

  Future<void> load(BuildContext context) async {
    // reset data (probably unnecessary)
    nodeViewModel.clearData();
    // get data from file
    String json = await fileManager.readFileData(context);
    if (json.isEmpty) {
      throw "readFileError";
    }
    // update the treeView
    List<ItemModel> importData = decodeJsonText(json);
    if (importData.isEmpty) {
      return;
    }
    nodeViewModel.loadData(importData);
    String selectedNodeId = appSettings.selectedNodeId;
    if (selectedNodeId.isEmpty) {
      selectedNodeId = importData[0].id;
    }
    applyExpandedNodeSet();
    applySelectedNode(selectedNodeId);
  }

  void storeExpandedNodes() {
    appSettings.selectedNodeId = selectedNode.item.id;
    Future.delayed(const Duration(milliseconds: 50)).then((_) {
      List<String> expandedNodeList = nodeViewModel.getExpandedNodes();
      appSettings.expandedNodeList = expandedNodeList;
    });
  }

  void applyExpandedNodeSet() {
    nodeViewModel.quickCollapseAll();
    nodeViewModel.setExpandedNodes(appSettings.expandedNodeList);
    Future.delayed(const Duration(milliseconds: 50))
        .then((_) => appSettings.expandedNodeList = []);
  }

  void applySelectedNode(String selectedNodeId) {
    nodeViewModel.selectLoadedNodeUsingId(selectedNodeId);
    scrollToNode(nodeViewModel.selectedNode);
    Future.delayed(const Duration(milliseconds: 50))
        .then((_) => appSettings.selectedNodeId = "");
  }

  /// import data from the clipboard to create a new top level node
  Future<void> import() async {
    String json = await readClipboardText() ?? "";
    List<ItemModel> itemList = decodeJsonText(json, forceNewIds: true);
    loadItemList(itemList);
  }

  void loadSampleData1() {
    List<ItemModel> itemList =
        decodeJsonText(getSampleData1(), forceNewIds: true);
    loadItemList(itemList);
  }

  Future<void> loadSampleData2() async {
    List<ItemModel> itemList = await getDataList();
    loadItemList(itemList);
  }

  void loadItemList(List<ItemModel> itemList) {
    if (itemList.isEmpty) return;
    nodeViewModel.loadData(itemList);
    nodeViewModel.selectLoadedNodeUsingId(itemList[0].id);
    scrollToNode(nodeViewModel.selectedNode);
    save();
  }

  void clearKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null)
      currentFocus.focusedChild!.unfocus();
  }
}
