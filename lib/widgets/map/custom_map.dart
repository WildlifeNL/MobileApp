import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:wildlife_nl_app/models/before_merge/data/incident.dart';
import 'package:wildlife_nl_app/models/before_merge/data/sighting.dart';
import 'package:wildlife_nl_app/pages/activity.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/widgets/base_modal.dart';
import 'package:wildlife_nl_app/widgets/map/custom_attribution_widget.dart';
import 'package:wildlife_nl_app/widgets/map/custom_map_marker.dart';
import 'package:wildlife_nl_app/widgets/registration/add_registration_modal.dart';

class CustomMapController {
  late MapController controller;

  void _initWithState(_CustomMapState state) {
    controller = state.controller;
  }
}

class CustomMap extends ConsumerStatefulWidget {
  const CustomMap({
    super.key,
    this.mapController,
  });

  final CustomMapController? mapController;

  @override
  ConsumerState<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends ConsumerState<CustomMap> {
  final MapController controller = MapController();

  @override
  void initState() {
    super.initState();
    widget.mapController?._initWithState(this);
  }

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activitiesProvider);

    var markers = <Marker?>[];

    if (activities.hasValue) {
      markers = activities.value?.map((e) {
            switch (e) {
              case Incident item:
                return Marker(
                    builder: (ctx) => const IncidentMapMarker(),
                    point: LatLng(item.location.coordinates.first,
                        item.location.coordinates.last));
              case Sighting item:
                return Marker(
                    builder: (ctx) => const SightingMapMarker(),
                    point: LatLng(item.location.coordinates.first,
                        item.location.coordinates.last));
            }
            return null;
          }).toList() ??
          [];
    }

    List<Marker> nonNullMarkers =
        markers.where((element) => element != null).map((e) => e!).toList();

    return Stack(
      children: [
        FlutterMap(
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
            MarkerLayer(
              markers: nonNullMarkers,
            )
          ],
        ),
        Positioned(
          right: 0,
          bottom: 270,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => const AddRegistrationModal(),
                    );
                  },
                  icon: const Icon(
                    AppIcons.add,
                    color: AppColors.neutral_50,
                    size: 26,
                  ),
                ),
                // Container(
                //   height: 1,
                //   width: 24,
                //   color: AppColors.neutral_50,
                // ),
                // IconButton(
                //   onPressed: () {
                //
                //   },
                //   icon: const Icon(
                //     AppIcons.incident,
                //     color: AppColors.neutral_50,
                //     size: 26,
                //   ),
                // ),
                // Container(
                //   height: 1,
                //   width: 24,
                //   color: AppColors.neutral_50,
                // ),
                // IconButton(
                //   onPressed: () {
                //
                //   },
                //   icon: const Icon(
                //     AppIcons.settings,
                //     color: AppColors.neutral_50,
                //     size: 26,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
