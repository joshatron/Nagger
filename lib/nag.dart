import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NagWidget extends StatefulWidget {
  final Nag nag;

  NagWidget({Key key, @required this.nag}) : super(key: key);

  @override
  _NagWidgetState createState() => _NagWidgetState();
}

class _NagWidgetState extends State<NagWidget> {
  bool _collapsed = true;

  void toggleCollapsed() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }

  Widget buildCollapsed() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(widget.nag.title)),
          Text(printRepeat(widget.nag.repeatAmount, widget.nag.repeatUnit)),
        ],
      ),
    );
  }

  Widget buildExpanded() {
    return Container(
      height: 200,
      child: Center(child: Text(widget.nag.title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggleCollapsed,
      child: _collapsed ? buildCollapsed() : buildExpanded(),
    );
  }
}

class Nag {
  String title;
  int repeatAmount;
  RepeatUnit repeatUnit;
  DateTime start;
  String question;
  AnswerType answerType;
  bool active;

  Nag(this.title, this.repeatAmount, this.repeatUnit, this.start, this.question, this.answerType, {this.active = true});
}

enum RepeatUnit {
  seconds,
  minutes,
  hours,
  days,
  weeks,
  months,
  years,
}

enum AnswerType {
  confirmation,
  yesno,
  text,
  scale5,
  scale10,
}

String printRepeat(int repeatAmount, RepeatUnit repeatUnit) {
  String enumStr = repeatUnit.toString().split('.').last;
  if(repeatAmount == 1) {
    return 'every ' + enumStr.substring(0, enumStr.length - 1);
  }
  return 'every ' + repeatAmount.toString() + ' ' + enumStr;
}

String printAnswerType(AnswerType answerType) {
  switch(answerType) {
    case AnswerType.confirmation:
      return 'Confirmation';
    case AnswerType.yesno:
      return 'Yes/No';
    case AnswerType.text:
      return 'Text';
    case AnswerType.scale5:
      return 'Rating 1-5';
    case AnswerType.scale10:
      return 'Scale 1-10';
  }

  return 'N/A';
}