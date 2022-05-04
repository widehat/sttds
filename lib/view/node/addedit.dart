import 'package:flutter/material.dart';
import 'package:sttds/utilities/choicelist.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/services/settings.dart';
import 'package:sttds/utilities/canvasbutton.dart';
import 'package:sttds/model/itemmodel.dart';
import 'package:sttds/utilities/appbuttonoption.dart';
import 'package:sttds/view/node/nodedatadropdown.dart';
import 'package:sttds/view/node/nodetitledropdown.dart';

class AddEdit {
  AddEdit({
    required this.node,
  });
  final ItemModel node;
}

/// This enumeration is for the action item buttons
enum MaskDataChoice {
  never,
  settings,
  always,
}

class MaskToggleButtonOption extends AppButtonOption {
  MaskToggleButtonOption({
    required this.action,
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
  final MaskDataChoice action;
}

class AddEditDialogBox extends StatefulWidget {
  AddEditDialogBox({
    Key? key,
    required this.nodePath,
    required this.itemId,
    required this.itemName,
    required this.itemValue,
    required this.showValue,
    required this.itemNote,
  }) :
        // initNode = JustData(id: nodeId, title: nodeTitle, data: nodeData, showValue: showValue, note: nodeNote, ),
        super(key: key);

  /// Defines the data associated with this node
  final String itemValue;

  /// Defines the id ofd the node. If this is null or empty it also
  /// defines whether or not the dialog is for a new node or editing an existing one
  /// nodeId == null or nodeId.isEmpty; creating a new node
  /// nodeId != null and nodeId.isNotEmpty; editing an existing node
  final String itemId;

  /// Defines the node's Note
  final String itemNote;

  /// Defines the path for the node, ie the series of node.title values for the parent,
  /// parent's parent, and so on. Equivalent to a file path.
  /// Excludes the leaf node title value.
  final String nodePath;

  /// Defines the node's title (this is required)
  final String itemName;

  /// Defines the setting for the node value.
  /// This value is either positive 0 or negative, typically +1, 0, -1.
  /// It is combined with the setting for default show data value.
  /// That is either
  /// 0: don't show,
  /// +1: do show
  /// if the sum of this value and the default value is grerater than zero then
  /// show the values otherwise hide them.
  final int showValue;

  // final JustData initNode;

  @override
  _AddEditDialogBoxState createState() => _AddEditDialogBoxState();
}

class _AddEditDialogBoxState extends State<AddEditDialogBox> {
  /// List of option style buttons
  /// The order of this list defines the order
  /// that the buttons are displayed
  final List<MaskToggleButtonOption> optionButtonList = [
    MaskToggleButtonOption(
      action: MaskDataChoice.settings,
      icon: Icon(FeatherIcons.settings),
      tooltip: "Use App Settings",
      text: "Default",
    ),
    MaskToggleButtonOption(
      action: MaskDataChoice.never,
      icon: Icon(FeatherIcons.eyeOff),
      tooltip: "Always mask data value",
      text: "always",
    ),
    MaskToggleButtonOption(
      action: MaskDataChoice.always,
      icon: Icon(FeatherIcons.eye),
      tooltip: "Always show data value",
      text: "never",
    ),
  ];

  /// header bar height
  final double headerHeight = 48.0;

  /// Divider
  final Widget divider = SizedBox(height: 10.0);

  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final double veryLargePadding = 20.0;
  final double largePadding = 10.0;
  final double smallPadding = 5.0;

  /// Defines form key
  final _formKey = GlobalKey<FormState>();

  /// Defines if dialog is for a new node or editing an existing node
  bool isNew = true;

  /// Application settings
  AppSettings get appSettings => AppSettings();

  /// node to store data being returned
  late ItemModel item;

  /// List to identifdy which toggle button has exclusive selection
  List<bool> isSelected = [false, false, false];

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final titleFieldController = TextEditingController();
  final dataFieldController = TextEditingController();
  final noteFieldController = TextEditingController();
  final FocusNode titleFieldFocusNode = FocusNode();
  final FocusNode dataFieldFocusNode = FocusNode();
  final FocusNode noteFieldFocusNode = FocusNode();

  List<ChoiceListItem> titleDropdownList = [];
  List<ChoiceListItem> dataDropdownList = [];

  @override
  void initState() {
    isNew = (widget.itemId == "*");

    item = ItemModel(
      id: widget.itemId, // this prevvents the constructor creating a random key
      nm: widget.itemName,
      vl: widget.itemValue,
      op: widget.showValue,
      nb: widget.itemNote,
    );

    titleFieldController.text = item.nm;
    dataFieldController.text = item.vl;
    noteFieldController.text = item.nb;

    // build the dropdown lists from AppSettings
    List<String> phrases;
    phrases = appSettings.titleShortcutList;
    for (int i = 0; i < phrases.length; i++) {
      titleDropdownList.add(ChoiceListItem(phrases[i], i));
    }
    phrases = appSettings.dataShortcutList;
    for (int i = 0; i < phrases.length; i++) {
      dataDropdownList.add(ChoiceListItem(phrases[i], i));
    }

    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] =
          (optionButtonList[i].action.index - 1 == widget.showValue);
      if (isSelected[i]) break;
    }

    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    titleFieldController.dispose();
    dataFieldController.dispose();
    noteFieldController.dispose();
    titleFieldFocusNode.dispose();
    dataFieldFocusNode.dispose();
    noteFieldFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(side: BorderSide.none),
      child: dialogBody,
    );
  }

  /// Dialog box main contents
  Widget get dialogBody {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          ListView(children: [
            SizedBox(
              height: headerHeight,
            ),
            pathInTree,
            divider,
            titleRow,
            divider,
            dataRow,
            divider,
            maskOptionsRow,
            divider,
            noteTextField,
          ]),
          topBanner,
        ],
      ),
    );
  }

  Widget get topBanner {
    return SizedBox(
      height: headerHeight,
      child: AppBar(
        primary: false,
        leading: closeButton,
        toolbarHeight: headerHeight,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: heading,
        actions: [
          saveButton,
        ],
      ),
    );
  }

  Widget get heading {
    return Text(
      isNew ? "New" : "Edit [${widget.itemName}]",
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget get closeButton {
    return CanvasButton(
      onTap: () => Navigator.of(context).pop(),
      icon: FeatherIcons.x,
      tooltip: "Cancel",
    );
  }

  Widget get saveButton {
    return CanvasButton(
      onTap: () => submitForm(),
      icon: FeatherIcons.check,
      tooltip: "Save",
    );
  }

  Widget get pathInTree {
    return widget.nodePath.isNotEmpty
        ? Padding(
            padding: EdgeInsets.only(
              left: veryLargePadding,
              right: veryLargePadding,
              bottom: smallPadding,
            ),
            child: Text(
              widget.nodePath,
              style: Theme.of(context).textTheme.caption,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          )
        : SizedBox(height: 0);
  }

  Widget get titleRow {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: dialogBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: largePadding * 2,
          right: largePadding,
        ),
        child: Row(children: [
          titleTextField,
          titleDropDown,
        ]),
      ),
    );
  }

  Widget get titleTextField {
    return Expanded(
      child: TextFormField(
        controller: titleFieldController,
        autocorrect: false,
        autofocus: true,
        focusNode: titleFieldFocusNode,
        onFieldSubmitted: (_) => dataFieldFocusNode.requestFocus(),
        decoration: InputDecoration(hintText: 'Title'),
        style: Theme.of(context).textTheme.subtitle1,
        textCapitalization: TextCapitalization.words,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter a title';
          }
          return null;
        },
      ),
    );
  }

  Widget get titleDropDown {
    return IconButton(
      onPressed: () => showTitleDropdownDialog(),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget get dataRow {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: dialogBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: largePadding * 2,
          right: largePadding,
        ),
        child: Row(children: [
          dataTextField,
          dataDropDown,
        ]),
      ),
    );
  }

  Widget get dataTextField {
    return Expanded(
      child: TextFormField(
        controller: dataFieldController,
        autofocus: false,
        focusNode: dataFieldFocusNode,
        onFieldSubmitted: (_) => noteFieldFocusNode.requestFocus(),
        autocorrect: false,
        enableSuggestions: true,
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(hintText: 'Data'),
        style: TextStyle(
          fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
          fontSize: Theme.of(context).textTheme.bodyText2!.fontSize,
        ),
      ),
    );
  }

  Widget get dataDropDown {
    return IconButton(
      onPressed: () => showDataDropdownDialog(),
      icon: Icon(
        Icons.arrow_drop_down,
        color: Theme.of(context).accentColor,
      ),
    );
  }

  Widget get maskOptionsRow {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: dialogBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: largePadding * 2,
          right: largePadding,
          top: largePadding,
          bottom: largePadding,
        ),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            maskOptionLabel,
            maskOptions,
          ],
        ),
      ),
    );
  }

  Widget get maskOptionLabel {
    String subLabel = "";
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        subLabel = optionButtonList[i].tooltip;
        break;
      }
    }
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Mask data value?",
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.bodyText1!.fontFamily,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          subLabel,
          style: TextStyle(
            fontFamily: Theme.of(context).textTheme.caption!.fontFamily,
            fontSize: Theme.of(context).textTheme.caption!.fontSize,
            fontWeight: FontWeight.w400,
            color: Theme.of(context).accentColor,
          ),
        ),
      ]),
    );
  }

  Widget get maskOptions {
    return ToggleButtons(
      onPressed: (int index) {
        setState(() {
          for (int buttonIndex = 0;
              buttonIndex < isSelected.length;
              buttonIndex++) {
            if (buttonIndex == index) {
              isSelected[buttonIndex] = true;
            } else {
              isSelected[buttonIndex] = false;
            }
          }
        });
      },
      borderRadius: dialogBorderRadius,
      isSelected: isSelected,
      children: optionButtonList.asMap().entries.map((entry) {
        return Tooltip(
          message: entry.value.tooltip,
          child: entry.value.icon,
        );
      }).toList(),
    );
  }

  Widget get noteTextField {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: dialogBorderRadius,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: largePadding * 2,
          right: smallPadding,
          top: largePadding,
          bottom: largePadding,
        ),
        child: TextFormField(
          controller: noteFieldController,
          autofocus: false,
          focusNode: noteFieldFocusNode,
          onFieldSubmitted: (_) => titleFieldFocusNode.requestFocus(),
          decoration: InputDecoration(hintText: 'Note'),
          style: Theme.of(context).textTheme.subtitle1,
          textCapitalization: TextCapitalization.sentences,
          autocorrect: false,
          enableSuggestions: true,
          maxLines: null,
        ),
      ),
    );
  }

  Future<void> showTitleDropdownDialog() async {
    // show dialog
    return showDialog<ChoiceListItem>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return NodeTitleDropdownDialogBox(
            predefinedChoiceList: titleDropdownList,
          );
        }).then((val) {
      if (val == null) return;
      titleFieldController.text = val.displayText;
    });
  }

  Future<void> showDataDropdownDialog() async {
    // show dialog
    return showDialog<ChoiceListItem>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return NodeDataDropdownDialogBox(
            predefinedChoiceList: dataDropdownList,
          );
        }).then((val) {
      if (val == null) return;
      // setState(() {
      // NB the AppSnackBar won't show while there's a DialogBox on teh screen becasue it's using
      // the Scaffold's key not the dialog box's
      dataFieldController.text = val.displayText;
      // });
    });
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      item.nm = titleFieldController.text;
      item.vl = dataFieldController.text;
      item.op = optionButtonList[isSelected.indexWhere((element) => element)]
              .action
              .index -
          1;
      item.nb = noteFieldController.text;

      // compare before and after...
      if (widget.itemName == item.nm &&
          widget.itemValue == item.vl &&
          widget.showValue == item.op &&
          widget.itemNote == item.nb) {
        // nothing has changed so just cancel
        Navigator.of(context).pop();
      } else {
        // something has changed
        Navigator.of(context).pop(item);
      }
    }
  }
}
