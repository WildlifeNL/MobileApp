import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:wildlife_nl_app/models/paginated_response.dart';

part 'animal.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class Animal {
  final String id;
  final String name;
  final String? image;
  final List<dynamic>? specifications;
  final DateTime? creationDate;
  final DateTime? lastModified;
  factory Animal.fromJsonString(String json) =>
      _$AnimalFromJson(jsonDecode(json));

  factory Animal.fromJson(Map<String, dynamic> json) =>
      _$AnimalFromJson(json);

  Animal({required this.id, required this.name, required this.image, required this.specifications, required this.creationDate, required this.lastModified});

  Map<String, dynamic> toJson() => _$AnimalToJson(this);
  String toJsonString() => jsonEncode(_$AnimalToJson(this));
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginatedAnimals extends PaginatedResponse<Animal> {
  PaginatedAnimals({required super.results, required super.meta});

  factory PaginatedAnimals.fromJson(Map<String, dynamic> json) =>
      _$PaginatedAnimalsFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedAnimalsToJson(this);

  factory PaginatedAnimals.fromJsonString(String json) =>
      _$PaginatedAnimalsFromJson(jsonDecode(json));

  String toJsonString() => jsonEncode(_$PaginatedAnimalsToJson(this));
}
