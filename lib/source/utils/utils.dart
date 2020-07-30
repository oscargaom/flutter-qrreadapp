import 'package:flutter/material.dart';
import 'package:qrreadapp/source/models/scan_model.dart';
import 'package:url_launcher/url_launcher.dart';

launchURLFromScanModel(BuildContext context, ScanModel scanModel) async {
  if (scanModel?.tipo == "http") {
    if (await canLaunch(scanModel.valor)) {
      await launch(scanModel.valor);
    } else {
      throw 'Could not launch {$scanModel.valor}';
    }
  } else {
    Navigator.pushNamed(context, 'mapa', arguments: scanModel);
  }
}
