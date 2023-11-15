import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'paginated_response.g.dart';

abstract class PaginatedResponse<T> {
  final List<T> results;
  final PaginatedMeta meta;

  PaginatedResponse({required this.results, required this.meta});
}

@JsonSerializable()
class PaginatedMeta {
  final String? nextPageUrl;
  final String? lastPageUrl;

  PaginatedMeta({required this.nextPageUrl, required this.lastPageUrl});

  factory PaginatedMeta.fromJson(String json) =>
      _$PaginatedMetaFromJson(jsonDecode(json));

  String toJson() => jsonEncode(_$PaginatedMetaToJson(this));
}
