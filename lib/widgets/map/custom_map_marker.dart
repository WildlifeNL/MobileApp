import 'package:flutter/material.dart';
import 'package:wildlife_nl_app/utilities/app_colors.dart';
import 'package:wildlife_nl_app/utilities/app_icons.dart';

class IncidentMapMarker extends StatelessWidget {
  const IncidentMapMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.incident,
      ),
      child: const Icon(
        AppIcons.incident,
        size: 19,
        color: AppColors.neutral_50,
      ),
    );
  }
}

class SightingMapMarker extends StatelessWidget {
  const SightingMapMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: const Icon(
        AppIcons.deer,
        size: 19,
        color: AppColors.neutral_50,
      ),
    );
  }
}
