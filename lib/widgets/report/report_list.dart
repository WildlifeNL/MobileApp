import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wildlife_nl_app/models/animal.dart';
import 'package:wildlife_nl_app/models/interaction.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/services/interaction.dart';
import 'package:wildlife_nl_app/state/animal_types.dart';
import 'package:wildlife_nl_app/state/interaction_types.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/utilities/app_styles.dart';
import 'package:wildlife_nl_app/utilities/hex_color.dart';
import 'package:wildlife_nl_app/widgets/custom_infinite_grouped_list.dart';
import 'package:wildlife_nl_app/widgets/report/report_filter_chips.dart';
import 'package:wildlife_nl_app/widgets/report/report_item_card.dart';

class ReportList extends ConsumerStatefulWidget {
  const ReportList(
      {super.key,
      required this.type,
      required this.filterChips,
      required this.controller});

  final InfiniteGroupedListController<Interaction, DateTime, String> controller;

  final InteractionTypeKey? type;

  final ReportFilterChips filterChips;

  @override
  ConsumerState<ReportList> createState() => _ReportListState();
}

class _ReportListState extends ConsumerState<ReportList> {
  DateTime baseDate = DateTime.now();

  late final InfiniteGroupedListController<Interaction, DateTime, String>
      _controller;

  @override
  void initState() {
    _controller = widget.controller ?? InfiniteGroupedListController();
    super.initState();
  }

  Future<List<Interaction>> onLoadMore(int page) async {
    if (widget.type != null) {
      var response = await InteractionService.getInteractionsByType(
        widget.type!,
        page,
        15,
        accessToken: "",
      );

      if (response.isOk()) {
        return response().results;
      } else {
        throw Exception(response.unwrapErr());
      }
    } else {
      var response =
          await InteractionService.getInteractions(page, 15, accessToken: "");

      if (response.isOk()) {
        return response().results;
      } else {
        throw Exception(response.unwrapErr());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var interactionTypes = ref.watch(interactionTypesProvider);
    var animals = ref.watch(animalTypesProvider);

    if (interactionTypes.isLoading || animals.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: CustomInfiniteGroupedList(
        filterChips: widget.filterChips,
        stickyGroups: false,
        refreshIndicatorColor: AppColors.neutral_500,
        refreshIndicatorBackgroundColor: AppColors.neutral_50,
        controller: _controller,
        physics: const AlwaysScrollableScrollPhysics(),
        groupBy: (item) => item.time,
        groupTitleBuilder: (title, groupBy, isPinned, scrollPercentage) =>
            Padding(
          padding: const EdgeInsets.only(left: 12.0,bottom: 12.0, top: 12.0),
          child: Text(
            title,
            style: AppStyles.of(context).data.textStyle.headerMedium.copyWith(color: HexColor("#737373"), fontWeight: FontWeight.bold,),
          ),
        ),
        itemBuilder: (item) {
          InteractionType type = InteractionType(
              id: "",
              label: "Unknown",
              typeKey: InteractionTypeKey.sighting,
              color: "#000000");
          for (var value in interactionTypes.requireValue) {
            if (value.id == item.interactionType) {
              type = value;
            }
          }
          Animal animal = Animal(
              id: "",
              name: "",
              familyId: "",
              image: "",
              specifications: null,
              creationDate: DateTime.now(),
              lastModified: DateTime.now());
          for (var value in animals.requireValue) {
            if (value.id == item.animalId) {
              animal = value;
            }
          }

          var color = HexColor(type.color);

          switch (type.typeKey) {
            case InteractionTypeKey.sighting:
              return ActivityItemCard(
                  icon: AppIcons.deer,
                  title: animal.name,
                  subtitle: "Onbekende locatie",
                  date: item.time,
                  color: color);
            case InteractionTypeKey.damage:
              return ActivityItemCard(
                  icon: AppIcons.incident,
                  title: type.label,
                  subtitle: "Onbekende locatie",
                  date: item.time,
                  color: color);
            case InteractionTypeKey.inappropriateBehaviour:
              return ActivityItemCard(
                  icon: AppIcons.incident,
                  title: type.label,
                  subtitle: "Onbekende locatie",
                  date: item.time,
                  color: color);
            case InteractionTypeKey.traffic:
              return ActivityItemCard(
                  icon: AppIcons.traffic,
                  title: type.label,
                  subtitle: "Onbekende locatie",
                  date: item.time,
                  color: color);
            case InteractionTypeKey.maintenance:
              return ActivityItemCard(
                  icon: AppIcons.maintenance,
                  title: type.label,
                  subtitle: "Onbekende locatie",
                  date: item.time,
                  color: color);
          }
        },
        onLoadMore: (info) async => await onLoadMore(info.page),
        loadMoreItemsErrorWidget: (lol) => const Padding(
          padding: EdgeInsets.zero,
        ),
        initialItemsErrorWidget: (lol) {
          return Text(
            'Er is iets verkeerd gegaan',
            textAlign: TextAlign.center,
            style: AppStyles.of(context)
                .data
                .textStyle
                .paragraphMedium
                .copyWith(fontSize: 18),
          );
        },
        noItemsFoundWidget: Text(
          'Geen activiteiten gevonden',
          textAlign: TextAlign.center,
          style: AppStyles.of(context)
              .data
              .textStyle
              .paragraphMedium
              .copyWith(fontSize: 18),
        ),
        groupCreator: (dateTime) {
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final yesterday = today.subtract(const Duration(days: 1));

          if (today.day == dateTime.day &&
              today.month == dateTime.month &&
              today.year == dateTime.year) {
            return 'Vandaag';
          } else if (yesterday.day == dateTime.day &&
              yesterday.month == dateTime.month &&
              yesterday.year == dateTime.year) {
            return 'Gisteren';
          } else {
            return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
          }
        },
      ),
    );
  }
}
