import 'dart:developer';

import 'package:maybank_todo/model/database/data.dart';
import 'package:maybank_todo/model/to_do_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
  late Database _database;
  static final DatabaseController db = DatabaseController._();

  DatabaseController._();

  List<Data> dbList = [ToDoModel()];

  Database getDb() {
    return _database;
  }

  initialize(String dbName, int dbVersion) async {
    _database = await _initializeDB(dbName, dbVersion);
    log((_database == null)
        ? "Database failed to initialize"
        : "Database is initialized");
  }

  Future<Database> _initializeDB(String dbName, int dbVersion) async {
    String path = await getDatabasesPath();
    return openDatabase(join(path, "$dbName.db"),
        onCreate: (database, version) async {
      for (var item in createQuery()) {
        await database.execute(item);
      }
    }, onUpgrade: (database, oldVersion, newVersion) async {
      for (var item in dropQuery()) {
        await database.execute(item);
      }
      for (var item in createQuery()) {
        await database.execute(item);
      }
    }, version: dbVersion);
  }

  List<String> createQuery() {
    var test = dbList.map((e) => e.createQuery).toList();
    return test;
  }

  List<String> dropQuery() {
    return dbList.map((e) => e.dropQuery).toList();
  }
}
