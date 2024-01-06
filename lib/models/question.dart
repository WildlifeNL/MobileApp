import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wildlife_nl_app/models/paginated_response.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question with _$Question {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Question({
    required String id,
    required String type,
    required List<String> interactionTypes,
    required List<String> userTypes,
    required bool isActive,
    required bool isOptional,
    required String question,
    required String? animalId,
    required List<String> specifications,
    required String? placeholder,
    required DateTime? creationDate,
    required DateTime? lastModified,
    required int questionOrder,
  }) = _Question;

  factory Question.fromJson(Map<String, Object?> json) =>
      _$QuestionFromJson(json);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginatedQuestions extends PaginatedResponse<Question> {
  PaginatedQuestions({required super.results, required super.meta});

  factory PaginatedQuestions.fromJson(String json) =>
      _$PaginatedQuestionsFromJson(jsonDecode(json));

  String toJson() => jsonEncode(_$PaginatedQuestionsToJson(this));
}