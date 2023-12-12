import 'dart:convert';

import 'package:dart_casing/dart_casing.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'interaction_type.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class InteractionType {
  final String id;
  final String label;
  final InteractionTypeKey typeKey;
  final String color;

  InteractionType({required this.id, required this.label, required this.typeKey, required this.color});


  factory InteractionType.fromJsonString(String json) =>
      _$InteractionTypeFromJson(jsonDecode(json));
  factory InteractionType.fromJson(Map<String, dynamic> json) =>
      _$InteractionTypeFromJson(json);

  Map<String, dynamic> toJson() => _$InteractionTypeToJson(this);

  String toJsonString() => jsonEncode(_$InteractionTypeToJson(this));

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