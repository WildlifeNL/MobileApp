import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:wildlife_nl_app/models/paginated_response.dart';

part 'interaction.g.dart';

@JsonSerializable()
class Interaction {
  final String userId;

  Interaction({required this.userId});

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