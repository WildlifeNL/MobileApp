import 'dart:math';

import 'package:auto_animated/auto_animated.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/models/activity/incident_activity_item.dart';
import 'package:wildlife_nl_app/models/activity/sighting_activity_item.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/widgets/activity_item_card.dart';

import 'dart:developer' as developer;

import '../widgets/activity_filter_chips.dart';

part "activity.g.dart";

var allItems = [
  SightingActivityItem(
    animal: "Deer",
    animalCount: 1,
    location: "Eindhoven",
    date: DateTime.now()
        .subtract(Duration(days: 1, hours: 3, minutes: random.nextInt(60))),
  ),
  IncidentActivityItem(
    animal: "Wolf",
    title: "Property damage",
    date: DateTime.now()
        .subtract(Duration(days: 1, hours: 5, minutes: random.nextInt(60))),
    description: "The animal destroyed several fences",
  ),
  IncidentActivityItem(
    animal: "Fox",
    title: "Aggressive behaviour",
    date: DateTime.now()
        .subtract(Duration(days: 1, hours: 8, minutes: random.nextInt(60))),
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
  ),
  SightingActivityItem(
    animal: "Deer",
    animalCount: 3,
    location: "Amsterdam",
    date: DateTime.now()
        .subtract(Duration(days: 2, hours: 1, minutes: random.nextInt(60))),
  ),
  IncidentActivityItem(
    animal: "Stoat",
    title: "Property damage",
    date: DateTime.now()
        .subtract(Duration(days: 2, hours: 4, minutes: random.nextInt(60))),
    description: "The animal destroyed the cables inside my car",
  ),
  SightingActivityItem(
    animal: "Fox",
    animalCount: 1,
    location: "Heerlen",
    date: DateTime.now()
        .subtract(Duration(days: 2, hours: 7, minutes: random.nextInt(60))),
  ),
  SightingActivityItem(
    animal: "Hare",
    animalCount: 9,
    location: "Valkenswaard",
    date: DateTime.now()
        .subtract(Duration(days: 3, hours: 9, minutes: random.nextInt(60))),
  ),
  IncidentActivityItem(
      animal: "Otter",
      title: "Aggressive behaviour",
      date: DateTime.now()
          .subtract(Duration(days: 10, hours: 4, minutes: random.nextInt(60))),
      description: "Dit is een uitleg over dit incident"),
  SightingActivityItem(
    animal: "Wild horse",
    animalCount: 5,
    location: "Veluwe",
    date: DateTime.now()
        .subtract(Duration(days: 11, hours: 3, minutes: random.nextInt(60))),
  ),
  SightingActivityItem(
    animal: "Deer",
    animalCount: 3,
    location: "Amsterdam",
    date: DateTime.now()
        .subtract(Duration(days: 2, hours: 1, minutes: random.nextInt(60))),
  ),
  SightingActivityItem(
    animal: "Fox",
    animalCount: 1,
    location: "Heerlen",
    date: DateTime.now()
        .subtract(Duration(days: 2, hours: 7, minutes: random.nextInt(60))),
  ),
  SightingActivityItem(
    animal: "Hare",
    animalCount: 9,
    location: "Valkenswaard",
    date: DateTime.now()
        .subtract(Duration(days: 3, hours: 9, minutes: random.nextInt(60))),
  ),
  IncidentActivityItem(
      animal: "Otter",
      title: "Aggressive behaviour",
      date: DateTime.now()
          .subtract(Duration(days: 10, hours: 4, minutes: random.nextInt(60))),
      description: "Dit is een uitleg over dit incident"),
  SightingActivityItem(
    animal: "Fox",
    animalCount: 1,
    location: "Heerlen",
    date: DateTime.now()
        .subtract(Duration(days: 2, hours: 7, minutes: random.nextInt(60))),
  ),
  SightingActivityItem(
    animal: "Hare",
    animalCount: 9,
    location: "Valkenswaard",
    date: DateTime.now()
        .subtract(Duration(days: 3, hours: 9, minutes: random.nextInt(60))),
  ),
  IncidentActivityItem(
      animal: "Otter",
      title: "Aggressive behaviour",
      date: DateTime.now()
          .subtract(Duration(days: 10, hours: 4, minutes: random.nextInt(60))),
      description: "Dit is een uitleg over dit incident"),
  SightingActivityItem(
    animal: "Fox",
    animalCount: 1,
    location: "Heerlen",
    date: DateTime.now()
        .subtract(Duration(days: 2, hours: 7, minutes: random.nextInt(60))),
  ),
  SightingActivityItem(
    animal: "Hare",
    animalCount: 9,
    location: "Valkenswaard",
    date: DateTime.now()
        .subtract(Duration(days: 3, hours: 9, minutes: random.nextInt(60))),
  ),
  IncidentActivityItem(
      animal: "Otter",
      title: "Aggressive behaviour",
      date: DateTime.now()
          .subtract(Duration(days: 10, hours: 4, minutes: random.nextInt(60))),
      description: "Dit is een uitleg over dit incident"),
];

@riverpod
class Activities extends _$Activities {
  @override
  Future<List<dynamic>> build() async {
    var items = allItems.getRange(random.nextInt(8), allItems.length).toList();

    await Future.delayed(const Duration(seconds: 3));

    return await Future.value(items);
  }

  void reset() {
    state = const AsyncValue.data([]);
  }
}

final random = Random();
final animatedListKey = GlobalKey<SliverAnimatedListState>();
final refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

class ActivityPage extends ConsumerStatefulWidget {
  const ActivityPage({super.key});

  @override
  ConsumerState<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends ConsumerState<ActivityPage> {
  var currentFilter = ActivityFilter.all;

  late ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  List<dynamic> filterList(List<dynamic> activities, ActivityFilter filter) {
    return activities
        .where((element) => filter == ActivityFilter.all
            ? true
            : switch (element) {
                IncidentActivityItem() => filter == ActivityFilter.incidents,
                SightingActivityItem() => filter == ActivityFilter.sightings,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          ref.invalidate(activitiesProvider);
          var value = await ref.read(activitiesProvider.future);

          var allActivities = value.followedBy(activitiesList).toList();
          var allUniqueActivities = [];

          for (var activity in allActivities) {
            if(!allUniqueActivities.contains(activity)){
              allUniqueActivities.add(activity);
            }
          }

          handleChanges(filteredList, value, allUniqueActivities);
          setState(() {});
        },
        child: CustomScrollView(
          controller: _controller,
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
    );
  }

  Widget renderItem(activitiesList, int index, Animation<double> animation) {
    switch (activitiesList[index]) {
      case IncidentActivityItem item:
        return ActivityItemCard(
          icon: Symbols.warning_rounded,
          title: item.title,
          subtitle: item.animal,
          date: item.date,
          color: AppColors.incident,
          animation: animation,
          description: item.description,
        );
      case SightingActivityItem item:
        return ActivityItemCard(
          icon: AppIcons.deer,
          title: item.animal,
          subtitle:
              "${item.animalCount} animal${item.animalCount > 1 ? "s" : ""} • ${item.location}",
          date: item.date,
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
