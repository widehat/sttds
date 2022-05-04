import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sttds/model/itemmodel.dart';
import 'package:sttds/model/nodemodel.dart';

class NodeViewModel extends ChangeNotifier {
  NodeViewModel();

  static final ItemModel rootItem = ItemModel(
    id: "[0].0",
    nm: "root",
    children: [],
  );
  static final NodeModel rootNode = NodeModel(
    item: rootItem,
    //indexInTree: 0,
    indexInParent: -1,
    level: -1,
    hasData: false,
    hasNote: false,
    isExpanded: true,
    isSelected: false,
  );

  /// the raw data is stored in [data]
  /// a dummy node that acts as the root node is prepended to
  /// the start.
  List<ItemModel> data = [rootItem];

  /// [nodeList] is the list of visible nodes displayed to the user
  /// it's always a subset of the nodes in the raw data as the
  /// root node is never displayed.
  List<NodeModel> nodeList = [rootNode];

  /// [selectedNode] stores the currently selected/highlighted
  /// node in the list view Until data is populated this property
  /// can be null;
  NodeModel selectedNode = rootNode;

  /// Resets and [data], noideList is alkways rebuiltfrom data
  void clearData() {
    data[0].children.clear();
  }

  /// Populates [data] and [nodeList] from a list of items
  /// used for initial loads only
  void loadData(List<ItemModel> itemList) {
    data[0].children.addAll(itemList);
    sortDataRecursive(data[0]);
    nodeList = [rootNode];
    addItemsToViewList(data[0]);
  }

  /// sorts children of item and recursively sorts
  /// their children too used on initial loads
  void sortDataRecursive(ItemModel item) {
    item.sortChildren();
    for (int i = 0; i < item.children.length; i++) {
      sortDataRecursive(item.children[i]);
    }
  }

  /// appends children from parent to nodeList
  /// used for top level nodes only
  void addItemsToViewList(ItemModel parentItem) {
    nodeList.addAll(getChildNodes(parentItem, 0));
  }

  /// creates a list of new [NodeModel] nodes based on
  /// the members of [node.item.children]
  List<NodeModel> getChildNodes(ItemModel parent, int level) {
    List<NodeModel> newNodes = [];
    for (int i = 0; i < parent.children.length; i++) {
      NodeModel node = NodeModel(
        item: parent.children[i],
        //indexInTree: -1,
        indexInParent: i,
        level: level,
        hasData: parent.children[i].vl.isNotEmpty,
        hasNote: parent.children[i].nb.isNotEmpty,
        isExpanded: false,
        isSelected: false,
      );
      newNodes.add(node);
    }
    return newNodes;
  }

  /// deselects the currently selected node
  /// and makes [node] the new [selectedNode]
  void selectNode(NodeModel node) {
    unSelectNode();
    setSelected(node);
    notifyListeners();
  }

  /// deselects the currently selected node
  void unSelectNode() {
    selectedNode.isSelected = false;
  }

  /// makes [node] the currently selected node
  void setSelected(NodeModel node) {
    node.isSelected = true;
    selectedNode = node;
  }

  /// finds the node with a given ID
  void selectLoadedNodeUsingId(String id) {
    if (nodeList.length == 0) {
      return;
    }
    if (id.isEmpty) {
      selectNode(nodeList[1]);
      return;
    }
    int index = nodeList.indexWhere((node) => node.item.id == id);
    if (index == -1) {
      index = 1;
    }
    unSelectNode();
    setSelected(nodeList[index]);
  }

  /// captures a list of expanded nodes
  List<String> getExpandedNodes() {
    List<String> expandedNodeList = [];
    for (int i = 0; i < nodeList.length; i++) {
      if (nodeList[i].isExpanded) expandedNodeList.add(nodeList[i].item.id);
    }
    return expandedNodeList;
  }

  /// applies the list of previously captured expanded nodes
  void setExpandedNodes(List<String> expandedNodeList) {
    int index = -1;
    for (int i = 0; i < expandedNodeList.length; i++) {
      index = nodeList.indexWhere((NodeModel node) {
        return node.item.id == expandedNodeList[i];
      }, index + 1);
      if (index == -1) return;
      if (nodeList[index].isExpanded == false) {
        expand(nodeList[index]);
      }
    }
  }

  /// get node's index in the tree
  int getIndexInTree(NodeModel node) {
    for (int i = 0; i < nodeList.length; i++) {
      if (nodeList[i].item.id == node.item.id) {
        return i;
      }
    }
    return -1;
  }

