import 'itemmodel.dart';

class NodeModel {
  NodeModel({
    required this.item,
    //required this.indexInTree,
    required this.indexInParent,
    required this.level,
    required this.hasData,
    required this.hasNote,
    required this.isExpanded,
    required this.isSelected,
  });

  ItemModel item;
  //int indexInTree;
  int indexInParent;
  int level;
  bool hasData;
  bool hasNote;
  bool isExpanded;
  bool isSelected;
}
