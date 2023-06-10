import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const dbName = 'testing5.db';
  static const dbVersion = 1;
  static const dbUserDetails = 'user';
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
      $dbUserImageFilePath TEXT
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

  getPhoto(int id) async {
    Database? db = await instance.database;
    var maps =
        await db!.query(dbUserDetails, where: '$dbId=?', whereArgs: [id]);
    return maps;
  }

  //
  // Future<List<Map<String, dynamic>>> queryUserDetails() async {
  //   Database? db = await instance.database;
  //   return await db!.query(dbUserDetails);
  // }

  Future<int> deleteUserImage(String id) async {
    Database? db = await instance.database;
    return await db!.delete(dbUserDetails,
        where: '$dbUserImageFilePath=?', whereArgs: [id]);
  }

  Future<int> updateUserImage(int id, Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db!.update(dbUserDetails, row,
        where: '$dbUserImageFilePath=?', whereArgs: [id]);
  }

  Future close() async {
    var db = await instance.database;
    db!.close();
  }
}
