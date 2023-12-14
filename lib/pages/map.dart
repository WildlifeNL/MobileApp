import 'dart:convert';
import 'dart:developer';

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
import 'package:wildlife_nl_app/widgets/map_path_modal.dart';
import 'package:wildlife_nl_app/widgets/map_settings_modal.dart';
import 'dart:developer' as developer;
import '../flavors.dart';
import '../utilities/app_icons.dart';
import 'package:http/http.dart' as http;

part 'map.g.dart';

String mapURL =
    'https://api.mapbox.com/styles/v1/daankleinen/clq51lfjn004901pq4k3p320o?access_token=pk.eyJ1IjoiZGFhbmtsZWluZW4iLCJhIjoiY2t4MzFwMTJxMGo2bTJ1bzFncjV6YmJ6ayJ9.FY0BF_wgag5wFw-2dWSLGQ';

@riverpod
class MapStyle extends _$MapStyle {
  @override
  Future<Style> build() async {
    return await StyleReader(
      uri: mapURL,
    ).read();
  }
}

@Riverpod(keepAlive: true)
class Markers extends _$Markers {
  @override
  Future<MarkerState> build() async {
    return MarkerState();
  }

  toggle1() {
    state = AsyncData(state.value!.copyWith(toggle1: !state.value!.toggle1));
  }

  toggle2() {
    state = AsyncData(state.value!.copyWith(toggle2: !state.value!.toggle2));
  }

  toggle3() {
    state = AsyncData(state.value!.copyWith(toggle3: !state.value!.toggle3));
  }

  toggle4() {
    state = AsyncData(state.value!.copyWith(toggle4: !state.value!.toggle4));
  }

  toggle5() {
    state = AsyncData(state.value!.copyWith(toggle5: !state.value!.toggle5));
  }

  mapToggle1() {
    state = AsyncData(state.value!.copyWith(mapTypeToggle1: true));
    state = AsyncData(state.value!.copyWith(mapTypeToggle2: false));
    state = AsyncData(state.value!.copyWith(mapTypeToggle3: false));
  }

  mapToggle2() {
    state = AsyncData(state.value!.copyWith(mapTypeToggle1: false));
    state = AsyncData(state.value!.copyWith(mapTypeToggle2: true));
    state = AsyncData(state.value!.copyWith(mapTypeToggle3: false));
  }

  mapToggle3() {
    state = AsyncData(state.value!.copyWith(mapTypeToggle1: false));
    state = AsyncData(state.value!.copyWith(mapTypeToggle2: false));
    state = AsyncData(state.value!.copyWith(mapTypeToggle3: true));
  }
}

class MarkerState {
  var toggle1 = true;
  var toggle2 = true;
  var toggle3 = true;
  var toggle4 = true;
  var toggle5 = true;
  var mapTypeToggle1 = true;
  var mapTypeToggle2 = false;
  var mapTypeToggle3 = false;

  MarkerState copyWith(
      {bool? toggle1,
      bool? toggle2,
      bool? toggle3,
      bool? toggle4,
      bool? toggle5,
      bool? mapTypeToggle1,
      bool? mapTypeToggle2,
      bool? mapTypeToggle3}) {
    if (toggle1 != null) {
      this.toggle1 = toggle1;
    }
    if (toggle2 != null) {
      this.toggle2 = toggle2;
    }
    if (toggle3 != null) {
      this.toggle3 = toggle3;
    }
    if (toggle4 != null) {
      this.toggle4 = toggle4;
    }
    if (toggle5 != null) {
      this.toggle5 = toggle5;
    }
    if (mapTypeToggle1 != null) {
      this.mapTypeToggle1 = mapTypeToggle1;
    }
    if (mapTypeToggle2 != null) {
      this.mapTypeToggle2 = mapTypeToggle2;
    }
    if (mapTypeToggle3 != null) {
      this.mapTypeToggle3 = mapTypeToggle3;
    }

    return this;
  }
}

class Report {
  final String interaction_type;
  final String time;
  final String image;
  final String description;
  final String lat;
  final String lon;
  final String animal_id;
  final String animal_count_upper;
  final String juvenil_animal_count_upper;
  final String traffic_event;
  String color;
  String label;
  String animalName;


  Report({

    required this.interaction_type,
    required this.time,
    required this.image,
    required this.description,
    required this.lat,
    required this.lon,
    required this.animal_id,
    required this.animal_count_upper,
    required this.juvenil_animal_count_upper,
    required this.color,
    required this.label,
    required this.animalName,
    required this.traffic_event,
  });
}

