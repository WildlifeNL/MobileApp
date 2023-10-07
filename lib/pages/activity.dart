import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/models/activity/incident_activity_item.dart';
import 'package:wildlife_nl_app/models/activity/sighting_activity_item.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/widgets/activity_item_card.dart';

part "activity.g.dart";

@riverpod
class Activities extends _$Activities {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

final random = Random();

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var items = [];

    items.add(SightingActivityItem(
      animal: "Deer",
      animalCount: 1,
      location: "Eindhoven",
      date: DateTime.now()
          .subtract(Duration(days: 1, hours: 3, minutes: random.nextInt(60))),
    ));
    items.add(IncidentActivityItem(
      animal: "Wolf",
      title: "Property damage",
      date: DateTime.now()
          .subtract(Duration(days: 1, hours: 5, minutes: random.nextInt(60))),
      description: "The animal destroyed several fences",
    ));
    items.add(IncidentActivityItem(
      animal: "Fox",
      title: "Aggressive behaviour",
      date: DateTime.now()
          .subtract(Duration(days: 1, hours: 8, minutes: random.nextInt(60))),
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    ));
    items.add(SightingActivityItem(
      animal: "Deer",
      animalCount: 3,
      location: "Amsterdam",
      date: DateTime.now()
          .subtract(Duration(days: 2, hours: 1, minutes: random.nextInt(60))),
    ));
    items.add(IncidentActivityItem(
      animal: "Stoat",
      title: "Property damage",
      date: DateTime.now()
          .subtract(Duration(days: 2, hours: 4, minutes: random.nextInt(60))),
      description: "The animal destroyed the cables inside my car",
    ));
    items.add(SightingActivityItem(
      animal: "Fox",
      animalCount: 1,
      location: "Heerlen",
      date: DateTime.now()
          .subtract(Duration(days: 2, hours: 7, minutes: random.nextInt(60))),
    ));
    items.add(SightingActivityItem(
      animal: "Hare",
      animalCount: 9,
      location: "Valkenswaard",
      date: DateTime.now()
          .subtract(Duration(days: 3, hours: 9, minutes: random.nextInt(60))),
    ));
    items.add(
      IncidentActivityItem(
          animal: "Otter",
          title: "Aggressive behaviour",
          date: DateTime.now()
              .subtract(Duration(days: 10, hours: 4, minutes: random.nextInt(60))),
          description: "Dit is een uitleg over dit incident"),
    );
    items.add(SightingActivityItem(
      animal: "Wild horse",
      animalCount: 5,
      location: "Veluwe",
      date: DateTime.now()
          .subtract(Duration(days: 11, hours: 3, minutes: random.nextInt(60))),
    ));

    return SafeArea(
      top: true,
      bottom: false,
      minimum: const EdgeInsets.only(bottom: 90),
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
            sliver: SliverList.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  switch (items[index]) {
                    case IncidentActivityItem item:
                      return ActivityItemCard(
                        icon: Symbols.warning_rounded,
                        title: item.title,
                        subtitle: item.animal,
                        date: item.date,
                        color: AppColors.incident,
                        description: item.description,
                      );
                    case SightingActivityItem item:
                      return ActivityItemCard(
                          icon: AppIcons.deer,
                          title: item.animal,
                          subtitle:
                              "${item.animalCount} animal${item.animalCount > 1 ? "s" : ""} • ${item.location}",
                          date: item.date,
                          color: AppColors.primary);
                  }
                  return null;
                }),
          ),
        ],
      ),
    );
  }
}
