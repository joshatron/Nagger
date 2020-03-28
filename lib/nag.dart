import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NagWidget extends StatefulWidget {
  final Nag nag;

  NagWidget({Key key, @required this.nag}) : super(key: key);

  @override
  _NagWidgetState createState() => _NagWidgetState();
}

class _NagWidgetState extends State<NagWidget> {
  bool _collapsed = true;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _toggleCollapsed,
      child: _collapsed ? _buildCollapsed() : _buildExpanded(),
    );
  }

  void _toggleCollapsed() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }

  Widget _buildCollapsed() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(widget.nag.title)),
          Text(printRepeat(widget.nag.repeatAmount, widget.nag.repeatUnit)),
          Switch(value: widget.nag.active, onChanged: _setActive,),
        ],
      ),
    );
  }

  void _setActive(bool newValue) {
    setState(() {
      widget.nag.active = newValue;
    });
  }

  Widget _buildExpanded() {
    return Container(
      height: 110,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildCollapsed(),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Question: ' + widget.nag.question),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Answer Type: ' + printAnswerType(widget.nag.answerType)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Starting ' + DateFormat().add_yMd().add_jm().format(widget.nag.start)),
          ),
        ],
      )
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

  DateTime nextNag(DateTime current) {
    DateTime temp = start;
    while(temp.isBefore(current)) {
      temp = _increment(temp);
    }

    return temp;
  }

  DateTime _increment(DateTime time) {
    switch(repeatUnit) {
      case RepeatUnit.seconds:
          return time.add(Duration(seconds: repeatAmount));
      case RepeatUnit.minutes:
        return time.add(Duration(minutes: repeatAmount));
      case RepeatUnit.hours:
        return time.add(Duration(hours: repeatAmount));
      case RepeatUnit.days:
        return time.add(Duration(days: repeatAmount));
      case RepeatUnit.weeks:
        return time.add(Duration(days: (repeatAmount * 7)));
      case RepeatUnit.months:
        return time.add(Duration(days: (repeatAmount * 30)));
      case RepeatUnit.years:
        return time.add(Duration(days: (repeatAmount * 365)));
    }

    return time;
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