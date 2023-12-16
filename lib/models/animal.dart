import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wildlife_nl_app/models/paginated_response.dart';

part 'animal.freezed.dart';

part 'animal.g.dart';

@freezed
class Animal with _$Animal {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Animal({
    required String id,
    required String name,
    required String? image,
    required List<dynamic>? specifications,
    required DateTime? creationDate,
    required DateTime? lastModified,
  }) = _Animal;

  factory Animal.fromJson(Map<String, Object?> json) => _$AnimalFromJson(json);
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
