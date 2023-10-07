import 'package:flutter/src/widgets/framework.dart';
import 'package:wildlife_nl_app/pages/activity.dart';

class IncidentActivityItem {
  final String animal;
  final String title;
  final DateTime date;
  final String description;

  IncidentActivityItem({
    required this.animal,
    required this.title,
    required this.date,
    required this.description,
  });
}
