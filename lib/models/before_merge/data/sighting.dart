import 'package:uuid/uuid.dart';
import 'package:wildlife_nl_app/models/before_merge/data/geojson/point.dart';
import 'package:wildlife_nl_app/models/before_merge/data/interaction.dart';

var uuid = const Uuid();

class Sighting {
  final String id = uuid.v4();
  final String animal;
  final int animalCount;
  final String locationName;
  final DateTime dateTime;
  final Point location;

  Sighting({
    required this.animal,
    required this.animalCount,
    required this.locationName,
    required this.dateTime,
    required this.location,
  });

  factory Sighting.fromInteraction(Interaction interaction) => Sighting(
      animal: "Deer",
      animalCount: (interaction.animalCount ?? 0) +
          (interaction.animalJuvenileCount ?? 0),
      locationName: "Not available",
      dateTime: interaction.interactionTime,
      location: Point(coordinates: [
        interaction.interactionLat ?? 0,
        interaction.interactionLon ?? 0
      ]));
}
