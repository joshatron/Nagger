import 'dart:io';

import 'package:flutter/material.dart';

import 'nag.dart';
import 'nag_store.dart';
import 'new_edit_nag.dart';

class NagsPage extends StatefulWidget {
  NagsPage({Key key}) : super(key: key);

  @override
  _NagsPageState createState() => _NagsPageState();
}

class _NagsPageState extends State<NagsPage> {
  List<Nag> _nags = List();
  Nag _lastDeleted;
  int _lastDeletedIndex;
  NagStore nagsStore;

  _NagsPageState() {
    nagsStore = DatabaseNagStore();
  }

  _initializeNags() async {
    List<Nag> nags = await nagsStore.getNags();

    setState(() {
      _nags = nags;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_nags.isEmpty) {
      _initializeNags();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Nags')),
      body: ListView.separated(
        itemBuilder: (context, index) => _buildNagWidget(context, index),
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: _nags.length,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {_addNag(context);},
      ),
    );
  }

  Widget _buildNagWidget(BuildContext context, int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        if(direction == DismissDirection.startToEnd) {
          _removeNag(context, index);
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
  }

  void _addNag(BuildContext context) async {
    var newNag = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewEditNagScreen()));

    nagsStore.addNag(newNag);

    if(newNag != null) {
      setState(() {
        _nags.add(newNag);
      });
    }
  }

  void _editNag(BuildContext context, int index) async {
    var editedNag = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewEditNagScreen(nag: _nags[index])));

    nagsStore.updateNag(editedNag);

    setState(() {
      if(editedNag != null) {
        _nags[index] = editedNag;
      }
    });
  }

  void _removeNag(BuildContext context, int index) {
    nagsStore.deleteNag(_nags[index].id);

    setState(() {
      Scaffold.of(context).hideCurrentSnackBar();
      _lastDeleted = _nags[index];
      _lastDeletedIndex = index;
      _nags.removeAt(index);
    });

    Scaffold
        .of(context)
        .showSnackBar(SnackBar(
      content: Text(_lastDeleted.title + ' deleted'),
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
}
