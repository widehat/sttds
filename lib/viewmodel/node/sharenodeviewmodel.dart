import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';
import 'package:sttds/view/node/sharedropdown.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/model/itemmodel.dart';
import 'package:sttds/utilities/choicelist.dart';

enum ShareSelection {
  copyTitle,
  copyData,
  copyNote,
  shareTitle,
  shareData,
  shareNote,
  shareNode,
  shareNodeJson,
}

class ShareNodeViewModel {
  ShareNodeViewModel(
    this.context,
    this.node,
  );

  final ItemModel node;
  final BuildContext context;

  /// Application settings
  AppSettings get appSettings => AppSettings();

  Future<void> shareNode() async {
    // List<DropDownSelection> copyChoiceList = [];
    // copyChoiceList
    //     .add(DropDownSelection('"${node.nm}"', ShareSelection.copyTitle.index));
    // if (node.vl != "")
    //   copyChoiceList.add(
    //       DropDownSelection('"${node.vl}"', ShareSelection.copyData.index));
    // if (node.nb != "")
    //   copyChoiceList.add(
    //       DropDownSelection('"${node.nb}"', ShareSelection.copyNote.index));

    List<ChoiceListItem> shareChoiceList = [];
    shareChoiceList.add(ChoiceListItem(
        'Title: [ ${node.nm} ]', ShareSelection.shareTitle.index));
    if (node.vl.isNotEmpty) {
      shareChoiceList.add(ChoiceListItem(
          (node.op == -1 || (appSettings.maskValues && node.op == 0))
              ? 'Data'
              : 'Data: [ ${node.vl} ]',
          ShareSelection.shareData.index));
    }
    if (node.nb.isNotEmpty) {
      shareChoiceList.add(ChoiceListItem(
          'Note: [ ${node.nb} ]', ShareSelection.shareNote.index));
    }
    if (node.vl.isNotEmpty || node.nb.isNotEmpty) {
      shareChoiceList
          .add(ChoiceListItem('Node Summary', ShareSelection.shareNode.index));
    }
    shareChoiceList.add(ChoiceListItem(
        'Node Detail (JSON)', ShareSelection.shareNodeJson.index));

    // show dialog
    return showDialog<ChoiceListItem>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return ShareDropdownDialogBox(
            // copyChoiceList: copyChoiceList,
            shareChoiceList: shareChoiceList,
          );
        }).then((val) {
      if (val == null) return;

      switch (ShareSelection.values[val.id]) {
        case ShareSelection.copyTitle:
          {
            copyData(node.nm);
          }
          break;
        case ShareSelection.copyData:
          {
            copyData(node.vl);
          }
          break;
        case ShareSelection.copyNote:
          {
            copyData(node.nb);
          }
          break;
        case ShareSelection.shareTitle:
          {
            shareData(node.nm, "Node title");
          }
          break;
        case ShareSelection.shareData:
          {
            shareData(node.vl, "Node data value");
          }
          break;
        case ShareSelection.shareNote:
          {
            shareData(node.nb, "Node note");
          }
          break;
        case ShareSelection.shareNode:
          {
            shareData(node.toString(), "Node Summary");
          }
          break;
        case ShareSelection.shareNodeJson:
          {
            String json = jsonEncode(node);
            shareData(json, "Node JSON");
          }
          break;
        default:
          {}
          break;
      }
    });
  }

  void shareData(String shareText, String title) {
    Share.share(shareText, subject: title);
  }

  void copyData(String copyText) {
    Clipboard.setData(ClipboardData(text: copyText));
  }
}
