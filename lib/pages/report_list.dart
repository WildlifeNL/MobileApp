import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/models/interaction.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/widgets/custom_infinite_grouped_list.dart';
import 'package:wildlife_nl_app/widgets/report/report_filter_chips.dart';
import 'package:wildlife_nl_app/widgets/report/report_list.dart';

var key1 = GlobalKey();
var key2 = GlobalKey();
var key3 = GlobalKey();
var key4 = GlobalKey();
var key5 = GlobalKey();
var key6 = GlobalKey();
var key7 = GlobalKey();
var key8 = GlobalKey();
var key9 = GlobalKey();

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  State<ReportListPage> createState() => _ReportListPageState();
}

class _ReportListPageState extends State<ReportListPage> {
  InteractionTypeKey? typeKey;
  ActivityFilter filter = ActivityFilter.all;

  var controller = InfiniteGroupedListController<Interaction, DateTime, String>();

  @override
  Widget build(BuildContext context) {
    var filterChips = ReportFilterChips(
      key: key1,
      state: filter,
      onFilter: (filter) {
        setState(() {
          this.filter = filter;
          switch (filter) {
            case ActivityFilter.all:
              typeKey = null;
              break;
            case ActivityFilter.sightings:
              typeKey = InteractionTypeKey.sighting;
              break;
            case ActivityFilter.traffic:
              typeKey = InteractionTypeKey.traffic;
              break;
            case ActivityFilter.incidents:
              typeKey = InteractionTypeKey.damage;
              break;
            case ActivityFilter.maintenance:
              typeKey = InteractionTypeKey.maintenance;
              break;
            case ActivityFilter.inappropriateBehaviour:
              typeKey = InteractionTypeKey.inappropriateBehaviour;
              break;
          }
        });
      },
    );

    switch (typeKey) {
      case null:
        return ReportList(
          key: key2,
          type: typeKey,
          filterChips: filterChips,
          controller: controller,
        );
      case InteractionTypeKey.sighting:
        return ReportList(
          key: key3,
          type: typeKey,
          filterChips: filterChips,
          controller: controller,
        );
      case InteractionTypeKey.damage:
        return ReportList(
          key: key4,
          type: typeKey,
          filterChips: filterChips,
          controller: controller,
        );
      case InteractionTypeKey.inappropriateBehaviour:
        return ReportList(
          key: key5,
          type: typeKey,
          filterChips: filterChips,
          controller: controller,
        );
      case InteractionTypeKey.traffic:
        return ReportList(
          key: key6,
          type: typeKey,
          filterChips: filterChips,
          controller: controller,
        );
      case InteractionTypeKey.maintenance:
        return ReportList(
          key: key7,
          type: typeKey,
          filterChips: filterChips,
          controller: controller,
        );
    }
  }
}
