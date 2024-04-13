import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

//How will the color look like on map

class MapPreview extends StatelessWidget {
  final Color color;
  MapPreview(this.color);

  @override
  Widget build(BuildContext context) {
    Polygon pol = Polygon(points: [
      LatLng(48.68806662324918, 21.286615532170597),
      LatLng(48.6886983, 21.2876),
      LatLng(48.6880983, 21.2883983),
      LatLng(48.6873, 21.2869983)
    ], color: color.withOpacity(0.3));
    return Container(
      height: 200,
      margin: const EdgeInsets.only(left: 30, right: 30, top: 30),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).cardColor),
      child: FlutterMap(
        options: MapOptions(
          interactive: false,
          center: LatLng(48.687975, 21.2874883),
          zoom: 16,
        ),
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
          PolygonLayerOptions(polygons: [pol]),
        ],
      ),
    );
  }
}
