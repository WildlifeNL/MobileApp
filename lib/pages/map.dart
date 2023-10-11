import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  MapPage({super.key});

  final MapController controller = MapController();

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      left: false,
      right: false,
      child: FlutterMap(
          mapController: widget.controller,
          options: MapOptions(
            //Eindhoven as center for now
            center: const LatLng(51.44083, 5.47778),
            interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
          nonRotatedChildren: const [
            RichAttributionWidget(attributions: [
              TextSourceAttribution("OpenStreetMap contributors"),
            ])
          ],
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              fallbackUrl:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              maxZoom: 19,
              userAgentPackageName: "nl.wildlifeNL",
              evictErrorTileStrategy: EvictErrorTileStrategy.notVisibleRespectMargin,
            ),
          ],
      ),
    );
  }
}
