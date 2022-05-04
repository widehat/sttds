import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

// import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
// import 'package:indexed_list_view/indexed_list_view.dart';

class NodeViewScrollManager {
  static final NodeViewScrollManager _singleton =
      NodeViewScrollManager._internal();

  factory NodeViewScrollManager() {
    return _singleton;
  }

  NodeViewScrollManager._internal();

  /// appbar callback to rest its pin state
  VoidCallback onAutoScrollComplete = () {};

  /// Listener for AutoScrollCopmtroller
  final AutoScrollController scrollController = AutoScrollController(
    viewportBoundaryGetter: () =>
        Rect.fromLTRB(0, 0, 0, 0), //   MediaQuery.of(context).padding.bottom),
    axis: Axis.vertical,
  );

  /// Scroll to selected node
  Future scrollToIndex(int index) async {
    await Future.delayed(const Duration(milliseconds: 50), () async {
      double maxExtent = scrollController.position.maxScrollExtent;
      double viewPort = scrollController.position.viewportDimension;
      if (maxExtent + 48 <= viewPort) return;
      await scrollController
          .scrollToIndex(index, preferPosition: AutoScrollPosition.middle)
          .whenComplete(() {
        // double newOffSet = scrollController.appBar.scrollController.offset - 64.0;
        // scrollController.animateTo(newOffSet, duration: Duration(milliseconds: 150), curve: Curves.easeInOut);
        // if (scrollController.position.maxScrollExtent > (scrollController.position.correctBy(correction)))
        // scrollController.position.correctBy(48.0);
        // scrollController.appBar.heightNotifier.value = 1.0;
        onAutoScrollComplete();
      });
    });
  }
}
