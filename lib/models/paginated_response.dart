import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'paginated_response.g.dart';

abstract class PaginatedResponse<T> {
  final List<T> results;
  final PaginatedMeta meta;

  PaginatedResponse({required this.results, required this.meta});
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginatedMeta {
  final String? nextPageUrl;
  final String? previousPageUrl;

  PaginatedMeta({required this.nextPageUrl, required this.previousPageUrl});

  factory PaginatedMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginatedMetaFromJson(json);

  Map<String, dynamic> toJson() => _$PaginatedMetaToJson(this);
}
