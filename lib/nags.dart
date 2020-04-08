import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'nag.dart';
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
  Nags nagsStore;

  _NagsPageState() {
    nagsStore = DatabaseNags();
    _initializeNags();
  }

  _initializeNags() async {
    _nags = await nagsStore.getNags();
  }

  @override
  Widget build(BuildContext context) {
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

abstract class Nags {
  Future<List<Nag>> getNags();
  void addNag(Nag nag);
  void deleteNag(String nagId);
  void updateNag(Nag newNag);
}

class DatabaseNags implements Nags {
  Future<Database> _database;

  DatabaseNags() {
    _init();
    sleep(Duration(milliseconds: 5000));
  }
  
  Future<void> _init() async {
    _database = openDatabase(
      join(await getDatabasesPath(), 'nagger.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE nags(id TEXT PRIMARY KEY, title TEXT, repeatAmount INTEGER, repeatUnit INTEGER, start INTEGER, question TEXT, answerType INTEGER, active INTEGER)"
        );
      },
      version: 1,
    );
  }

  @override
  Future<void> addNag(Nag nag) async {
    Database db = await _database;
    await db.insert('nags', nag.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteNag(String nagId) async {
    Database db = await _database;
    await db.delete('nags', where: 'id = ?', whereArgs: [nagId]);
  }

  @override
  Future<List<Nag>> getNags() async {
    Database db = await _database;
    List<Map<String,dynamic>> maps = await db.query('nags');
    
    return List.generate(maps.length,
            (i) => Nag(
              maps[i]['title'],
              maps[i]['repeatAmount'],
              RepeatUnit.values[maps[i]['repeatUnit']],
              DateTime.fromMillisecondsSinceEpoch(maps[i]['start']),
              maps[i]['question'],
              AnswerType.values[maps[i]['answerType']],
              id: maps[i]['id'],
              active: maps[i]['active'] == 1 ? true : false,
            ));
  }

  @override
  Future<void> updateNag(Nag newNag) async {
    Database db = await _database;
    await db.update('nags', newNag.toMap(), where: 'id = ?', whereArgs: [newNag.id]);
  }
}
