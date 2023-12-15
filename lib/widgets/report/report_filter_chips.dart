import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/state/interaction_types.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/hex_color.dart';

enum ActivityFilter {
  all,
  sightings,
  traffic,
  incidents,
  maintenance,
  inappropriateBehaviour,
}

class ReportFilterChips extends ConsumerStatefulWidget {
  const ReportFilterChips({
    super.key,
    required this.onFilter,
    required this.state,
  });

  final Function(ActivityFilter) onFilter;
  final ActivityFilter state;

  @override
  ConsumerState<ReportFilterChips> createState() => _ReportFilterChipsState();
}

class _ReportFilterChipsState extends ConsumerState<ReportFilterChips> {
  onSelected(ActivityFilter filterChip) {
    if (widget.state == filterChip) return;

    setState(() {
      widget.onFilter(filterChip);
    });
  }

  @override
  Widget build(BuildContext context) {
    var interactionTypes = ref.watch(interactionTypesProvider);

    if (interactionTypes.isLoading) {
      return const SliverPadding(padding: EdgeInsets.all(0));
    }

    Map<InteractionTypeKey, InteractionType> type = {};


    for (var value in interactionTypes.value!) {
      type[value.typeKey] = value;
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverToBoxAdapter(
        child: Wrap(
          children: [
            ActivityFilterChip(
              selected: widget.state == ActivityFilter.all,
              title: "Alles",
              onSelected: (_) => onSelected(ActivityFilter.all),
              color: HexColor(type[InteractionTypeKey.sighting]!.color),
            ),
            const SizedBox(
              width: 8,
            ),
            ActivityFilterChip(
              selected: widget.state == ActivityFilter.sightings,
              title: type[InteractionTypeKey.sighting]!.label,
              onSelected: (_) => onSelected(ActivityFilter.sightings),
              color: HexColor(type[InteractionTypeKey.sighting]!.color),
            ),
            const SizedBox(
              width: 8,
            ),
            ActivityFilterChip(
              selected: widget.state == ActivityFilter.traffic,
              title: type[InteractionTypeKey.traffic]!.label,
              onSelected: (_) => onSelected(ActivityFilter.traffic),
              color: HexColor(type[InteractionTypeKey.traffic]!.color),
            ),
            const SizedBox(
              width: 8,
            ),
            ActivityFilterChip(
              selected: widget.state == ActivityFilter.incidents,
              title: type[InteractionTypeKey.damage]!.label,
              onSelected: (_) => onSelected(ActivityFilter.incidents),
              color: HexColor(type[InteractionTypeKey.damage]!.color),
            ),
            const SizedBox(
              width: 8,
            ),
            ActivityFilterChip(
              selected: widget.state == ActivityFilter.inappropriateBehaviour,
              title: type[InteractionTypeKey.inappropriateBehaviour]!.label,
              onSelected: (_) =>
                  onSelected(ActivityFilter.inappropriateBehaviour),
              color: HexColor(type[InteractionTypeKey.inappropriateBehaviour]!.color),
            ),
            const SizedBox(
              width: 8,
            ),
            ActivityFilterChip(
              selected: widget.state == ActivityFilter.maintenance,
              title: type[InteractionTypeKey.maintenance]!.label,
              onSelected: (_) => onSelected(ActivityFilter.maintenance),
              color: HexColor(type[InteractionTypeKey.maintenance]!.color),
            ),
          ],
        ),
      ),
    );
  }
}

class ActivityFilterChip extends StatelessWidget {
  const ActivityFilterChip({
    super.key,
    required this.selected,
    required this.title,
    required this.onSelected,
    required this.color,
  });

  final bool selected;
  final String title;
  final Function(bool _) onSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      selected: selected,
      labelStyle: GoogleFonts.inter(
        color: selected ? Colors.white : AppColors.neutral_500,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      labelPadding: const EdgeInsets.symmetric(horizontal: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      label: Text(title),
      showCheckmark: false,
      color: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return color;
        }
        return AppColors.neutral_100;
      }),
      onSelected: onSelected,
    );
  }
}
