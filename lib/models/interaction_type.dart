import 'dart:convert';

import 'package:dart_casing/dart_casing.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'interaction_type.g.dart';
part 'interaction_type.freezed.dart';

@freezed
class InteractionType with _$InteractionType {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory InteractionType({
    required String id,
    required String label,
    required InteractionTypeKey typeKey,
    required String color,
  }) = _InteractionType;

  factory InteractionType.fromJson(Map<String, Object?> json) => _$InteractionTypeFromJson(json);
}

extension InteractionTypeExtensions on InteractionType {
  Color getColor(){
    return Color(int.parse(color.replaceAll('#', '0xff')));
  }

  String getSnakeCaseType() {
    return Casing.snakeCase(typeKey.name);
  }
}

@JsonEnum(fieldRename: FieldRename.snake)
enum InteractionTypeKey {
  sighting,
  damage,
  inappropriateBehaviour,
  traffic,
  maintenance,
}