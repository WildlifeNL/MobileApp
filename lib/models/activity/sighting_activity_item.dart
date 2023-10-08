import 'package:flutter/src/widgets/framework.dart';
import 'package:uuid/uuid.dart';
import 'package:wildlife_nl_app/pages/activity.dart';

var uuid = const Uuid();

class SightingActivityItem {
  final String id = uuid.v4();
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