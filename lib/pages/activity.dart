import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/models/data/geojson/point.dart';
import 'package:wildlife_nl_app/models/data/incident.dart';
import 'package:wildlife_nl_app/models/data/interaction.dart';
import 'package:wildlife_nl_app/models/data/sighting.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/widgets/activity/activity_item_card.dart';

import 'package:http/http.dart' as http;

import '../widgets/activity/activity_filter_chips.dart';

part "activity.g.dart";

final random = math.Random();

var allItems = [
  Sighting(
    animal: "Deer",
    animalCount: 1,
    locationName: "Eindhoven",
    dateTime: DateTime.now()
        .subtract(Duration(days: 1, hours: 3, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Incident(
    animal: "Wolf",
    title: "Property damage",
    dateTime: DateTime.now()
        .subtract(Duration(days: 1, hours: 5, minutes: random.nextInt(60))),
    description: "The animal destroyed several fences",
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Incident(
    animal: "Fox",
    title: "Aggressive behaviour",
    dateTime: DateTime.now()
        .subtract(Duration(days: 1, hours: 8, minutes: random.nextInt(60))),
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Deer",
    animalCount: 3,
    locationName: "Amsterdam",
    dateTime: DateTime.now()
        .subtract(Duration(days: 2, hours: 1, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Incident(
    animal: "Stoat",
    title: "Property damage",
    dateTime: DateTime.now()
        .subtract(Duration(days: 2, hours: 4, minutes: random.nextInt(60))),
    description: "The animal destroyed the cables inside my car",
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Fox",
    animalCount: 1,
    locationName: "Heerlen",
    dateTime: DateTime.now(),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Hare",
    animalCount: 9,
    locationName: "Valkenswaard",
    dateTime: DateTime.now()
        .subtract(Duration(days: 3, hours: 9, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Incident(
    animal: "Otter",
    title: "Aggressive behaviour",
    dateTime: DateTime.now()
        .subtract(Duration(days: 10, hours: 4, minutes: random.nextInt(60))),
    description: "Dit is een uitleg over dit incident",
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Wild horse",
    animalCount: 5,
    locationName: "Veluwe",
    dateTime: DateTime.now()
        .subtract(Duration(days: 11, hours: 3, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Deer",
    animalCount: 3,
    locationName: "Amsterdam",
    dateTime: DateTime.now()
        .subtract(Duration(days: 2, hours: 1, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Fox",
    animalCount: 1,
    locationName: "Heerlen",
    dateTime: DateTime.now()
        .subtract(Duration(days: 2, hours: 7, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Hare",
    animalCount: 9,
    locationName: "Valkenswaard",
    dateTime: DateTime.now()
        .subtract(Duration(days: 3, hours: 9, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Incident(
    animal: "Otter",
    title: "Aggressive behaviour",
    dateTime: DateTime.now()
        .subtract(Duration(days: 10, hours: 4, minutes: random.nextInt(60))),
    description: "Dit is een uitleg over dit incident",
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Fox",
    animalCount: 1,
    locationName: "Heerlen",
    dateTime: DateTime.now()
        .subtract(Duration(days: 2, hours: 7, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Hare",
    animalCount: 9,
    locationName: "Valkenswaard",
    dateTime: DateTime.now()
        .subtract(Duration(days: 3, hours: 9, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Incident(
    animal: "Otter",
    title: "Aggressive behaviour",
    dateTime: DateTime.now()
        .subtract(Duration(days: 10, hours: 4, minutes: random.nextInt(60))),
    description: "Dit is een uitleg over dit incident",
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Fox",
    animalCount: 1,
    locationName: "Heerlen",
    dateTime: DateTime.now()
        .subtract(Duration(days: 2, hours: 7, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Sighting(
    animal: "Hare",
    animalCount: 9,
    locationName: "Valkenswaard",
    dateTime: DateTime.now()
        .subtract(Duration(days: 3, hours: 9, minutes: random.nextInt(60))),
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
  Incident(
    animal: "Otter",
    title: "Aggressive behaviour",
    dateTime: DateTime.now()
        .subtract(Duration(days: 10, hours: 4, minutes: random.nextInt(60))),
    description: "Dit is een uitleg over dit incident",
    location: Point(coordinates: [51.44083, 5.47778]),
  ),
];

@riverpod
class Activities extends _$Activities {
  @override
  Future<List<dynamic>> build() async {
    var response = await http.get(Uri.parse("http://35.178.117.91:81/interactions/list?offset=0&count=100"));

    var decodedJson = jsonDecode(response.body);
    
    List<dynamic> jsonList = decodedJson["results"];
    
    List<dynamic> objList = [];
    
    for (var value in jsonList) {
      final interaction = Interaction.fromJson(value);
      if(interaction.interactionType == "sighting"){
        objList.add(Sighting.fromInteraction(interaction));
      }
      if(interaction.interactionType == "incident"){
        objList.add(Incident.fromInteraction(interaction));
      }
    }

    return objList;
  }

  void reset() {
    state = const AsyncValue.data([]);
  }
}

final animatedListKey = GlobalKey<SliverAnimatedListState>();
final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({super.key});

  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage> {
  var currentFilter = ActivityFilter.all;

  List<dynamic> filterList(List<dynamic> activities, ActivityFilter filter) {
    return activities
        .where((element) => filter == ActivityFilter.all
            ? true
            : switch (element) {
                Incident() => filter == ActivityFilter.incidents,
                Sighting() => filter == ActivityFilter.sightings,
                Object() => false,
                null => false,
              })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final activities = ref.watch(activitiesProvider).whenData((list) {
      return list;
    });

    if (activities.hasError) {
      return const Text("Error occurred.");
    }

    if (activities.isLoading && !activities.hasValue) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 3,
            ),
          ),
        ],
      );
    }

    var activitiesList = activities.value!;

    var filteredList = filterList(activitiesList, currentFilter);

    return SafeArea(
      top: true,
      bottom: false,
      minimum: const EdgeInsets.only(bottom: 90),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            ref.invalidate(activitiesProvider);
            var value = await ref.read(activitiesProvider.future);

            var allUniqueActivities = [];
            for (var activity in value.followedBy(activitiesList).toList()) {
              if (!allUniqueActivities.contains(activity)) {
                allUniqueActivities.add(activity);
              }
            }

            handleChanges(filteredList, filterList(value, currentFilter),
                allUniqueActivities);
            setState(() {});
          },
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.only(top: 25),
                sliver: ActivityFilterChips(
                  onFilter: (filter) {
                    handleChanges(filteredList,
                        filterList(activitiesList, filter), activitiesList);
                    setState(() {
                      currentFilter = filter;
                    });
                  },
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 25),
                sliver: SliverAnimatedList(
                  key: animatedListKey,
                  initialItemCount: filteredList.length,
                  itemBuilder: (context, index, animation) =>
                      renderItem(filteredList, index, animation),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget renderItem(activitiesList, int index, Animation<double> animation) {
    switch (activitiesList[index]) {
      case Incident item:
        return ActivityItemCard(
          icon: Symbols.warning_rounded,
          title: item.title,
          subtitle: item.animal,
          date: item.dateTime,
          color: AppColors.incident,
          animation: animation,
          description: item.description,
        );
      case Sighting item:
        return ActivityItemCard(
          icon: AppIcons.deer,
          title: item.animal,
          subtitle:
              "${item.animalCount} animal${item.animalCount > 1 ? "s" : ""} • ${item.locationName}",
          date: item.dateTime,
          color: AppColors.primary,
          animation: animation,
        );
    }
    return const Padding(padding: EdgeInsets.zero);
  }

  void handleChanges(List oldList, List newList, List activitiesList) {
    final state = animatedListKey.currentState!;
    for (var value in activitiesList.reversed) {
      var isInOld = oldList.contains(value);
      var isInNew = newList.contains(value);

      if (isInOld && !isInNew) {
        var index = oldList.indexOf(value);
        state.removeItem(
          index,
          (context, animation) => renderItem(oldList, index, animation),
          duration: const Duration(milliseconds: 300),
        );
      }
    }

    for (var value in activitiesList) {
      var isInOld = oldList.contains(value);
      var isInNew = newList.contains(value);

      if (!isInOld && isInNew) {
        state.insertItem(
          newList.indexOf(value),
          duration: const Duration(milliseconds: 450),
        );
      }
    }
  }
}
