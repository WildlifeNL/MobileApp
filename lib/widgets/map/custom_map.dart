import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildlife_nl_app/widgets/map/custom_attribution_widget.dart';

class CustomMapController {
  late MapController controller;

  void _initWithState(_CustomMapState state) {
    controller = state.controller;
  }
}

class CustomMap extends StatefulWidget {
  const CustomMap({
    super.key,
    this.mapController,
  });

  final CustomMapController? mapController;

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  final MapController controller = MapController();

  @override
  void initState() {
    super.initState();
    widget.mapController?._initWithState(this);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        //Eindhoven as center for now
        center: const LatLng(51.44083, 5.47778),
        interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
      ),
      nonRotatedChildren: const [CustomAttributionWidget()],
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          fallbackUrl: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          maxZoom: 19,
          userAgentPackageName: "nl.wildlifeNL",
          evictErrorTileStrategy:
              EvictErrorTileStrategy.notVisibleRespectMargin,
        ),
      ],
    );
  }
}
