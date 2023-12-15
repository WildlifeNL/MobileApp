import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:wildlife_nl_app/models/paginated_response.dart';

part 'interaction.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Interaction {
  final String id;
  final String userId;
  final String interactionType;
  final DateTime time;
  final String? image;
  final String lat;
  final String lon;
  final String? description;
  final String? distance;
  final String? duration;
  final DateTime? creationDate;
  final DateTime? lastModified;
  final String? animalId;
  final String? animalCountLower;

  final String? animalCountUpper;

  final String? juvenileCountLower;

  final String? juvenileCountUpper;

  final String? trafficEvent;

  Interaction({
    required this.id,
    required this.userId,
    required this.animalId,
    required this.interactionType,
    required this.time,
    required this.image,
    required this.description,
    required this.distance,
    required this.duration,
    required this.creationDate,
    required this.lastModified,
    required this.lat,
    required this.lon,
    required this.animalCountLower,
    required this.animalCountUpper,
    required this.juvenileCountLower,
    required this.juvenileCountUpper,
    required this.trafficEvent,
  });

  factory Interaction.fromJson(Map<String,dynamic> json) =>
      _$InteractionFromJson(json);

  Map<String,dynamic> toJson() => _$InteractionToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginatedInteractions extends PaginatedResponse<Interaction> {
  PaginatedInteractions({required super.results, required super.meta});

  factory PaginatedInteractions.fromJson(String json) =>
      _$PaginatedInteractionsFromJson(jsonDecode(json));

  String toJson() => jsonEncode(_$PaginatedInteractionsToJson(this));
}
