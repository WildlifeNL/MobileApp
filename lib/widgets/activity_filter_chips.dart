import 'package:flutter/material.dart';
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

  final Null Function(ActivityFilter) onFilter;

  @override
  State<ActivityFilterChips> createState() => _ActivityFilterChipsState();
}

class _ActivityFilterChipsState extends State<ActivityFilterChips> {
  ActivityFilter filter = ActivityFilter.all;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverToBoxAdapter(
        child: Row(
          children: [
            ActivityFilterChip(
                selected: filter == ActivityFilter.all,
                title: "All",
                onSelected: (_) {
                  if (filter == ActivityFilter.all) return;

                  setState(() {
                    filter = ActivityFilter.all;
                    widget.onFilter(filter);
                  });
                }),
            const SizedBox(
              width: 8,
            ),
            ActivityFilterChip(
                selected: filter == ActivityFilter.sightings,
                title: "Sightings",
                onSelected: (_) {
                  if (filter == ActivityFilter.sightings) return;

                  setState(() {
                    filter = ActivityFilter.sightings;
                    widget.onFilter(filter);
                  });
                }),
            const SizedBox(
              width: 8,
            ),
            ActivityFilterChip(
                selected: filter == ActivityFilter.incidents,
                title: "Incident",
                onSelected: (_) {
                  if (filter == ActivityFilter.incidents) return;

                  setState(() {
                    filter = ActivityFilter.incidents;
                    widget.onFilter(filter);
                  });
                }),
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
  final Null Function(bool _) onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
      selected: selected,
      labelStyle: TextStyle(
          color: selected ? Colors.white : AppColors.neutral_500, fontSize: 12),
      labelPadding: EdgeInsets.symmetric(horizontal: 1),
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
