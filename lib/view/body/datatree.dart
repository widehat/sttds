import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sttds/model/nodemodel.dart';
import 'package:sttds/services/searchcontroller.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/utilities/notchborder.dart';
import 'package:sttds/utilities/notchpath.dart';
import 'package:sttds/view/menu/nodemenu.dart';
import 'package:sttds/utilities/canvasbutton.dart';
import 'package:sttds/view/body/constants.dart';
import 'package:sttds/view/body/nodeview.dart';
import 'package:sttds/viewmodel/body/datatreeviewmodel.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/services/snackbar.dart';

class DataTree extends StatefulWidget {
  DataTree({
    required this.dataTreeViewModel,
    required this.searchController,
  });

  final DataTreeViewModel dataTreeViewModel;
  final SearchController searchController;

  @override
  DataTreeState createState() => DataTreeState();
}

class DataTreeState extends State<DataTree>
    with SingleTickerProviderStateMixin {
  /// Properties
  double treeViewWidth = 1000.0;
  Offset dragItemOffset = Offset(0, 0);

  /// Application Settings singleton
  AppSettings get appSettings => AppSettings();

  void updateView() {
    setState(() => treeViewWidth = widget.dataTreeViewModel.newTreeWidth);
  }

  @override
  void initState() {
    widget.dataTreeViewModel.addListener(updateView);
    super.initState();
  }

  @override
  void dispose() {
    widget.dataTreeViewModel.removeListener((updateView));
    super.dispose();
  }

  /// Build the screen
  @override
  Widget build(BuildContext context) {
    widget.dataTreeViewModel.manageScreenFontAndWidthChanges(context);
    double indentWidth = 300;
    double maxItemWidthWithIndent = treeViewWidth -
        elementIconWidthHeight -
        elementLeftPadding -
        elementRightPadding -
        (2 * borderThickness) -
        elementNodeMenuButtonWidthHeight -
        rightEdgePadding;
    return Listener(
      onPointerDown: (event) => widget.dataTreeViewModel.clearKeyboard(context),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: LimitedBox(
          maxWidth: treeViewWidth,
          child: NodeView(
            nodeViewModel: widget.dataTreeViewModel.nodeViewModel,
            scrollController:
                widget.dataTreeViewModel.nodeViewScrollManager.scrollController,
            itemBuilder: (context, node) {
              indentWidth = node.level * levelIndent;
              double maxItemWidth = maxItemWidthWithIndent - indentWidth;
              return (node.level == -1)
                  ? SizedBox(height: 0)
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        indent(indentWidth),
                        leadingIcon(node),
                        treeViewItem(node, maxItemWidth),
                        nodeMenuButton(node),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  Widget indent(double indentWidth) {
    return SizedBox(
      width: indentWidth,
    );
  }

  Widget leadingIcon(NodeModel node) {
    return SizedBox(
      width: elementIconWidthHeight,
      height: elementIconWidthHeight,
      child: node.item.children.isNotEmpty
          ? expandCollapseButton(node)
          : nodeBullet,
    );
  }

  Widget expandCollapseButton(NodeModel node) {
    return CanvasButton(
      onTap: () {
        widget.dataTreeViewModel.expandOrCollapseNode(node);
      },
      boxHeightWidth: elementNodeMenuButtonWidthHeight,
      alignment: Alignment.center,
      icon: node.isExpanded
          ? FeatherIcons.chevronDown
          : FeatherIcons.chevronRight,
      color: Theme.of(context).accentColor,
      iconSize: expandCollapseIconSize,
    );
  }

  Widget get nodeBullet {
    return Align(
      alignment: Alignment.center,
      child: Text(
        bullet,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
          fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
          fontWeight: Theme.of(context).textTheme.bodyText2!.fontWeight,
          color: Theme.of(context).accentColor,
        ),
        textScaleFactor: widget.dataTreeViewModel.scaleFactor,
      ),
    );
  }

  Widget treeViewItem(NodeModel node, double maxItemWidth) {
    return GestureDetector(
      onTap: () {
        if (node.isSelected == false) {
          widget.dataTreeViewModel.selectNode(node);
          widget.searchController.setSearchIndex();
        }
      },
      onLongPressStart: (longPressDetails) {
        if (node.isSelected == false) {
          widget.dataTreeViewModel.selectNode(node);
          widget.searchController.setSearchIndex();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: dismissable(node, maxItemWidth),
    );
  }

  Widget dismissable(NodeModel node, double maxItemWidth) {
    bool onTarget = false;
    double dismissFraction = node.item.width > 250 ? 50 / node.item.width : 1.0;
    if (node.isSelected) {
      return PhysicalShape(
        clipper: NotchPath(),
        color: Theme.of(context).selectedRowColor,
        // elevation: 4.0,
        child: Dismissible(
          key: Key(node.item.id),
          onDismissed: (direction) {
            if (direction == DismissDirection.endToStart) {
              widget.dataTreeViewModel.delete(node);
              widget.searchController.resetData();
            }
          },
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              if (widget.dataTreeViewModel.canDelete(node)) {
                return Future.value(true);
              }
            } else {
              await widget.dataTreeViewModel.copy(node.item);
            }
            return Future.value(false);
          },
          direction: DismissDirection.horizontal,
          dismissThresholds: {
            DismissDirection.endToStart: 0.6,
            DismissDirection.startToEnd: dismissFraction,
          },
          background: quickCopyBackground,
          secondaryBackground: deleteBackground,
          child: draggable(node, maxItemWidth, onTarget),
        ),
      );
    }
    return draggable(node, maxItemWidth, onTarget);
  }

  Widget draggable(NodeModel node, double maxItemWidth, bool onTarget) {
    Offset dragOffset = dragItemOffset;

    return Listener(
      onPointerDown: (ev) => setState(() => dragItemOffset =
          Offset(ev.localPosition.dx - 24, ev.localPosition.dy - 72)),
      child: DragTarget<NodeModel>(
        onWillAccept: (NodeModel? dragNode) {
          onTarget = dragNode!.item.id != node.item.id;
          return onTarget;
        },
        onAccept: (NodeModel dragNode) {
          // after the node has been dropped turn off the border
          onTarget = false;
          if (widget.dataTreeViewModel.cannotDrop(dragNode, node)) {
            // can't drop on a descendant of itself
            AppSnackBar().showMessage(
                content: Text(
                    "Can't move [${dragNode.item.nm}] to a descendant of itself"),
                milliseconds: 4000);
          } else {
            widget.dataTreeViewModel.move(node, dragNode);
            widget.searchController.resetData();
          }
        },
        onMove: (value) => onTarget = true,
        onLeave: (_) => onTarget = false,
        builder: (context, candidates, rejects) {
          if (node.isSelected) {
            return LongPressDraggable<NodeModel>(
              maxSimultaneousDrags: 1,
              hapticFeedbackOnStart: true,
              data: node,
              feedback: Transform.translate(
                offset: dragOffset,
                child: Container(
                  color: Theme.of(context).selectedRowColor,
                  padding: EdgeInsets.all(10.0),
                  child: nodeItemTitle(node),
                ),
              ),
              child: nodeItem(node, maxItemWidth, onTarget),
            );
          } else {
            return nodeItem(node, maxItemWidth, onTarget);
          }
        },
      ),
    );
  }

  Widget nodeItem(NodeModel node, double maxItemWidth, bool onTarget) {
    return Container(
      padding: EdgeInsets.only(
        left: elementLeftPadding,
        right: elementRightPadding,
        top: elementTopPadding,
        bottom: elementBottomPadding,
      ),
      constraints: BoxConstraints(minHeight: elementIconWidthHeight),
      foregroundDecoration: onTarget && node.isSelected
          // decoration when dragging over selected node
          ? ShapeDecoration(
              shape: NotchBorder(
                side: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 1.0,
                  style: BorderStyle.solid,
                ),
              ),
            )
          // decoration when dragging over other node
          : onTarget && node.isSelected == false
              ? BoxDecoration(
                  border: Border.all(
                    width: 1.0,
                    color: Theme.of(context).accentColor,
                  ),
                )
              // decoration when not drag target
              : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  nodeItemTitle(node),
                  nodeItemData(node),
                ],
              ),
              nodeItemCopyDataButton(node),
            ],
          ),
          nodeItemNote(node, maxItemWidth),
        ],
      ),
    );
  }

  Widget get deleteBackground {
    return Container(
      padding: EdgeInsets.only(
        right: 10.0,
      ),
      color: Theme.of(context).errorColor.withOpacity(0.4),
      alignment: Alignment.centerRight,
      child: Icon(
        FeatherIcons.trash2,
        color: Theme.of(context).errorColor,
      ),
    );
  }

  Widget get quickCopyBackground {
    return Container(
      padding: EdgeInsets.only(
        left: 10.0,
      ),
      color: Colors.grey.withOpacity(0.4),
      alignment: Alignment.centerLeft,
      child: Icon(
        FeatherIcons.copy,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget nodeItemTitle(NodeModel node) {
    return Text(
      node.item.nm,
      style: Theme.of(context)
          .textTheme
          .subtitle1
          ?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  // Widget nodeItemSeparator(NodeModel node) {
  //   return Text(
  //     node.item.vl.isNotEmpty ? separator : "",
  //     style: Theme.of(context).textTheme.bodyText2?.copyWith(
  //           color: Theme.of(context).accentColor,
  //         ),
  //   );
  // }

  Widget nodeItemData(NodeModel node) {
    if (node.item.vl.isEmpty) {
      return const SizedBox(height: 0, width: 0);
    } else {
      return Text(
          node.item.vl.isNotEmpty
              ? (node.item.op == -1 ||
                      (appSettings.maskValues && node.item.op == 0))
                  ? maskedData
                  : node.item.vl
              : "",
          style: Theme.of(context).textTheme.bodyText2);
    }
  }

  Widget nodeItemNote(NodeModel node, double maxItemWidth) {
    return node.item.nb.isEmpty
        ? const SizedBox(height: 0)
        : LimitedBox(
            maxWidth: maxItemWidth,
            child: Text(
              node.item.nb,
              style: Theme.of(context).textTheme.caption,
            ),
          );
  }

  Widget nodeItemCopyDataButton(NodeModel node) {
    if (node.item.vl.isNotEmpty & node.isSelected) {
      return nodeItemCopyData(node);
    } else {
      return const SizedBox(height: 0, width: 0);
    }
  }

  Widget nodeItemCopyData(NodeModel node) {
    return Transform.translate(
      offset: Offset(0, -4),
      child: Padding(
        padding: EdgeInsets.only(
          left: 18.0,
          right: 10.0,
        ),
        child: TextButton(
          onPressed: () =>
              widget.dataTreeViewModel.copyToClipboard(node.item.vl),
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(Size.square(0)),
            fixedSize: MaterialStateProperty.all(Size.square(18)),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Icon(
            Icons.copy,
            size: 20,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  Widget nodeMenuButton(NodeModel node) {
    return node.isSelected ? nodeMenu() : SizedBox(width: 0);
  }

  Widget nodeMenu() {
    return SizedBox(
      height: 48.0,
      child: Transform.translate(
        offset: Offset(-4, 0),
        child: NodeMenu(
          dataViewModel: widget.dataTreeViewModel,
          searchController: widget.searchController,
        ),
      ),
    );
  }
}
