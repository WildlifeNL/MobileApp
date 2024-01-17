import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:wildlife_nl_app/models/animal.dart';
import 'package:wildlife_nl_app/models/interaction.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';
import 'package:wildlife_nl_app/widgets/report/report_item_modal.dart';

final dateFormatter = DateFormat.yMd().add_jm();

class MapMarker extends StatefulWidget {
  final Interaction interaction;
  final InteractionType type;
  final Animal? animal;

  const MapMarker({
    super.key,
    required this.interaction,
    required this.type,
    this.animal,
  });

  @override
  State<MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<MapMarker> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return Wrap(children: [
              ReportItemModal(
                interaction: widget.interaction,
                type: widget.type,
                animal: widget.animal,
              )
            ]);
          },
        );
      },
      child: Container(
        width: 300.0,
        height: 300.0,
        decoration: BoxDecoration(
          color: HexColor(widget.type.color),
          shape: BoxShape.circle,
        ),
        child: switch (widget.type.typeKey) {
          InteractionTypeKey.sighting =>
            const Icon(AppIcons.paw, color: AppColors.neutral_50),
          InteractionTypeKey.damage =>
            const Icon(AppIcons.incident, color: AppColors.neutral_50),
          InteractionTypeKey.inappropriateBehaviour =>
            const Icon(AppIcons.cancel, color: AppColors.neutral_50),
          InteractionTypeKey.traffic =>
            const Icon(AppIcons.traffic, color: AppColors.neutral_50),
          InteractionTypeKey.maintenance =>
            const Icon(AppIcons.maintenance, color: AppColors.neutral_50),
        },
      ),
    );
  }
}
