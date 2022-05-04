import 'package:flutter/material.dart';
import 'package:sttds/model/nodemodel.dart';
import 'package:sttds/services/searchcontroller.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/utilities/moreIcon.dart';
import 'package:sttds/view/node/addedit.dart';
import 'package:sttds/view/node/challenge.dart';
import 'package:sttds/viewmodel/node/sharenodeviewmodel.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/viewmodel/body/datatreeviewmodel.dart';
import 'package:sttds/model/itemmodel.dart';
import 'package:sttds/utilities/appbuttonoption.dart';

/// This enumeration is for the menu items
enum NodeAction {
  challenge,
  add,
  edit,
  delete,
  share,
  import,
  copy,
  duplicate,
  paste,
  cut,
  copyData,
  copyTitle,
}

class MenuOption extends AppButtonOption {
  MenuOption({
    required this.value,
    required Widget icon,
    required String tooltip,
    required String text,
  }) : super(
          icon: icon,
          tooltip: tooltip,
          text: text,
        );

  /// Enumeration value that identifies the button pressed when
  /// user clicks on a button
  final NodeAction value;
}

class NodeMenu extends StatefulWidget with PreferredSizeWidget {
  const NodeMenu({
    required this.dataViewModel,
    required this.searchController,
    this.child,
  });

  final DataTreeViewModel dataViewModel;
  final SearchController searchController;
  final Widget? child;

  @override
  State<StatefulWidget> createState() {
    return NodeMenuState();
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class NodeMenuState extends State<NodeMenu> {
  /// Menu list
  final List<MenuOption> menuList = [
    MenuOption(
      value: NodeAction.copyData,
      icon: Icon(FeatherIcons.copy),
      text: "Copy data",
      tooltip: "Copy data value to clipboard",
    ),
    MenuOption(
      value: NodeAction.copyTitle,
      icon: Icon(FeatherIcons.copy),
      text: "Copy name",
      tooltip: "Copy node name to clipboard",
    ),
    MenuOption(
      value: NodeAction.add,
      icon: Icon(FeatherIcons.filePlus),
      text: "Add...",
      tooltip: "Add mew node",
    ),
    MenuOption(
      value: NodeAction.edit,
      icon: Icon(FeatherIcons.edit3),
      text: "Edit...",
      tooltip: "Edit node",
    ),
    MenuOption(
      value: NodeAction.delete,
      icon: Icon(FeatherIcons.trash2),
      text: "Delete",
      tooltip: "Delete node",
    ),
    MenuOption(
      value: NodeAction.duplicate,
      icon: Icon(FeatherIcons.server),
      text: "Duplicate",
      tooltip: "Make a copy of this node",
    ),
    MenuOption(
      value: NodeAction.challenge,
      icon: Icon(FeatherIcons.target),
      text: "Challenge...",
      tooltip: "Challenge node data",
    ),
    MenuOption(
      value: NodeAction.share,
      icon: Icon(FeatherIcons.share2),
      text: "Share...",
      tooltip: "Share node data",
    ),
  ];

  /// Application settings
  AppSettings get appSettings => AppSettings();

  /// Pop up menu selection
  NodeAction? selectedMenu;

  // /// Class to manage Cut, Copy Paste and Delete actions
  // CutCopyPasteDelete cutCopyPasteDelete;

  /// Separator to go between parent labels in path
  final String rootIdentifier = "";
  final String pathSeparator = " • ";

  @override
  void initState() {
    // cutCopyPasteDelete =
    //     CutCopyPasteDelete(widget.treeViewController, widget.dataTreeManager);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<NodeAction>(
      onSelected: (NodeAction result) => processMenu(result),
      tooltip: "Node Actions",
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(
          color: Theme.of(context).accentColor,
        ),
      ),
      padding: EdgeInsets.zero,
      child: widget.child,
      icon: MoreIcon(
        foregroundColor: Theme.of(context).accentColor,
        backgroundColor: Theme.of(context).selectedRowColor,
        widthHeight: 48,
      ),
      itemBuilder: (BuildContext context) {
        return menuList.asMap().entries.map((entry) {
          bool isEnabled = true;
          if ((entry.value.value == NodeAction.challenge ||
                  entry.value.value == NodeAction.copyData) &&
              (widget.dataViewModel.selectedNode.hasData == false)) {
            isEnabled = false;
          }
          return PopupMenuItem<NodeAction>(
            value: entry.value.value,
            enabled: isEnabled,
            child: Tooltip(
              message: entry.value.tooltip,
              child: Row(
                children: [
                  entry.value.icon,
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    entry.value.text,
                    style: TextStyle(
                      color: isEnabled
                          ? Theme.of(context).textSelectionTheme.cursorColor
                          : Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList();
      },
    );
  }

  void processMenu(NodeAction menuChoice) {
    NodeModel node = widget.dataViewModel.selectedNode;
    switch (menuChoice) {
      case NodeAction.copyData:
        {
          widget.dataViewModel.copyToClipboard(node.item.vl);
        }
        break;

      case NodeAction.copyTitle:
        {
          widget.dataViewModel.copyToClipboard(node.item.nm);
        }
        break;

      case NodeAction.edit:
        {
          showAddEditDialog(getPath(node).trim(), node.item);
        }
        break;

      case NodeAction.add:
        {
          String nodePath = getPath(node);
          nodePath += (nodePath.isEmpty ? "" : pathSeparator) + node.item.nm;
          showAddEditDialog(nodePath.trim(), null);
        }
        break;

      case NodeAction.share:
        {
          ShareNodeViewModel(context, node.item).shareNode();
        }
        break;

      case NodeAction.delete:
        {
          widget.dataViewModel.delete(node);
          widget.searchController.resetData();
        }
        break;

      case NodeAction.challenge:
        {
          showChallengeDialog(node);
        }
        break;

      case NodeAction.duplicate:
        {
          widget.dataViewModel.duplicateNode(node);
        }
        break;

      default:
        {
          //statements;
        }
        break;
    }
  }

  Future<void> showChallengeDialog(NodeModel node) async {
    // build node path
    // parent's title, parent's parent's title, etc.
    ItemModel item = node.item;
    String nodePath = getPath(node);

    // determmine if should show data
    bool showData = item.op == 1 || (!appSettings.maskValues && item.op == 0);

    // show dialog
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ChallengeDialogBox(
            nodePath: nodePath,
            nodeTitle: item.nm,
            nodeData: item.vl,
            showData: showData,
          );
        });
  }

  Future<void> showAddEditDialog(String nodePath, ItemModel? item) async {
    // show dialog
    return showDialog<ItemModel>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AddEditDialogBox(
            nodePath: nodePath,
            itemId: item == null ? "*" : item.id,
            itemName: item == null ? "" : item.nm,
            itemValue: item == null ? "" : item.vl,
            showValue: item == null ? 0 : item.op,
            itemNote: item == null ? "" : item.nb,
          );
        }).then((newItem) async {
      if (newItem == null) return;
      // node is the currently selected node
      NodeModel node = widget.dataViewModel.nodeViewModel.selectedNode;
      if (newItem.id == "*") {
        newItem.id = ItemTools().newId;
        widget.dataViewModel.insert(node, newItem);
      } else {
        widget.dataViewModel.update(node, newItem);
      }
      widget.searchController.resetData();
    });
  }

  String getPath(NodeModel node) {
    List<String> path =
        widget.dataViewModel.nodeViewModel.getNodePathTree(node);
    // return path.isEmpty
    //     ? rootIdentifier
    //     : rootIdentifier + path.join(pathSeparator);
    return path.join(pathSeparator);
  }
}
