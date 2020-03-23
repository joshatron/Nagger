import 'package:flutter/material.dart';
import 'package:nagger/nag.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class NewNagScreen extends StatefulWidget {
  @override
  _NewNagState createState() => _NewNagState();
}

class _NewNagState extends State<NewNagScreen> {
  RepeatUnit _dropdownValue = RepeatUnit.minutes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Nag')),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            )
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
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
                    value: _dropdownValue,
                    onChanged: (RepeatUnit newValue) {
                      setState(() {
                        _dropdownValue = newValue;
                      });
                    },
                    items: RepeatUnit.values.map((RepeatUnit unit) {
                      return DropdownMenuItem<RepeatUnit>(
                        value: unit,
                        child: Text(unit.toString().split('.').last),
                      );
                    }).toList(),
                  )
                ),
              ],
            ),
          ),
          //TODO: Question and answer
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: DateTimeField(
              format: DateFormat().add_yMd().add_jm(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Start',
              ),
              onShowPicker: (context, currentValue) async {
                var date = await showDatePicker(
                    context: context,
                    initialDate: currentValue ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2200));
                var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()));

                return DateTimeField.combine(date, time);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: FlatButton(
              color: Colors.grey[300],
              child: Text('Create'),
              onPressed: () {
                Navigator.pop(context, new Nag(
                    name: 'Nag 1',
                    repeatAmount: 5,
                    repeatUnit: RepeatUnit.minutes,
                    start: DateTime.now(),
                    question: 'How are you doing?',
                    answerType: AnswerType.text,
                ));
              },
            )
          ),
        ],
      ),
    );
  }

}