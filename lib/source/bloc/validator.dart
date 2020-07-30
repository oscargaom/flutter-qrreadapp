import 'dart:async';

import 'package:qrreadapp/source/models/scan_model.dart';

class Validators {
  /*  El StreamTransformer va a recibir como entrada una lista de ScanModel 
      y como salida entregará una lista de ScanModel.
  */
  final validatorGeo =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
          handleData: (scans, eventSink) {
    eventSink.add(scans
        .where((scan) => scan.tipo.trim().toLowerCase() == "geo")
        .toList());
  });

  final validatorHttp =
      StreamTransformer<List<ScanModel>, List<ScanModel>>.fromHandlers(
    handleData: (data, sink) {
      sink.add(data
          .where((element) => element.tipo.trim().toLowerCase() == "http")
          .toList());
    },
  );
}
