import 'dart:async';

import 'package:qrreadapp/source/bloc/validator.dart';
import 'package:qrreadapp/source/providers/db_provider.dart';

/*  Se utiliza with para hacer un mixin con la clase Validators que 
    es similar a una herencia, pero la idea es que se pueden hacer más
    de un mixin a diferencia que la herencia es solo de una clase.
*/
class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  factory ScansBloc() {
    return _singleton;
  }

  ScansBloc._internal() {
    // Obtener scans de la base de datos.
    getAll();
  }

  final _scansController = StreamController<List<ScanModel>>.broadcast();

  Stream<List<ScanModel>> get streamGeo =>
      _scansController.stream.transform(validatorGeo);
  Stream<List<ScanModel>> get streamHttp =>
      _scansController.stream.transform(validatorHttp);

  dispose() {
    _scansController?.close();
  }

  Future<int> add(ScanModel scanModel) async {
    int result = await DBProvider.db.addScan(scanModel);
    getAll();
    return result;
  }

  void getAll() async {
    _scansController.sink.add(await DBProvider.db.getScans());
  }

  Future<int> delete(int id) async {
    int result = await DBProvider.db.deleteScan(id);
    getAll();
    return result;
  }

  Future<int> deleteAll() async {
    int result = await DBProvider.db.deleteAll();
    _scansController.sink.add([]);
    return result;
  }
}
