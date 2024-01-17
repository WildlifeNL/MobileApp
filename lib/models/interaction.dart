import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wildlife_nl_app/models/paginated_response.dart';

part 'interaction.freezed.dart';

part 'interaction.g.dart';

@freezed
class Interaction with _$Interaction {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Interaction({
    required String id,
    required String userId,
    required String interactionType,
    required DateTime time,
    required String? image,
    required String lat,
    required String lon,
    required String? description,
    required String? distance,
    required String? duration,
    required DateTime? creationDate,
    required DateTime? lastModified,
    required String? animalId,
    required String? animalCountLower,
    required String? animalCountUpper,
    @JsonKey(name: "juvenil_animal_count_lower")
    required String? juvenileAnimalCountLower,
    @JsonKey(name: "juvenil_animal_count_upper")
    required String? juvenileAnimalCountUpper,
    required String? trafficEvent,
    required List<InteractionQuestion> questions,
  }) = _Interaction;

  factory Interaction.fromJson(Map<String, Object?> json) =>
      _$InteractionFromJson(json);
}

@freezed
class InteractionQuestion with _$InteractionQuestion {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory InteractionQuestion({
    required String id,
    required String questionId,
    required String interactionId,
    required String answer,
  }) = _InteractionQuestion;

  factory InteractionQuestion.fromJson(Map<String, Object?> json) =>
      _$InteractionQuestionFromJson(json);
}

extension InteractionQuestionExtensions on InteractionQuestion {
  List<String> getAnswers({bool isModal=false}) {
    var answers = (jsonDecode(answer) as List<dynamic>).cast<String>();

    if(answers.isEmpty && isModal){
      answers.add("Geen antwoord gegeven");
    }

    return answers;
  }

  String? getAnswer({bool isModal=false}) {
    var newAnswer = (jsonDecode(answer) as List<dynamic>).cast<String>().firstOrNull;
    return isModal ? newAnswer ?? "Geen antwoord gegeven" : newAnswer;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PaginatedInteractions extends PaginatedResponse<Interaction> {
  PaginatedInteractions({required super.results, required super.meta});

  factory PaginatedInteractions.fromJson(String json) =>
      _$PaginatedInteractionsFromJson(jsonDecode(json));

  String toJson() => jsonEncode(_$PaginatedInteractionsToJson(this));
}
