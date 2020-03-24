import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'nag.dart';
import 'new_edit_nag.dart';

class NagsPage extends StatefulWidget {
  NagsPage({Key key}) : super(key: key);

  @override
  _NagsPageState createState() => _NagsPageState();
}

class _NagsPageState extends State<NagsPage> {
  List<Nag> _nags = List<Nag>();
  Nag _lastDeleted;
  int _lastDeletedIndex;

  void _addNag(BuildContext context) async {
    var newNag = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewEditNagScreen()));

    if(newNag != null) {
      setState(() {
        _nags.add(newNag);
      });
    }
  }

  void _editNag(BuildContext context, int index) async {
    var editedNag = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewEditNagScreen(nag: _nags[index])));

    setState(() {
      if(editedNag != null) {
        _nags.removeAt(index);
        _nags.insert(index, editedNag);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nags')),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(_nags[index].name + ' ' + Uuid().v4()),
            onDismissed: (direction) {
              if(direction == DismissDirection.startToEnd) {
                setState(() {
                  Scaffold.of(context).hideCurrentSnackBar();
                  _lastDeleted = _nags[index];
                  _lastDeletedIndex = index;
                  _nags.removeAt(index);
                });

                Scaffold
                    .of(context)
                    .showSnackBar(SnackBar(
                  content: Text(_lastDeleted.name + ' deleted'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      setState(() {
                        _nags.insert(_lastDeletedIndex, _lastDeleted);
                        Scaffold.of(context).hideCurrentSnackBar();
                      });
                    },
                  ),
                ));
              }
              else {
                _editNag(context, index);
              }
            },
            background: Container(
              alignment: AlignmentDirectional.centerStart, 
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              color: Colors.red, 
              child: Icon(Icons.delete),
            ),
            secondaryBackground: Container(
                alignment: AlignmentDirectional.centerEnd,
                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                color: Colors.grey,
                child: Icon(Icons.edit)
            ),
            child: NagWidget(nag: _nags[index]),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: _nags.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {_addNag(context);},
      ),
    );
  }
}
