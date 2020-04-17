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
