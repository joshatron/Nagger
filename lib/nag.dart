import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Nag extends StatefulWidget {
  final String name;
  final int repeatAmount;
  final RepeatUnit repeatUnit;
  final DateTime start;
  final AnswerType answerType;

  Nag({Key key, @required this.name, @required this.repeatAmount, @required this.repeatUnit, @required this.start, this.answerType = AnswerType.confirmation}) : super(key: key);

  @override
  _NagState createState() => _NagState();
}

class _NagState extends State<Nag> {
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
          Expanded(child: Text(widget.name)),
          Text(printRepeat(widget.repeatAmount, widget.repeatUnit)),
        ],
      ),
    );
  }

  Widget buildExpanded() {
    return Container(
      height: 200,
      child: Center(child: Text(widget.name)),
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