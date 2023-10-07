import 'package:flutter/src/widgets/framework.dart';
import 'package:wildlife_nl_app/pages/activity.dart';

class SightingActivityItem {
  final String animal;
  final int animalCount;
  final String location;
  final DateTime date;

  SightingActivityItem({
    required this.animal,
    required this.animalCount,
    required this.location,
    required this.date,
  });
}