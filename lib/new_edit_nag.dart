import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nagger/nag.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class NewEditNagScreen extends StatefulWidget {
  final Nag nag;

  NewEditNagScreen({Key key, this.nag}) : super(key: key);

  @override
  _NewEditNagState createState() => _NewEditNagState();
}

class _NewEditNagState extends State<NewEditNagScreen> {
  TextEditingController _titleController;
  TextEditingController _repeatController;
  TextEditingController _questionController;
  FocusNode _titleFocus;
  FocusNode _repeatFocus;
  FocusNode _questionFocus;

  RepeatUnit _currentRepeat;
  AnswerType _currentAnswer;
  DateTime _currentStart;

  initialize() {
    if(widget.nag == null) {
      _titleController = TextEditingController();
      _repeatController = TextEditingController();
      _questionController = TextEditingController();
      _titleFocus = FocusNode();
      _repeatFocus = FocusNode();
      _questionFocus = FocusNode();
      _currentRepeat = RepeatUnit.minutes;
      _currentAnswer = AnswerType.confirmation;
      _currentStart = DateTime.now();
    }
    else {
      _titleController = TextEditingController(text: widget.nag.name);
      _repeatController = TextEditingController(text: widget.nag.repeatAmount.toString());
      _questionController = TextEditingController(text: widget.nag.question);
      _titleFocus = FocusNode();
      _repeatFocus = FocusNode();
      _questionFocus = FocusNode();
      _currentRepeat = widget.nag.repeatUnit;
      _currentAnswer = widget.nag.answerType;
      _currentStart = widget.nag.start;
    }
  }

  _fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    initialize();
    return Scaffold(
      appBar: AppBar(title: Text('New Nag')),
      body: Column(
        children: <Widget>[
          Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextField(
                controller: _titleController,
                focusNode: _titleFocus,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {_fieldFocusChange(context, _titleFocus, _repeatFocus);},
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                ),
              )),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _repeatController,
                    focusNode: _repeatFocus,
                    textInputAction: TextInputAction.next,
                    onEditingComplete: () {_fieldFocusChange(context, _repeatFocus, _questionFocus);},
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Repeat',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: DropdownButton(
                      value: _currentRepeat,
                      onChanged: (RepeatUnit newValue) {
                        setState(() {
                          _currentRepeat = newValue;
                        });
                      },
                      items: RepeatUnit.values.map((RepeatUnit unit) {
                        return DropdownMenuItem<RepeatUnit>(
                          value: unit,
                          child: Text(unit.toString().split('.').last),
                        );
                      }).toList(),
                    )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _questionController,
                    focusNode: _questionFocus,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Question',
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: DropdownButton(
                      value: _currentAnswer,
                      onChanged: (AnswerType newValue) {
                        setState(() {
                          _currentAnswer = newValue;
                        });
                      },
                      items: AnswerType.values.map((AnswerType type) {
                        return DropdownMenuItem<AnswerType>(
                          value: type,
                          child: Text(printAnswerType(type)),
                        );
                      }).toList(),
                    )),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: DateTimeField(
              format: DateFormat().add_yMd().add_jm(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Start',
              ),
              initialValue: _currentStart,
              onShowPicker: (context, currentValue) async {
                var date = await showDatePicker(
                    context: context,
                    initialDate: currentValue ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200));
                if(date != null) {
                  var time = await showTimePicker(
                      context: context,
                      initialTime:
                      TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));

                  return DateTimeField.combine(date, time);
                }
                return currentValue;
              },
              onChanged: (date) {
                setState(() {
                  _currentStart = date;
                });
              },
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: FlatButton(
                color: Colors.grey[300],
                child: Text(widget.nag == null ? 'Create' : 'Save'),
                onPressed: () {
                  Navigator.pop(
                      context,
                      new Nag(_titleController.text, int.parse(_repeatController.text), _currentRepeat,
                        _currentStart, _questionController.text, _currentAnswer,));
                },
              )),
        ],
      ),
    );
  }
}