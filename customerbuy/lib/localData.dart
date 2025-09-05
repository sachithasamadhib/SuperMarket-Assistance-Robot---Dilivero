
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
class Localdata {
  Future<Database> openMyDatabase() async {
    final String path = join(await getDatabasesPath(), 'localData.db');
    print('Database Path: $path');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        print("Creating Table...");
        await db.execute(
          'CREATE TABLE cart('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'name TEXT NOT NULL, '
              'description TEXT NOT NULL, '
              'qty INTEGER NOT NULL, '
              'cartItemQuant INTEGER,'
              'price REAL NOT NULL, '
              'itemID INTEGER, '
              'imgLink TEXT NOT NULL'
              ')',
        );
      },
    );
  }

    Future<void> insertData(String name, String description, int qty,int cartQuant,double price,int itemID,String imgLink) async {
    final db = await openMyDatabase();
    db.insert(
        'cart',
        {
          'name': name,
          'description': description,
          'qty': qty,
          'cartItemQuant': cartQuant,
          'price': price,
          'itemID': itemID,
          'imgLink': imgLink
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> checkCart_withID(int itemID) async {
    final db = await openMyDatabase();
    return await db.query(
      'cart', // Table name
      where: 'itemID = ?', // WHERE clause
      whereArgs: [itemID], // Arguments for the placeholders
    );
  }
    Future<void> updateCartCount(int itemID,int newQuant) async {
    final db = await openMyDatabase();
    db.update(
        'cart',
        {
          'cartItemQuant': newQuant,
        },
        where: 'itemID = ?',
        whereArgs: [itemID]);
  }
  Future<void> maintainQuaries() async {
    final db = await openMyDatabase();
    await db.execute(
          'CREATE TABLE cart('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'name TEXT NOT NULL, '
              'description TEXT NOT NULL, '
              'qty INTEGER NOT NULL, '
              'cartItemQuant INTEGER,'
              'price REAL NOT NULL, '
              'itemID INTEGER, '
              'imgLink TEXT NOT NULL'
              ')',
        );
        // await db.rawDelete('DROP TABLE cart');
  }
   Future<void> removeCartItem(int itemID) async {
    final db = await openMyDatabase();
    db.delete('cart', where: 'itemID = ?', whereArgs: [itemID]);
  }
  //cart items selector
  Future<List<Map<String, dynamic>>> cartItemSelector() async {
    final db = await openMyDatabase();
    return await db.query(
      'cart'
    );
  }
  //  Future<void> updateTask(int id, bool status) async {
  //   final db = await openMyDatabase();
  //   db.update(
  //       'cancelledEvents',
  //       {
  //         'status': status ? 1 : 0,
  //       },
  //       where: 'id = ?',
  //       whereArgs: [id]);
  // }
  //   Future<List<Map<String, dynamic>>> getTasksUsingServiceID(String service_id_para) async { //use in the finishing screen
  //   final db = await openMyDatabase();
  //   return await db.query(
  //   'cancelledEvents', // Table name
  //   where: 'serviceID = ?', // WHERE clause
  //   whereArgs: [service_id_para], // Arguments for the placeholders
  // );
  // }

  //  Future<Database> createNewTable() async {
  //   return await openDatabase(
  //       join(await getDatabasesPath(), 'localData.db'),
  //       version: 1,
  //       onOpen: (db) {
  //     return db.execute(
  //       'CREATE TABLE cancelledEvents(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, serviceID TEXT, status  INTEGER)',
  //     );
  //   });
  // }

  // Future<void> insertSaveEvents(String service_id) async {
  //   final db = await openMyDatabase();
  //   db.insert(
  //       'savedEvents',
  //       {
  //         'serviceID': service_id,
  //       },
  //       conflictAlgorithm: ConflictAlgorithm.replace);
  // }
  //  Future<List<Map<String, dynamic>>> checkSavedData(String service_id_para) async { //use in the current work screen
  //   final db = await openMyDatabase();
  //   return await db.query(
  //   'savedEvents', // Table name
  //   where: 'serviceID = ?', // WHERE clause
  //   whereArgs: [service_id_para], // Arguments for the placeholders
  // );
  // }
  // Future<void> deleteSavedEvents(String service_para_id) async {
  //   final db = await openMyDatabase();
  //   db.delete('savedEvents', where: 'serviceID = ?', whereArgs: [service_para_id]);
  // }
  // Future<List<Map<String, dynamic>>> getSavedEvents() async {
  //   final db = await openMyDatabase();
  //   return await db.query(
  //   'savedEvents', // Table name
  // );
  // }

  //  Future<void> deleteAppData() async {
  //   final db = await openMyDatabase();
  //   db.delete('cancelledEvents');
  //   db.delete('savedEvents');
  //  }

  //  Future<List<Map<String, dynamic>>> checkTheSetting1(int id) async { //use in the current work screen
  //   final db = await openMyDatabase();
  //   return await db.query(
  //   'settings', // Table name
  //   where: 'id = ?', // WHERE clause
  //   whereArgs: [id], // Arguments for the placeholders
  // );
  // }
  // Future<List<Map<String, dynamic>>> getStoredAccInfo(int id) async { //use in the current work screen
  //   final db = await openMyDatabase();
  //   return await db.query(
  //   'accDetailsLocal', // Table name
  //   where: 'id = ?', // WHERE clause
  //   whereArgs: [id], // Arguments for the placeholders
  // );
  // }
  //  Future<void> updateLocalAccDetails(String us_name,String identification_no,int id) async {
  //   final db = await openMyDatabase();
  //   db.update(
  //       'accDetailsLocal',
  //       {
  //         'userName': us_name,
  //         'identificationNo' : identification_no
  //         //We use 1 for true and 0 for false.
  //       },
  //       where: 'id = ?',
  //       whereArgs: [id]);
  // }
  //  Future<void> updateSettings(int id,int status) async {
  //   final db = await openMyDatabase();
  //   db.update(
  //       'settings',
  //       {
  //         'status': status,
  //         //We use 1 for true and 0 for false.
  //       },
  //       where: 'id = ?',
  //       whereArgs: [id]);
  // }
}