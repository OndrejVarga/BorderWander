import 'package:borderwander/providers/data_fetcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';

class MapTerritory extends StatefulWidget {
  final List<dynamic> points;

  MapTerritory(this.points);

  @override
  _MapTerritoryState createState() => _MapTerritoryState();
}

class _MapTerritoryState extends State<MapTerritory> {
  MapController _controller = MapController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          shadowColor: Theme.of(context).backgroundColor,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
      ),
      body: FlutterMap(
        //MAP---------------------------------------------------------------
        mapController: _controller,
        options: MapOptions(
            rotationThreshold: 0,
            interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            zoom: 18,
            maxZoom: 18.0,
            minZoom: 2.0,
            center: Provider.of<DataFetcher>(context)
                .convertFromServerToLatLngPoints(widget.points)[0]),
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/borderwander/ckmwaymo91c3317mkz0zip3tv/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiYm9yZGVyd2FuZGVyIiwiYSI6ImNrbXc5bmF4dDBjd24yd216em84cGVlbjgifQ.VTqn0l5diQHc_RFU5mS0Zw',
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoiYm9yZGVyd2FuZGVyIiwiYSI6ImNrbXc5bmF4dDBjd24yd216em84cGVlbjgifQ.VTqn0l5diQHc_RFU5mS0Zw',
              'id': 'mapbox.mapbox-streets-v8',
            },
          ),
          //Territory Rendering--------------------------------------------
          PolygonLayerOptions(
            polygons: [
              Polygon(
                borderStrokeWidth: 5,
                borderColor: Color(Provider.of<DataFetcher>(context)
                    .currUserInformation['color']),
                points: Provider.of<DataFetcher>(context)
                    .convertFromServerToLatLngPoints(widget.points),
                color: Color(Provider.of<DataFetcher>(context)
                        .currUserInformation['color'])
                    .withOpacity(0.3),
              )
            ],
            polygonCulling: true,
          ),
        ],
      ),
    );
  }
}
