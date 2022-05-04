import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:sttds/model/nodemodel.dart';
import 'package:sttds/viewmodel/body/nodeviewmodel.dart';

typedef IndexedBuilder = Widget Function(BuildContext context, NodeModel data);

class NodeView extends StatefulWidget {
  NodeView({
    required this.itemBuilder,
    required this.nodeViewModel,
    required this.scrollController,
  });

  final IndexedBuilder itemBuilder;
  final NodeViewModel nodeViewModel;
  final AutoScrollController scrollController;

  @override
  State<StatefulWidget> createState() {
    return _NodeViewState();
  }
}

class _NodeViewState extends State<NodeView> {
  void updateView() => setState(() => {});

  @override
  void initState() {
    super.initState();
    widget.nodeViewModel.addListener(updateView);
  }

  @override
  void dispose() {
    widget.nodeViewModel.removeListener(updateView);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.nodeViewModel.nodeList.length,
      itemBuilder: (BuildContext context, int index) {
        return AutoScrollTag(
          key: ValueKey(index),
          controller: widget.scrollController,
          index: index,
          child:
              widget.itemBuilder(context, widget.nodeViewModel.nodeList[index]),
        );
      },
    );
  }
}
