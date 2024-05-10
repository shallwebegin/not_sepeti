// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:not_sepeti/models/kategori.dart';
import 'package:not_sepeti/models/notlar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  Future<Database?> _initializeDatabase() async {
    var lock = Lock();
    Database? _db;
    if (_db == null) {
      await lock.synchronized(() async {
        if (_db == null) {
          var databasePath = await getDatabasesPath();
          var path = join(databasePath, 'appDB.db');
          var file = File(path);

          if (!await file.exists()) {
            ByteData data = await rootBundle.load(join('assets', 'notlar.db'));
            List<int> bytes =
                data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await File(path).writeAsBytes(bytes);
          }
          _db = await openDatabase(path);
        }
      });
    }
    return _db;
  }

  Future<List<Kategori>> kategoriListesiniGetir() async {
    var kategorileriIcerenMapListesi = await kategorilerGetir();
    var kategoriListesi = <Kategori>[];
    for (Map<String, dynamic> map in kategorileriIcerenMapListesi) {
      kategoriListesi.add(Kategori.fromMap(map));
    }
    return kategoriListesi;
  }

  Future<List<Map<String, dynamic>>> kategorilerGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query('kategori');
    return sonuc;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('kategori', kategori.toMap());
    return sonuc;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase();
    var sonuc = await db.update('kategori', kategori.toMap(),
        where: 'kategoriID = ?', whereArgs: [kategori.kategoriID]);
    return sonuc;
  }

  Future<int> kategoriSil(int kategoriID) async {
    var db = await _getDatabase();
    var sonuc = await db
        .delete('kategori', where: 'kategoriID = ?', whereArgs: [kategoriID]);
    return sonuc;
  }

//////////////////////////////////////////////////////

  Future<List<Not>> notListesiniGetir() async {
    var notlarMapListesi = await notlariGetir();
    var notListesi = <Not>[];

    for (Map<String, dynamic> map in notlarMapListesi) {
      notListesi.add(Not.fromMap(map));
    }
    return notListesi;
  }

  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.rawQuery(
        "select * from 'not' inner join kategori on kategori.kategoriID = 'not'.kategoriID order by notID Desc; ");
    return sonuc;
  }

  Future<int> notGuncelle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db
        .update('not', not.toMap(), where: 'notID = ?', whereArgs: [not.notID]);

    return sonuc;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase();
    var sonuc = await db.delete('not', where: 'notID = ?', whereArgs: [notID]);

    return sonuc;
  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase();
    var sonuc = await db.insert('not', not.toMap());
    return sonuc;
  }
}