  /// returns the index that corresponds to the last descendant of node
  int getLastDescendantIndex(NodeModel node) {
    int index = getIndexInTree(node);
    if (node.isExpanded == false) {
      return index + 1;
    }
    int endIndex = nodeList.length;
    for (int i = index + 1; i < nodeList.length; i++) {
      if (nodeList[i].level <= node.level) {
        endIndex = i;
        break;
      }
    }
    return endIndex;
  }

  /// wrapper function for expand or collapse operatioon
  void expandOrCollapse(NodeModel node) {
    if (node.isExpanded) {
      collapse(node);
    } else {
      expand(node);
    }
    notifyListeners();
  }

  /// Expands a node by inserting [node.item.children]
  /// in to [nodeList] immediately after [item]
  void expand(NodeModel parent) {
    nodeList.insertAll(getIndexInTree(parent) + 1,
        getChildNodes(parent.item, parent.level + 1));
    parent.isExpanded = true;
  }

  /// Collapses a node by removing all [nodeList] members
  /// that appear after [item] up to the end of the list
  /// but before the next node of the same or lower level.
  /// In addition if the [selectedNode] is a descendant
  /// of the collapsing node then [item] becomes the
  /// [selectedNode]
  void collapse(NodeModel parent) {
    // check if collapsing node is an ancestor of
    // currently selcted node
    bool ancestor = isAncestor(parent);
    // find descendants by looking for the next node in the list
    // that has the same or greater level number ie a sibling or
    // parent's next sibling, or the end of the list
    int rangeEnd = getLastDescendantIndex(parent);
    nodeList.removeRange(getIndexInTree(parent) + 1, rangeEnd);
    if (ancestor) {
      unSelectNode();
      setSelected(parent);
    }
    parent.isExpanded = false;
  }

  /// Collapses all nodes down to level 0.
  /// This is useful for Autoscrolling to search results
  void quickCollapseAll() {
    nodeList = [rootNode];
    addItemsToViewList(data[0]);
  }

  /// Uses a list of indexes to expand a branch of nodes to a
  /// specific node. Each [indexTree] member is an [indexInParent]
  /// property of a ViewNode node which corresponds to the
  /// node.item.children index number
  void expandBranchWithSelect(List<int> indexTree) {
    quickCollapseAll();
    int parentIndex = 0;
    for (int i = 0; i < indexTree.length - 1; i++) {
      parentIndex = parentIndex + indexTree[i] + 1;
      expand(nodeList[parentIndex]);
    }
    // select the final path member
    selectNode(nodeList[parentIndex + indexTree.last + 1]);
    notifyListeners();
  }

  ItemModel copyItem(NodeModel node, bool withNewIds) {
    return ItemModel.fromJson(
      jsonDecode(jsonEncode(node.item)), // map
      withNewIds: withNewIds,
    );
  }

  /// returns a list of ancestor node indexes ..indexInParent
  /// where the first list member is the root ancestor
  /// and the last list member is the node's parent
  List<int> getNodeIndexTree(NodeModel node) {
    List<int> indexTree = [node.indexInParent];
    int level = node.level;
    if (node.level != 0) {
      for (int i = getIndexInTree(node) - 1; i != 0; i--) {
        if (nodeList[i].level == level - 1) {
          indexTree.insert(0, nodeList[i].indexInParent);
          if (nodeList[i].level == 0) break;
          level--;
        }
      }
    }
    return indexTree;
  }

  /// returns a list of ancestor node titles ..item.nm
  /// where the first list member is the root ancestor
  /// and the last list member is the node's parent
  List<String> getNodePathTree(NodeModel node) {
    List<String> pathTree = [];
    int level = node.level;
    if (node.level != 0) {
      for (int i = getIndexInTree(node) - 1; i != 0; i--) {
        if (nodeList[i].level == level - 1) {
          pathTree.insert(0, nodeList[i].item.nm);
          if (nodeList[i].level == 0) break;
          level--;
        }
      }
    }
    return pathTree;
  }

  /// Checks if [maybeAncestorNode] is really an ancestor of [node]
  /// if [node] is omitted it checks if [maybeAncestorNode] is
  /// an ancestor of [selectedNode]
  bool isAncestor(NodeModel maybeAncestorNode, [NodeModel? node]) {
    node ??= selectedNode;
    int index = getIndexInTree(node);
    if (node == maybeAncestorNode ||
        node.level == 0 ||
        node.level <= maybeAncestorNode.level ||
        index < getIndexInTree(maybeAncestorNode)) {
      return false;
    }
    int level = node.level;
    for (int i = index - 1; i != 0; i--) {
      if (nodeList[i].level == level - 1) {
        if (nodeList[i].level == maybeAncestorNode.level) {
          if (nodeList[i] == maybeAncestorNode) {
            return true;
          } else {
            return false;
          }
        }
        level--;
      }
    }
    return false;
  }

