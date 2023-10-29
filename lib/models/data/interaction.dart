import 'package:json_annotation/json_annotation.dart';

part 'interaction.g.dart';

@JsonSerializable()
class Interaction {
  String id;
  DateTime interactionTime;
  double? interactionLat;
  double? interactionLon;
  String? interactionDescription;
  String? interactionEncounter;
  int? interactionDistance;
  int? interactionDuration;
  int? interactionRating;
  String? interactionType;
  String? animalId;
  int? animalCount;
  int? animalJuvenileCount;
  String? animalActivity;
  String? animalEmotion;
  String? humanActivity;
  String? humanEmotion;

  Interaction({
    required this.id,
    required this.interactionTime,
    this.interactionLat,
    this.interactionLon,
    this.interactionDescription,
    this.interactionEncounter,
    this.interactionDistance,
    this.interactionDuration,
    this.interactionRating,
    this.interactionType,
    this.animalId,
    this.animalCount,
    this.animalJuvenileCount,
    this.animalActivity,
    this.animalEmotion,
    this.humanActivity,
    this.humanEmotion,
  });

  factory Interaction.fromJson(Map<String, dynamic> json) =>
      _$InteractionFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic>? toJson() => _$InteractionToJson(this);
}
