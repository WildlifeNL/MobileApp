import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:wildlife_nl_app/state/location.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/widgets/map_marker.dart';
import 'package:wildlife_nl_app/widgets/map_settings_modal.dart';

import '../utilities/app_icons.dart';

part 'map.g.dart';

@riverpod
class MapStyle extends _$MapStyle {
  @override
  Future<Style> build() async {
    return await StyleReader(
      uri:
          'https://api.mapbox.com/styles/v1/daankleinen/clozqxy6v00ga01qj2j6g84wt?access_token=pk.eyJ1IjoiZGFhbmtsZWluZW4iLCJhIjoiY2t4MzFwMTJxMGo2bTJ1bzFncjV6YmJ6ayJ9.FY0BF_wgag5wFw-2dWSLGQ',
    ).read();
  }
}

class Map extends ConsumerStatefulWidget {
  const Map({super.key});

  @override
  ConsumerState<Map> createState() => _MapState();
}

class _MapState extends ConsumerState<Map> {
  final MapController _controller = MapController();
  late FollowOnLocationUpdate _followOnLocationUpdate;
  bool _switchValue = true;

  @override
  Widget build(BuildContext context) {
    var style = ref.watch(mapStyleProvider);
    var location = ref.watch(currentLocationProvider);

    if (style.isLoading || location.isLoading) {
      return Placeholder();
    }

    return Scaffold(
      body: FlutterMap(
          mapController: _controller,
          options: MapOptions(
              center: !location.isLoading && location.value?.longitude != null
                  ? LatLng(
                      location.value!.latitude!, location.value!.longitude!)
                  : LatLng(51, 5),
              zoom: 17,
              maxZoom: 22,
              interactiveFlags: InteractiveFlag.drag |
                  InteractiveFlag.flingAnimation |
                  InteractiveFlag.pinchMove |
                  InteractiveFlag.pinchZoom |
                  InteractiveFlag.doubleTapZoom),
          children: [
            // normally you would see TileLayer which provides raster tiles
            // instead this vector tile layer replaces the standard tile layer
            VectorTileLayer(
                theme: style.value!.theme,
                sprites: style.value!.sprites,
                tileOffset: TileOffset.mapbox,
                tileProviders: style.value!.providers),

            CurrentLocationLayer(
              turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
              style: LocationMarkerStyle(
                marker: const DefaultLocationMarker(
                  child: Icon(
                    Icons.navigation,
                    color: Colors.white,
                  ),
                ),
                markerSize: const Size(40, 40),
                markerDirection: MarkerDirection.heading,
              ),
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 32,
                  height: 32,
                  point: LatLng(51.45034, 5.45285),
                  builder: (ctx) => MapMarker(
                    markerType: 3,
                  ),
                  rotate: false,
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.only(top: 200),
                    child: Wrap(children: <Widget>[
                      Container(
                        width: 50,
                        decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            )),
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _controller.move(
                                      !location.isLoading &&
                                              location.value?.longitude != null
                                          ? LatLng(location.value!.latitude!,
                                              location.value!.longitude!)
                                          : LatLng(51.45034, 5.45285),
                                      17.0);
                                },
                                icon: Icon(AppIcons.person,
                                    color: AppColors.neutral_50)),
                            Divider(
                              height: 1,
                              color: AppColors.neutral_50,
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return Wrap(children: [MapSettingModal()]);
                                    },
                                  );
                                },
                                icon: Icon(AppIcons.pen,
                                    color: AppColors.neutral_50)),
                            Divider(
                              height: 1,
                              color: AppColors.neutral_50,
                            ),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(AppIcons.settings,
                                    color: AppColors.neutral_50))
                          ],
                        ),
                      ),
                    ]))),
          ]),
    );
  }
}
