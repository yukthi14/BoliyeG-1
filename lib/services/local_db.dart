import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const dbName = 'testing6.db';
  static const dbVersion = 1;
  static const dbUserDetails = 'user';
  static const dbMyUsers = 'userDetails';
  static const dbMyUsersTokens = 'userToken';
  static const dbPublicChats = 'publicChats';
  static const dbMessageToken = 'messageToken';
  static const dbTimeStamp = 'timeStamp';
  static const dbIsSender = 'isSender';
  static const dbMessage = 'message';
  static const dbMessageType = 'messageType';
  static const dbUserName = 'name';
  static const dbId = 'id';
  static const dbUserImageFilePath = 'photoName';
  static final DatabaseHelper instance = DatabaseHelper();
  static Database? _database;

  Future<Database?> get database async {
    _database ??= await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: dbVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    try {
      db.execute('''
      CREATE TABLE  $dbUserDetails (
      $dbId VARCHAR(2) PRIMARY KEY,
      $dbUserName TEXT,
      $dbUserImageFilePath TEXT
      )
      ''');

      db.execute('''
      CREATE TABLE  $dbMyUsers (
      $dbMyUsersTokens TEXT PRIMARY KEY,
      $dbUserName TEXT,
      $dbUserImageFilePath TEXT
      )
      ''');

      db.execute('''
      CREATE TABLE $dbPublicChats (
      $dbMessageToken TEXT,
      $dbTimeStamp TEXT,
      $dbMessage TEXT,
      $dbIsSender BOOLEAN,
      $dbMessageType VARCHAR(1),
      FOREIGN KEY($dbMessageToken) REFERENCES $dbMyUsers($dbMyUsersTokens) ON DELETE CASCADE
      )
      ''');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  insertUserDetails(Map<String, dynamic> row) async {
    try {
      Database? db = await instance.database;
      return await db!.insert(dbUserDetails, row);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  insertUsersDetails(Map<String, dynamic> row) async {
    try {
      Database? db = await instance.database;
      return await db!.insert(dbMyUsers, row);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  updateUsersDetails(String id, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!
        .update(dbMyUsers, row, where: '$dbMyUsersTokens=?', whereArgs: [id]);
  }

  Future<List<Map<String, Object?>>> queryRecord() async {
    Database? db = await instance.database;
    return await db!.query(dbMyUsers);
  }

  getPhoto(int id) async {
    Database? db = await instance.database;
    var maps =
        await db!.query(dbUserDetails, where: '$dbId=?', whereArgs: [id]);
    return maps;
  }

  Future<int> deleteUserImage(String id) async {
    Database? db = await instance.database;
    return await db!.delete(dbUserDetails,
        where: '$dbUserImageFilePath=?', whereArgs: [id]);
  }

  updateUserImage(int id, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!
        .update(dbUserDetails, row, where: '$dbId=?', whereArgs: [id]);
  }

  Future close() async {
    var db = await instance.database;
    db!.close();
  }
}
