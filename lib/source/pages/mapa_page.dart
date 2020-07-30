import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qrreadapp/source/models/scan_model.dart';

class MapaPage extends StatefulWidget {
  @override
  _MapaPageState createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  /*  Con MapController podemos mover regresar a la posición original o punto 
      de partida del mapa una vez que comenzamos a navegar sobre el mapa. 
  */
  final mapController = new MapController();

  String mapMode = "satellite-v9";

  int indexMap = 0;

  @override
  Widget build(BuildContext context) {
    /*  Mediante ModalRoute se obtiene el objeto que es enviado como parámetro a través 
        del llamado que se hace a Navigator.pushNamed(context, 'mapa', arguments: scanModel)
    */
    final ScanModel scanModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Coordenadas QR'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              mapController.move(scanModel.getLatLng(), 15);
            },
          ),
        ],
      ),
      body: _crearFlutterMap(scanModel),
      floatingActionButton: _mapModeFloatingActionButton(context),
    );
  }

  Widget _crearFlutterMap(ScanModel scanModel) {
    // print('_crearFlutterMap $mapMode $indexMap');
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        center: scanModel.getLatLng(),
        zoom: 15,
      ),
      layers: [
        _crearMapa(),
        _crearMarcador(scanModel),
      ],
    );
  }

  TileLayerOptions _crearMapa() {
    return TileLayerOptions(
        urlTemplate: 'https://api.mapbox.com/styles/v1/'
            '{id}/tiles/{z}/{x}/{y}@2x?access_token={accessToken}',
        additionalOptions: {
          'accessToken':
              'pk.eyJ1Ijoib3NjYXJnYW9tIiwiYSI6ImNrZDNidzk4MTB4emIyc3J5Y2xlNGdmdTEifQ.RSija6AElHOM1uizmasFmQ',
          'id': 'mapbox/$mapMode'
          //'id': 'mapbox.streets'
          //'id': 'mapbox.$tipoMapa'
          // 'id': { mapbox/streets-v11, mapbox/outdoors-v11, mapbox/light-v10, mapbox/dark-v10, mapbox/satellite-v9, mapbox/satellite-streets-v11 }
        });
  }

  MarkerLayerOptions _crearMarcador(ScanModel scanModel) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
            width: 100,
            height: 100,
            point: scanModel.getLatLng(),
            builder: (context) => Container(
                  //color: Colors.red,
                  child: Icon(
                    Icons.location_on,
                    size: 70,
                    color: Theme.of(context).primaryColor,
                  ),
                ))
      ],
    );
  }

  String getMapMode() {
    List<String> modes = [
      "streets-v11",
      "outdoors-v11",
      "light-v10",
      "dark-v10",
      "satellite-v9",
      "satellite-streets-v11"
    ];

    if (indexMap < 0 || indexMap >= modes.length) {
      indexMap = 0;
    }

    return modes.elementAt(indexMap++);
  }

  Widget _mapModeFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        mapMode = getMapMode();
        // print(indexMap);
        // print(mapMode);
        setState(() {});
      },
    );
  }
}
