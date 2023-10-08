import 'package:flutter/src/widgets/framework.dart';
import 'package:uuid/uuid.dart';
import 'package:wildlife_nl_app/pages/activity.dart';

var uuid = const Uuid();
class IncidentActivityItem {
  final String id = uuid.v4();
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
