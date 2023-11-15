import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:wildlife_nl_app/models/paginated_response.dart';

part 'interaction.g.dart';

@JsonSerializable()
class Interaction {
  final String id;
  final String userId;
  final String animalId;
  final InteractionType type;
  final DateTime time;
  final String? image;
  final String description;
  final int? distance;
  final int? duration;
  final DateTime creationDate;
  final DateTime lastModified;
  final double lat;
  final double lon;

  Interaction({
    required this.id,
    required this.userId,
    required this.animalId,
    required this.type,
    required this.time,
    required this.image,
    required this.description,
    required this.distance,
    required this.duration,
    required this.creationDate,
    required this.lastModified,
    required this.lat,
    required this.lon,
  });

  factory Interaction.fromJson(String json) =>
      _$InteractionFromJson(jsonDecode(json));

  String toJson() => jsonEncode(_$InteractionToJson(this));
}

@JsonSerializable()
class PaginatedInteractions extends PaginatedResponse<Interaction> {
  PaginatedInteractions({required super.results, required super.meta});

  factory PaginatedInteractions.fromJson(String json) =>
      _$PaginatedInteractionsFromJson(jsonDecode(json));

  String toJson() => jsonEncode(_$PaginatedInteractionsToJson(this));
}

enum InteractionType {
  @JsonValue("sighting")
  sighting,
  @JsonValue("incident")
  incident,
  @JsonValue("inappropriate_behaviour")
  inappropriateBehaviour,
}

extension ParseToSnakeCaseString on InteractionType {
  String toSnakeCaseString() {
    switch (this) {
      case InteractionType.sighting:
        return "sighting";
      case InteractionType.incident:
        return "incident";
      case InteractionType.inappropriateBehaviour:
        return "inappropriate_behaviour";
    }
  }
}
