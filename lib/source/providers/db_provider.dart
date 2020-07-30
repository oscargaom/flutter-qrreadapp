import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qrreadapp/source/models/scan_model.dart';
export 'package:qrreadapp/source/models/scan_model.dart';

class DBProvider {
  static Database _database;

  static final DBProvider db = new DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    return initDB();
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'ScansDB.db');

    return openDatabase(
      path,
      version: 1,
      onOpen: (db) => {},
      onCreate: (Database db, int version) async {
        await db.execute('CREATE Table Scans('
            'id INTEGER PRIMARY KEY, '
            'tipo TEXT, '
            'valor TEXT '
            ')');
      },
    );
  }

  Future<int> addScanRaw(ScanModel scanModel) async {
    final db = await database;

    final resp = await db.rawInsert("INSERT INTO Scans(tipo, valor) "
        "values ('${scanModel.tipo}', '${scanModel.valor}')");

    return resp;
  }

  Future<int> addScan(ScanModel scanModel) async {
    final db = await database;

    final resp = await db.insert('Scans', scanModel.toJson());

    return resp;
  }

  Future<ScanModel> getScanById(int id) async {
    final db = await database;

    final resp = await db.query('Scans', where: 'id=?', whereArgs: [id]);

    return resp.isNotEmpty ? ScanModel.fromJson(resp.first) : null;
  }

  List<ScanModel> getResponseAsScanModel(List<Map<String, dynamic>> resp) {
    final List<ScanModel> scans =
        resp.isNotEmpty ? resp.map((e) => ScanModel.fromJson(e)).toList() : [];

    return scans;
  }

  Future<List<ScanModel>> getScans() async {
    final db = await database;

    final resp = await db.query('Scans');

    return getResponseAsScanModel(resp);
  }

  Future<List<ScanModel>> getScanByTipo(String tipo) async {
    final db = await database;

    final resp = await db.rawQuery("SELECT * FROM Scans WHERE tipo='$tipo'");

    return getResponseAsScanModel(resp);
  }

  Future<int> updateScan(ScanModel scanModel) async {
    final db = await database;

    return db.update('Scans', scanModel.toJson(),
        where: 'id=?', whereArgs: [scanModel.id]);
  }

  Future<int> deleteScan(int id) async {
    final db = await database;

    return db.delete('Scans', where: "id=?", whereArgs: [id]);
  }

  Future<int> deleteAll() async {
    final db = await database;

    return db.rawDelete("DELETE FROM Scans");
  }
}
