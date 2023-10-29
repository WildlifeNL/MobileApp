import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wildlife_nl_app/generated/l10n.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';

enum ActivityFilter {
  all,
  incidents,
  sightings,
}

class ActivityFilterChips extends StatefulWidget {
  const ActivityFilterChips({
    super.key,
    required this.onFilter,
  });

  final Function(ActivityFilter) onFilter;

  @override
  State<ActivityFilterChips> createState() => _ActivityFilterChipsState();
}

class _ActivityFilterChipsState extends State<ActivityFilterChips> {
  ActivityFilter filter = ActivityFilter.all;

  onSelected(ActivityFilter filterChip) {
    if (filter == filterChip) return;

    setState(() {
      filter = filterChip;
      widget.onFilter(filter);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            ActivityFilterChip(
              selected: filter == ActivityFilter.all,
              title: S.of(context).filterActivitiesAll,
              onSelected: (_) => onSelected(ActivityFilter.all),
            ),
            const SizedBox(
              width: 8,
            ),
            ActivityFilterChip(
              selected: filter == ActivityFilter.sightings,
              title: S.of(context).filterActivitiesSightings,
              onSelected: (_) => onSelected(ActivityFilter.sightings),
            ),
            const SizedBox(
              width: 8,
            ),
            ActivityFilterChip(
              selected: filter == ActivityFilter.incidents,
              title: S.of(context).filterActivitiesIncidents,
              onSelected: (_) => onSelected(ActivityFilter.incidents),
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
  });

  final bool selected;
  final String title;
  final Function(bool _) onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      selected: selected,
      labelStyle: GoogleFonts.inter(
          color: selected ? Colors.white : AppColors.neutral_500,
          fontSize: 12,
          fontWeight: FontWeight.w500),
      labelPadding: const EdgeInsets.symmetric(horizontal: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      label: Text(title),
      showCheckmark: false,
      color: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primary;
        }
        return AppColors.neutral_100;
      }),
      onSelected: onSelected,
    );
  }
}
