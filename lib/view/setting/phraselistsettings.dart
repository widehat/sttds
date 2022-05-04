import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sttds/utilities/feathericons.dart';
import 'package:sttds/utilities/canvasbutton.dart';
import 'package:sttds/services/settings.dart';

class PhraseListSettingsDialogBox extends StatefulWidget {
  const PhraseListSettingsDialogBox({
    required this.phrases,
    required this.title,
  });

  /// Phrase list
  final List<String> phrases;
  final String title;

  @override
  _PhraseListSettingsDialogBoxState createState() =>
      _PhraseListSettingsDialogBoxState();
}

class _PhraseListSettingsDialogBoxState
    extends State<PhraseListSettingsDialogBox> {
  /// header bar height
  final double headerHeight = 48.0;

  /// Divider
  final Widget verticalDivider = SizedBox(height: 10.0);
  final Widget horizontalDivider = SizedBox(width: 10.0);

  /// Border Radius used extensively
  final dialogBorderRadius = BorderRadius.circular(24.0);

  /// Padding settings
  final double smallPadding = 5.0;
  final double largePadding = 10.0;
  final double veryLargePadding = 20.0;

  AppSettings get appSettings => AppSettings();

  final String removeMePhrase = "remove me";

  List<String> phraseList = [];
  List<TextEditingController> phraseControllerList = [];

  @override
  void initState() {
    // Initialise the list
    phraseList = widget.phrases;

    // Initialise the TextField controllers
    for (int i = 0; i < phraseList.length; i++) {
      phraseControllerList.add(TextEditingController());
      phraseControllerList[i].text = phraseList[i];
    }

    super.initState();
  }

  @override
  void dispose() {
    // Clean up any controllers when the widget is disposed.
    for (int i = 0; i < phraseControllerList.length; i++) {
      phraseControllerList[i].dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      child: dialogBody,
    );
  }

  /// Dialog box main contents
  Widget get dialogBody {
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(
          top: 58.0,
        ),
        child: ClipRRect(
          borderRadius: dialogBorderRadius,
          child: Material(
            child: SingleChildScrollView(
              child: Column(
                // shrinkWrap: true,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  phraseListEditor,
                  addButton,
                ],
              ),
            ),
          ),
        ),
      ),
      topBanner,
    ]);
  }

  /// Top banner. Comprises a title (left aligned) and a close button (right Aligned)
  Widget get topBanner {
    return SizedBox(
      height: headerHeight,
      child: AppBar(
        primary: false,
        leading: cancelButton,
        toolbarHeight: headerHeight,
        elevation: 0.0,
        titleSpacing: 0.0,
        title: heading,
        actions: [
          submitButton,
        ],
      ),
    );
  }

  Widget get cancelButton {
    return CanvasButton(
      onTap: () => Navigator.of(context).pop(),
      icon: FeatherIcons.x,
      tooltip: "Cancel",
    );
  }

  Widget get heading {
    return Text(
      widget.title,
      style: Theme.of(context).textTheme.headline6,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget get submitButton {
    return CanvasButton(
      onTap: () => submitList(),
      icon: FeatherIcons.check,
      tooltip: "Save",
    );
  }

  Widget get phraseListEditor {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: phraseList.length,
      itemBuilder: (BuildContext context, int index) {
        return Visibility(
          visible: phraseControllerList[index].text != removeMePhrase,
          child: Dismissible(
            key: Key(index.toString()),
            onDismissed: (direction) => removePhrase(index),
            direction: DismissDirection.endToStart,
            dismissThresholds: {
              DismissDirection.endToStart: 0.5,
            },
            background: deleteBackground,
            child: phrase(index),
          ),
        );
      },
    );
  }

  Widget phrase(int index) {
    return Container(
      padding: EdgeInsets.only(
        left: largePadding * 2,
        right: smallPadding,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).disabledColor.withOpacity(0.5),
            width: 1.0,
          ),
        ),
      ),
      constraints: BoxConstraints(minHeight: 48.0),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: phraseControllerList[index],
      ),
    );
  }

  Widget get deleteBackground {
    return Container(
      padding: EdgeInsets.only(
        right: largePadding + smallPadding,
      ),
      color: Theme.of(context).errorColor.withOpacity(0.4),
      alignment: Alignment.centerRight,
      child: Icon(
        FeatherIcons.trash2,
        color: Theme.of(context).errorColor,
      ),
    );
  }

  Widget get addButton {
    return SizedBox(
      height: 48.0,
      child: CanvasButton(
        onTap: () => addPhrase(),
        icon: FeatherIcons.plus,
      ),
    );
  }

  void removePhrase(int index) {
    setState(() {
      phraseControllerList[index].text = removeMePhrase;
    });
  }

  void addPhrase() {
    phraseList.add("New phrase");
    phraseControllerList.add(TextEditingController());
    setState(() {
      phraseControllerList[phraseControllerList.length - 1].text =
          phraseList[phraseList.length - 1];
    });
  }

  void submitList() {
    List<String> resultSet = [];
    for (int i = 0; i < phraseControllerList.length; i++) {
      if (phraseControllerList[i].text != removeMePhrase) {
        resultSet.add(phraseControllerList[i].text);
      }
    }
    resultSet.sort((a, b) => a.toUpperCase().compareTo(b.toLowerCase()));
    Navigator.pop(context, resultSet);
  }
}
