import 'package:flutter/material.dart';
import 'package:qrreadapp/source/bloc/scans_bloc.dart';
import 'package:qrreadapp/source/models/scan_model.dart';
import 'package:qrreadapp/source/utils/utils.dart' as utils;

class DireccionesPage extends StatelessWidget {
  final scanStream = ScansBloc();

  @override
  Widget build(BuildContext context) {
    scanStream.getAll();

    return StreamBuilder<List<ScanModel>>(
      stream: scanStream.streamHttp,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final scans = snapshot.data;

        if (scans.length == 0) {
          return Center(child: Text('No existen datos'));
        }

        return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (context, i) => Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) => scanStream.delete(scans[i].id),
                  child: ListTile(
                    leading: Icon(
                      Icons.cloud_queue,
                      color: Theme.of(context).primaryColor,
                    ),
                    title: Text(scans[i].valor),
                    subtitle: Text('ID: ${scans[i].id}'),
                    trailing: Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.grey,
                    ),
                    onTap: () =>
                        {utils.launchURLFromScanModel(context, scans[i])},
                  ),
                ));
      },
    );
  }
}
