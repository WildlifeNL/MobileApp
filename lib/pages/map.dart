import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:wildlife_nl_app/models/animal.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/state/animal_types.dart';
import 'package:wildlife_nl_app/state/interaction_types.dart';
import 'package:wildlife_nl_app/state/interactions.dart';
import 'package:wildlife_nl_app/state/location.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/widgets/add_report/report_other_animal.dart';
import 'package:wildlife_nl_app/widgets/map/map_marker.dart';
import 'package:wildlife_nl_app/widgets/map/map_settings_modal.dart';

import '../utilities/app_icons.dart';

part 'map.freezed.dart';

part 'map.g.dart';

String mapURL =
    'https://api.mapbox.com/styles/v1/daankleinen/clq51lfjn004901pq4k3p320o?access_token=pk.eyJ1IjoiZGFhbmtsZWluZW4iLCJhIjoiY2t4MzFwMTJxMGo2bTJ1bzFncjV6YmJ6ayJ9.FY0BF_wgag5wFw-2dWSLGQ';

@Riverpod(keepAlive: true)
class MapStyle extends _$MapStyle {
  @override
  Future<Style> build() async {
    return await StyleReader(
      uri: mapURL,
    ).read();
  }
}

@riverpod
class Settings extends _$Settings {
  @override
  SettingState build() {
    return const SettingState(
      toggleSightings: true,
      toggleTraffic: true,
      toggleIncidents: true,
      toggleInappropriateBehaviour: true,
      toggleMaintenance: true,
      mapType: MapType.standard,
    );
  }

  setSightings(bool value) {
    state = state.copyWith(toggleSightings: value);
  }

  setTraffic(bool value) {
    state = state.copyWith(toggleTraffic: value);
  }

  setIncidents(bool value) {
    state = state.copyWith(toggleIncidents: value);
  }

  setInappropriateBehaviour(bool value) {
    state = state.copyWith(toggleInappropriateBehaviour: value);
  }

  setMaintenance(bool value) {
    state = state.copyWith(toggleMaintenance: value);
  }

  setMapType(MapType type) {
    state = state.copyWith(mapType: type);
  }
}

@freezed
class SettingState with _$SettingState {
  const factory SettingState({
    required bool toggleSightings,
    required bool toggleTraffic,
    required bool toggleIncidents,
    required bool toggleInappropriateBehaviour,
    required bool toggleMaintenance,
    required MapType mapType,
  }) = _SettingState;
}

extension SettingStateExt on SettingState {
  List<InteractionTypeKey> allowedTypes() {
    List<InteractionTypeKey> allowedTypes = [];

    if (toggleSightings) {
      allowedTypes.add(InteractionTypeKey.sighting);
    }
    if (toggleMaintenance) {
      allowedTypes.add(InteractionTypeKey.maintenance);
    }
    if (toggleInappropriateBehaviour) {
      allowedTypes.add(InteractionTypeKey.inappropriateBehaviour);
    }
    if (toggleIncidents) {
      allowedTypes.add(InteractionTypeKey.damage);
    }
    if (toggleTraffic) {
      allowedTypes.add(InteractionTypeKey.traffic);
    }

    return allowedTypes;
  }
}

enum MapType {
  standard,
  terrain,
  satellite,
}

class MapPage extends ConsumerStatefulWidget {
  MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage> {
  final MapController _controller = MapController();

  @override
  Widget build(BuildContext context) {
    var style = ref.watch(mapStyleProvider);
    var location = ref.watch(currentLocationProvider);
    var settingState = ref.watch(settingsProvider);
    var interactions = ref.watch(mapInteractionsProvider);
    var interactionTypes = ref.watch(interactionTypesProvider);
    var animals = ref.watch(animalTypesProvider);

    if (style.isLoading ||
        location.isLoading ||
        interactionTypes.isLoading ||
        animals.isLoading ||
        interactions.isLoading ||
        style.hasError ||
        location.hasError ||
        interactionTypes.hasError ||
        animals.hasError ||
        interactions.hasError) {
      return const Center(child: CircularProgressIndicator());
    }
    List<Marker> markers = [];
    var interactionTypesList = interactionTypes.value!;
    var interactionsList = interactions.value!.items.where((i) => settingState
        .allowedTypes()
        .contains(interactionTypesList
            .firstWhere((type) => type.id == i.interactionType)
            .typeKey));
    for (var item in interactionsList) {
      final InteractionType interactionType = interactionTypesList
          .firstWhere((type) => type.id == item.interactionType);
      final Animal? animal = animals.value!
          .where((animal) => animal.id == item.animalId)
          .firstOrNull;

      markers.add(
        Marker(
          width: 32,
          height: 32,
          point: LatLng(double.parse(item.lat), double.parse(item.lon)),
          builder: (ctx) => MapMarker(
            interaction: item,
            type: interactionType,
            animal: animal,
          ),
          rotate: false,
        ),
      );
    }

    return Scaffold(
      body: FlutterMap(
          mapController: _controller,
          options: MapOptions(
              center: !location.isLoading && location.value?.longitude != null
                  ? LatLng(
                      location.value!.latitude!, location.value!.longitude!)
                  : const LatLng(51, 5),
              zoom: 15,
              maxZoom: 18,
              minZoom: 7,
              maxBounds: LatLngBounds(
                const LatLng(53.79841012278817, 7.797161079786122), //Top Right
                const LatLng(48.827529576991, 2.227490788147122), //Bottom Left
              ),
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
              style: const LocationMarkerStyle(
                marker: DefaultLocationMarker(
                  child: Icon(
                    Icons.navigation,
                    color: Colors.white,
                  ),
                ),
                markerSize: Size(40, 40),
                markerDirection: MarkerDirection.heading,
              ),
            ),
            MarkerLayer(markers: markers),
            Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: const EdgeInsets.only(top: 200),
                    child: Wrap(children: <Widget>[
                      Container(
                        width: 50,
                        decoration: const BoxDecoration(
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
                                          : const LatLng(51.45034, 5.45285),
                                      17.0);
                                },
                                icon: const Icon(AppIcons.userlocation,
                                    color: AppColors.neutral_50)),
                            const Divider(
                              height: 1,
                              color: AppColors.neutral_50,
                            ),
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (BuildContext context) {
                                      return const Wrap(
                                          children: [MapSettingModal()]);
                                    },
                                  );
                                },
                                icon: const Icon(AppIcons.mapsettings,
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
                                      return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom),
                                          child: Wrap(
                                              children: [ReportOtherModal()]));
                                    },
                                  );
                                },
                                icon: Icon(AppIcons.paths,
                                    color: AppColors.neutral_50))
                          ],
                        ),
                      ),
                    ]))),
          ]),
    );
  }
}
