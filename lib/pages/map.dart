import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/widgets/map/custom_map.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final controller = CustomMapController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      left: false,
      right: false,
      child: CustomMap(mapController: controller,),
    );
  }
}
