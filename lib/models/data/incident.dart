import 'package:uuid/uuid.dart';
import 'package:wildlife_nl_app/models/data/geojson/point.dart';
import 'package:wildlife_nl_app/models/data/interaction.dart';

var uuid = const Uuid();

class Incident {
  final String id = uuid.v4();
  final String animal;
  final String title;
  final DateTime dateTime;
  final String description;
  final Point location;

  Incident({
    required this.animal,
    required this.title,
    required this.dateTime,
    required this.description,
    required this.location,
  });

  factory Incident.fromInteraction(Interaction interaction) => Incident(
        animal: "Deer",
        dateTime: interaction.interactionTime,
        location: Point(coordinates: [
          interaction.interactionLat ?? 0,
          interaction.interactionLon ?? 0
        ]),
        title: interaction.interactionType ?? "",
        description: interaction.interactionDescription ?? "",
      );
}
