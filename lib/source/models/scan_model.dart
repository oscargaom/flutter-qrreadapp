import 'package:latlong/latlong.dart';

class ScanModel {
  ScanModel({
    this.id,
    this.tipo,
    this.valor,
  }) {
    if (this.valor.contains('http')) {
      this.tipo = 'http';
    } else {
      this.tipo = 'geo';
    }
  }

  int id;
  String tipo;
  String valor;

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
      };

  LatLng getLatLng() {
    // geo:19.209858747798886,-99.05202284296878
    if (tipo == 'geo' && valor.length > 4) {
      List<String> geo = valor.substring(4).split(',');

      double lat = double.parse(geo[0]);
      double lng = double.parse(geo[1]);

      return LatLng(lat, lng);
    }

    return LatLng(0, 0);
  }
}
