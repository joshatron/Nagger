import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'nag.dart';
import 'new_edit_nag.dart';

abstract class NagStore {
  Future<List<Nag>> getNags();
  void addNag(Nag nag);
  void deleteNag(String nagId);
  void updateNag(Nag newNag);
}

class DatabaseNagStore implements NagStore {
  Future<Database> _database;

  Future<Database> _getDatabase() async {
    if(_database == null) {
      _database = _initDb();
    }

    return _database;
  }

  Future<Database> _initDb() async {
    return openDatabase(
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
    Database db = await _getDatabase();
    await db.insert('nags', nag.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> deleteNag(String nagId) async {
    Database db = await _getDatabase();
    await db.delete('nags', where: 'id = ?', whereArgs: [nagId]);
  }

  @override
  Future<List<Nag>> getNags() async {
    Database db = await _getDatabase();
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
    Database db = await _getDatabase();
    await db.update('nags', newNag.toMap(), where: 'id = ?', whereArgs: [newNag.id]);
  }
}

class MockStore implements NagStore {
  List<Nag> nags;

  MockStore() {
    nags = List();

    nags.add(new Nag("First", 10, RepeatUnit.hours, DateTime.now(), "How are you?", AnswerType.text));
    nags.add(new Nag("Second", 1, RepeatUnit.days, DateTime.now().subtract(Duration(days: 1, minutes: 1)), "Don't forget the thing", AnswerType.confirmation));
    nags.add(new Nag("Third", 1234567, RepeatUnit.seconds, DateTime.now().add(Duration(seconds: 30)), "How is your pain level?", AnswerType.scale10));
  }

  @override
  void addNag(Nag nag) {
    nags.add(nag);
  }

  @override
  void deleteNag(String nagId) {
    nags.removeAt(nags.indexWhere((element) => element.id == nagId));
  }

  @override
  Future<List<Nag>> getNags() {
    return new Future<List<Nag>>.value(nags);
  }

  @override
  void updateNag(Nag nag) {
    nags.insert(nags.indexWhere((element) => element.id == nag.id), nag);
  }
}
