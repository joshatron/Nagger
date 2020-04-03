import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:uuid/uuid.dart';

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
      height: 130,
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
              child: Text('Beginning: ' + DateFormat().add_yMd().add_jm().format(widget.nag.start)),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text('Next: ' + DateFormat().add_yMd().add_jm().format(widget.nag.nextNag())),
          ),
        ],
      )
    );
  }
}

class Nag {
  String id;
  String title;
  int repeatAmount;
  RepeatUnit repeatUnit;
  DateTime start;
  DateTime _next;
  String question;
  AnswerType answerType;
  bool active;

  Nag(this.title, this.repeatAmount, this.repeatUnit, this.start, this.question, this.answerType, {this.id, this.active = true}) {
    if(id == null) {
      id = Uuid().v4();
    }
    _next = start;
  }

  DateTime nextNag() {
    var current = DateTime.now();
    while(_next.isBefore(current)) {
      _incrementNext();
    }

    return _next;
  }

  void _incrementNext() {
    switch(repeatUnit) {
      case RepeatUnit.seconds:
          _next = Jiffy(_next).add(seconds: repeatAmount);
          break;
      case RepeatUnit.minutes:
        _next = Jiffy(_next).add(minutes: repeatAmount);
        break;
      case RepeatUnit.hours:
        _next = Jiffy(_next).add(hours: repeatAmount);
        break;
      case RepeatUnit.days:
        _next = Jiffy(_next).add(days: repeatAmount);
        break;
      case RepeatUnit.weeks:
        _next = Jiffy(_next).add(weeks: repeatAmount);
        break;
      case RepeatUnit.months:
        _next = Jiffy(_next).add(months: repeatAmount);
        break;
      case RepeatUnit.years:
        _next = Jiffy(_next).add(years: repeatAmount);
        break;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'repeatAmount': repeatAmount,
      'repeatUnit': repeatUnit.index,
      'start': start.millisecondsSinceEpoch,
      'question': question,
      'answerType': answerType.index,
      'active': active ? 1 : 0,
    };
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