  /// returns parent of [node]
  NodeModel getParent(NodeModel node) {
    if (node.level == 0) return nodeList[0];
    int i;
    for (i = getIndexInTree(node) - 1; i != 0; i--) {
      if (nodeList[i].level == node.level - 1) {
        break;
      }
    }
    return nodeList[i];
  }

  /// removes a subset of nodes from nodeList
  /// optionally also deletes teh item correpsonding
  /// to the initial node or branch head
  List<NodeModel> extractBranch(NodeModel node, [bool withDelete = false]) {
    int subListStart = getIndexInTree(node);
    int subListEnd = getLastDescendantIndex(node);
    NodeModel parent = getParent(node);
    List<NodeModel> branch = nodeList.sublist(subListStart, subListEnd);
    if (withDelete) {
      parent.item.children.removeAt(node.indexInParent);
    }
    nodeList.removeRange(subListStart, subListEnd);
    if (withDelete) {
      updateChildrenIIP(parent);
    }
    return branch;
  }

  /// gets the index number of an item in a list
  /// equivalent to indexOf
  int getIndexOf(NodeModel parent, ItemModel item) {
    int indexInParent = parent.item.children.length;
    for (int i = 0; i < parent.item.children.length; i++) {
      if (parent.item.children[i].id == item.id) {
        indexInParent = i;
        break;
      }
    }
    return indexInParent;
  }

  int getInsertionTreeIndex(NodeModel parent, int indexInParent) {
    int indexInTree = nodeList.length;
    if (indexInParent == 0) {
      indexInTree = getIndexInTree(parent) + 1;
    } else if (indexInParent == parent.item.children.length - 1) {
      indexInTree = getLastDescendantIndex(parent);
    } else {
      for (int i = getIndexInTree(parent) + 1; i < nodeList.length; i++) {
        if (nodeList[i].level <= parent.level) {
          indexInTree = i;
          break;
        }
        if (nodeList[i].level == parent.level + 1) {
          if (nodeList[i].item.id ==
              parent.item.children[indexInParent + 1].id) {
            indexInTree = i;
            break;
          }
        }
      }
    }
    return indexInTree;
  }

  /// for any siblings of node that exist in the tree following
  /// node increment their indexInParent property by 1
  void updateChildrenIIP(NodeModel parent, [int setSelectedIndex = -1]) {
    // a sibling can be defined as a node following newly
    // inserted node that shares the same level prior to
    // a node on a lower level value (ie an level above)
    // or the end of the list
    int indexInParent = 0;
    for (int i = getIndexInTree(parent) + 1; i < nodeList.length; i++) {
      if (nodeList[i].level <= parent.level) break;
      if (nodeList[i].level == parent.level + 1) {
        nodeList[i].indexInParent = indexInParent;
        if (setSelectedIndex == indexInParent) {
          setSelected(nodeList[i]);
        }
        indexInParent++;
      }
    }
  }

  /// Loops through the child nodes until it matches on ID
  /// then selects that node and stops
  void selectNodeWithId(NodeModel parent, String matchId) {
    // a sibling can be defined as a node following newly
    // inserted node that shares the same level prior to
    // a node on a lower level value (ie an level above)
    // or the end of the list
    for (int i = getIndexInTree(parent) + 1; i < nodeList.length; i++) {
      if (nodeList[i].level <= parent.level) break;
      if (nodeList[i].level == parent.level + 1) {
        if (nodeList[i].item.id == matchId) {
          unSelectNode();
          setSelected(nodeList[i]);
        }
      }
    }
  }

  /// updates level based on new starting value
  List<NodeModel> updateLevel(List<NodeModel> branch, int level) {
    int adjustment = level - branch[0].level;
    if (adjustment != 0) {
      for (int i = 0; i < branch.length; i++) {
        branch[i].level += adjustment;
      }
    }
    return branch;
  }

