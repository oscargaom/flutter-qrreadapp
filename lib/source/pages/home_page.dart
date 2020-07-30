import 'dart:io';

import 'package:flutter/material.dart';
import 'package:qrreadapp/source/bloc/scans_bloc.dart';
import 'package:qrreadapp/source/models/scan_model.dart';
import 'package:qrreadapp/source/pages/direcciones_page.dart';
import 'package:qrreadapp/source/pages/mapas_page.dart';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:qrreadapp/source/utils/utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

  final ScansBloc scanStream = new ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () => {
              scanStream.deleteAll(),
            },
          ),
        ],
      ),
      body: Center(
        child: _callPage(currentIndex),
      ),
      bottomNavigationBar: _crearBottomNavigatorBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_center_focus),
        onPressed: () => _scanQR(context),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _crearBottomNavigatorBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => {
        setState(() => {currentIndex = index})
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.map),
          title: Text('Mapas'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.brightness_6),
          title: Text('Direcciones'),
        ),
      ],
    );
  }

  Widget _callPage(int pageNumber) {
    switch (pageNumber) {
      case 0:
        return MapasPage();
      case 1:
        return DireccionesPage();
      default:
        return MapasPage();
    }
  }

  _scanQR(BuildContext context) async {
    // https://dart.dev/samples
    // geo:19.209858747798886,-99.05202284296878
    // String futureString = "https://dart.dev/samples";
    String futureString = "";

    // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    // print('onTap scanQR');
    // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    try {
      ScanResult barcode = await BarcodeScanner.scan();
      futureString = barcode.rawContent;
    } catch (e) {
      futureString = null;
    }

    // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    // print(futureString);
    // print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');

    if (futureString != null) {
      ScanModel scanModel = new ScanModel(valor: futureString);
      scanStream.add(scanModel);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750),
            () => {utils.launchURLFromScanModel(context, scanModel)});
      } else {
        utils.launchURLFromScanModel(context, scanModel);
      }

      // futureString = "geo:19.209858747798886,-99.05202284296878";
      scanModel = new ScanModel(valor: futureString);
      scanStream.add(scanModel);
    }
  }
}
