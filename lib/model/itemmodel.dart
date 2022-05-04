import 'package:flutter/material.dart';

class ItemTools {
  static final ItemTools _singleton = ItemTools._internal();

  factory ItemTools() {
    return _singleton;
  }

  ItemTools._internal();

  String get newId =>
      UniqueKey().toString() +
      "." +
      DateTime.now().millisecondsSinceEpoch.toRadixString(16);

  bool doesCodeMapToDigit(int code) {
    return (code >= 48 && code <= 57);
  }

  bool isNumeric(String s) {
    List<int> codeUnitList = s.runes.toList(growable: false);
    return codeUnitList.every((element) => doesCodeMapToDigit(element));
  }

  List<String> chunkify(String s) {
    List<String> output = [];
    bool characterIsNumeric = false;
    bool previousCharacterIsNumeric = false;
    // reject empty strings
    if (s.isEmpty) return output;
    //seed first chunk
    List<int> codeUnitList = s.runes.toList(growable: false);
    output.add(String.fromCharCode(codeUnitList[0]));
    previousCharacterIsNumeric = doesCodeMapToDigit(codeUnitList[0]);
    // process remaining characters
    for (int i = 1; i < codeUnitList.length; i++) {
      characterIsNumeric = doesCodeMapToDigit(codeUnitList[i]);
      if (characterIsNumeric != previousCharacterIsNumeric) {
        output.add("");
        previousCharacterIsNumeric = characterIsNumeric;
      }
      output[output.length - 1] += String.fromCharCode(codeUnitList[i]);
    }
    return output;
  }

  int sortNaturalIgnoreCase(ItemModel a, ItemModel b) {
    List<String> aChunkList = chunkify(a.toSortString().toLowerCase());
    List<String> bChunkList = chunkify(b.toSortString().toLowerCase());
    bool isaChunkNumeric = false;
    bool isbChunckNumeric = false;
    for (int i = 0; i < aChunkList.length && i < bChunkList.length; i++) {
      if (aChunkList[i] != bChunkList[i]) {
        isaChunkNumeric = isNumeric(aChunkList[i]);
        isbChunckNumeric = isNumeric(bChunkList[i]);
        if (isaChunkNumeric == false && isbChunckNumeric == false) {
          return aChunkList[i].compareTo(bChunkList[i]);
        } else if (isaChunkNumeric == true && isbChunckNumeric == false) {
          return 1;
        } else if (isaChunkNumeric == false && isbChunckNumeric == true) {
          return -1;
        } else {
          return int.parse(aChunkList[i]) - int.parse(bChunkList[i]);
        }
      }
    }
    return aChunkList.length - bChunkList.length;
  }
}

class ItemModel {
  ItemModel({
    String id = "",
    required this.nm,
    this.vl = "",
    this.op = 0,
    this.nb = "",
    List<ItemModel>? children,
  }) {
    this.id = id.isEmpty ? itemTools.newId : id;
    this.children = children ?? [];
  }

  String id = "";
  String nb;
  String vl;
  int op;
  String nm;
  List<ItemModel> children = [];

  int width = 0;

  factory ItemModel.fromJson(Map<String, dynamic> json,
      {bool withNewIds = false}) {
    var list;
    List<ItemModel> childList = [];
    if (json['children'] != null) {
      list = json['children'] as List;
      list.forEach((dynamic item) {
        childList.add(ItemModel.fromJson(item, withNewIds: withNewIds));
      });
    }
    int oz = 0;
    if (json['oz'] != null) {
      oz = int.parse(json['oz']);
      oz = oz.sign - (oz % 3);
    }
    return ItemModel(
      id: withNewIds ? ItemTools().newId : json['id'] ?? ItemTools().newId,
      nm: json['nm'],
      vl: json['vl'] ?? "",
      op: json['op'] ?? oz,
      nb: json['nb'] ?? "",
      children: childList,
    );
  }

  static const String endDataSeparator = "≥";
  static final String nullCharacter = String.fromCharCode(0);
  static const String separator = "\n"; // String.fromCharCode(0xa);
  static const String startDataSeparator = "≤";

  ItemTools get itemTools => ItemTools();

  // Methods
  void addChild(ItemModel newChild) {
    children.add(newChild);
  }

  @override
  String toString() {
    return this.nm +
        (this.vl.isNotEmpty ? separator + this.vl : "") +
        (this.nb.isNotEmpty ? separator + this.nb : "");
  }

  String toSearchString() {
    return this.nm + startDataSeparator + this.vl + endDataSeparator + this.nb;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nm': nm,
        'vl': vl,
        'op': op,
        'nb': nb,
        'children': children,
      };

  // int compareTo(other) {
  //   return (this.toSortString().toLowerCase())
  //       .compareTo(other.toSortString().toLowerCase());
  // }

  String toSortString() {
    return this.nm +
        (this.vl.isNotEmpty ? separator + this.vl : nullCharacter) +
        (this.nb.isNotEmpty ? separator + this.nb : nullCharacter);
    // + (this.id.isNotEmpty ? separator + this.id : "");
  }

  void sortChildren() {
    if (children.isNotEmpty) {
      children.sort((a, b) => itemTools.sortNaturalIgnoreCase(a, b));
    }
  }
}
