import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wildlife_nl_app/pages/activity.dart';
import 'package:wildlife_nl_app/widgets/map/custom_map.dart';

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final controller = CustomMapController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      top: false,
      left: false,
      right: false,
      child: CustomMap(
        mapController: controller,
      ),
    );
  }
}