final String baseUrl = F.apiUrl;

List<Report> ReportApi = [];

Future<void> fetchData() async {
  final typesResponse =
      await http.get(Uri.parse(baseUrl + 'api/controllers/interactions.php'));

  if (typesResponse.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(typesResponse.body);

    // Map the raw JSON data into a list of AnimalType objects
    ReportApi = jsonData["results"].map<Report>((json) {
      return Report(
        lat: json['lat'] ?? '',
        lon: json['lon'] ?? '',
        interaction_type: json["interaction_type"] ?? '',
        image: json["image"] ?? '',
        description: json["description"] ?? '',
        animal_count_upper: json["animal_count_upper"] ?? '',
        juvenil_animal_count_upper: json["juvenil_animal_count_upper"] ?? '',
        time: json["time"] ?? '',
        color: "#000000" ?? '',
        label: "" ?? '',
        animal_id: json["animal_id"]?? '',
        animalName: '' ?? '',
        traffic_event: json["traffic_event"] ?? '',
      );
    }).toList();
  } else {
    print('Response failed');
  }
}

class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapState();
}

class _MapState extends ConsumerState<MapPage> {
  final MapController _controller = MapController();

  List<Marker> markers = [];

  Future<List<Marker>> getMarkers(MarkerState? state) async {
    markers.clear();

    var test = ReportApi.where((i) {
      return (i.interaction_type == "86a6b56a-89f0-11ee-919a-1e0034001676" &&
              state!.toggle1) ||
          (i.interaction_type == "689a5571-8eb5-11ee-919a-1e0034001676" &&
              state!.toggle2) ||
          (i.interaction_type == "86a838e1-89f0-11ee-919a-1e0034001676" &&
                  state!.toggle3 ||
              (i.interaction_type == "86a5736f-89f0-11ee-919a-1e0034001676" &&
                  state!.toggle4) ||
              (i.interaction_type == "689ccf59-8eb5-11ee-919a-1e0034001676" &&
                  state!.toggle5));
    }).toList();
    for (var item in test) {
      final typesResponse = await http.get(Uri.parse(
          'https://api.wildlifedatabase.nl/api/controllers/interactions.php/types?id=' +
              item.interaction_type));
      if (typesResponse.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(typesResponse.body);
        item.color = jsonData["color"];
        item.label = jsonData["label"];
      }

      final animalResponse = await http.get(Uri.parse(
          baseUrl + 'api/controllers/animals.php?id=' +
              item.animal_id));
      if (animalResponse.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(animalResponse.body);
        item.animalName = jsonData["name"];
      }

      markers.add(
        Marker(
          width: 32,
          height: 32,
          point: LatLng(double.parse(item.lat), double.parse(item.lon)),
          builder: (ctx) => MapMarker(
            markerType: item.interaction_type,
            color: item.color,
            label: item.label,
            time: item.time,
            image: item.image,
            description: item.description,
            animal_count_upper: item.animal_count_upper,
              juvenil_animal_count_upper: item.juvenil_animal_count_upper,
              animalName: item.animalName,
              traffic_event: item.traffic_event,
            lat: item.lat,
            lon: item.lon,
          ),
          rotate: false,
        ),
      );
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    var style = ref.watch(mapStyleProvider);
    var location = ref.watch(currentLocationProvider);
    var markerState = ref.watch(markersProvider);
    fetchData();
    if (style.isLoading || location.isLoading || markerState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    getMarkers(markerState.value);

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
            MarkerLayer(markers: markers),
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
                                icon: Icon(AppIcons.userlocation,
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
                                      return Wrap(
                                          children: [MapSettingModal()]);
                                    },
                                  );
                                },
                                icon: Icon(AppIcons.mapsettings,
                                    color: AppColors.neutral_50)),
                            // Divider(
                            //   height: 1,
                            //   color: AppColors.neutral_50,
                            // ),
                            // IconButton(
                            //     onPressed: () {
                            //       showModalBottomSheet<void>(
                            //         context: context,
                            //         isScrollControlled: true,
                            //         builder: (BuildContext context) {
                            //           return Wrap(
                            //               children: [MapPathModal()]);
                            //         },
                            //       );
                            //     },
                            //     icon: Icon(AppIcons.paths,
                            //         color: AppColors.neutral_50))
                          ],
                        ),
                      ),
                    ]))),
          ]),
    );
  }
}