  /// inserts a new node into [nodeList] as a child of [parent]
  /// and [item] in to [data] as a member of [parent.item.children]
  void insert(NodeModel parent, ItemModel item, [bool reselect = false]) {
    parent.item.children.add(item);
    parent.item.sortChildren();
    if (parent.isExpanded == false) {
      expand(parent);
    } else {
      int indexInParent = getIndexOf(parent, item);

      int insertIndexInTree = getInsertionTreeIndex(parent, indexInParent);
      nodeList.insert(
          insertIndexInTree,
          NodeModel(
            item: parent.item.children[indexInParent],
            //indexInTree: -1,
            indexInParent: -1,
            level: parent.level + 1,
            hasData: item.vl.isNotEmpty,
            hasNote: item.nb.isNotEmpty,
            isExpanded: false,
            isSelected: false,
          ));
      updateChildrenIIP(parent);
    }
    notifyListeners();
  }

  /// updates an existing mode and associated node.item
  void update(NodeModel node, ItemModel item) {
    // first update item in node.item
    if (node.item.nm != item.nm) node.item.nm = item.nm;
    if (node.item.vl != item.vl) {
      node.item.vl = item.vl;
      node.hasData = item.vl.isNotEmpty;
    }
    if (node.item.op != item.op) node.item.op = item.op;
    if (node.item.nb != item.nb) {
      node.item.nb = item.nb;
      node.hasNote = item.nb.isNotEmpty;
    }
    // reset the node's width
    node.item.width = 0;
    // now update nodeList
    NodeModel parent = getParent(node);
    parent.item.sortChildren();
    int indexInParent = getIndexOf(parent, item);
    if (indexInParent != node.indexInParent) {
      // the node must move
      // grab nodeList rows for this node
      // and its descendants if it's expanded
      List<NodeModel> branch = extractBranch(node);
      int insertIndexInTree = getInsertionTreeIndex(
          parent, indexInParent); //findNextTreeIndex(parent, indexInParent);
      nodeList.insertAll(insertIndexInTree, branch);
      updateChildrenIIP(parent);
    }
    notifyListeners();
  }

  /// removes [node] from [nodeList] and also
  /// removes [node.item] from [data]
  void delete(NodeModel node) {
    int indexInParent = node.indexInParent;
    NodeModel parent = getParent(node);
    unSelectNode();
    extractBranch(node, true);
    // nodeList.removeAt(getIndexInTree(node));
    // parent.item.children.removeAt(indexInParent);
    if (parent.item.children.isEmpty) {
      setSelected(parent);
    } else {
      if (parent.item.children.length == indexInParent) {
        indexInParent--;
      }
      updateChildrenIIP(parent, indexInParent);
    }
    notifyListeners();
  }

  /// clone a node with or without newIds
  void clone(NodeModel node) {
    // create a new item based on current node.item
    ItemModel item = copyItem(node, true);
    // insert this item in to data set
    NodeModel parent = getParent(node);
    parent.item.children.insert(node.indexInParent, item);
    // create a new node and insert it in to the nodeList
    nodeList.insert(
        getIndexInTree(node),
        NodeModel(
          item: getParent(node).item.children[node.indexInParent],
          //indexInTree: -1,
          indexInParent: node.indexInParent + 1,
          level: node.level,
          hasData: node.hasData,
          hasNote: node.hasNote,
          isExpanded: false,
          isSelected: false,
        ));
    updateChildrenIIP(parent);
    notifyListeners();
  }

  void move(NodeModel node, NodeModel targetParent) {
    if (targetParent == getParent(node)) return;
    bool wasSelected = node.isSelected;
    if (wasSelected) unSelectNode();
    // copy item based on current node.item
    ItemModel item = copyItem(node, false);
    // grab nodeList rows for this node
    // and its descendants if it's expanded
    List<NodeModel> branch = extractBranch(node, true);
    if (targetParent.isExpanded == false) {
      expand(targetParent);
    }
    // add the new item to the target's children
    targetParent.item.children.add(item);
    targetParent.item.sortChildren();
    // find the index of the item in its parent.children
    int indexInParent = getIndexOf(targetParent, item);
    // find the corresponding index insertion point of nodeList
    int insertIndexInTree = getInsertionTreeIndex(targetParent, indexInParent);
    // update node to point to the new item
    branch[0].item = targetParent.item.children[indexInParent];
    // update level property for any visible descendant nodes
    branch = updateLevel(branch, targetParent.level + 1);
    // insert the branch in to its new location in the tree
    nodeList.insertAll(insertIndexInTree, branch);
    // update IndexInParent property
    updateChildrenIIP(targetParent);
    if (wasSelected) setSelected(nodeList[insertIndexInTree]);
    notifyListeners();
  }

  /// reset widths
  void resetItemWidthRecursive(ItemModel item) {
    item.width = 0;
    for (int i = 0; i < item.children.length; i++) {
      resetItemWidthRecursive(item.children[i]);
    }
  }
}
