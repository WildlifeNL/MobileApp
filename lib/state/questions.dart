import 'package:http/http.dart' as http;
import 'package:option_result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/flavors.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/models/question.dart';

part 'questions.g.dart';

@riverpod
class Questions extends _$Questions {
  @override
  Future<List<Question>> build(InteractionType type) async {
    var response = await getQuestions(type, accessToken: "");

    if (response.isOk()) {
      return response();
    } else {
      throw Exception(response.unwrapErr());
    }
  }

  static Future<Result<List<Question>, String>> getQuestions(
      InteractionType type,
      {required String accessToken}) async {
    List<Question> staticQuestions = [];

    if (type.typeKey == InteractionTypeKey.sighting ||
        type.typeKey == InteractionTypeKey.traffic) {
      staticQuestions = staticQuestions.followedBy([
        const Question(
            type: 'dropdown',
            question: 'Volwassen dieren:',
            isOptional: false,
            placeholder: '',
            specifications: ["0", "1", "2", "3", "4", "5+"],
            questionOrder: 0,
            interactionTypes: ['86a6b56a-89f0-11ee-919a-1e0034001676'],
            userTypes: [],
            isActive: true,
            animalId: null,
            id: '',
            creationDate: null,
            lastModified: null),
        const Question(
            type: 'dropdown',
            question: 'Jonge dieren:',
            isOptional: false,
            placeholder: '',
            specifications: ["0", "1", "2", "3", "4", "5+"],
            questionOrder: 0,
            interactionTypes: ['86a6b56a-89f0-11ee-919a-1e0034001676'],
            userTypes: [],
            isActive: true,
            animalId: null,
            id: '',
            creationDate: null,
            lastModified: null)
      ]).toList();
    }

    var response = await http.get(Uri.parse(
        "${F.apiUrl}api/controllers/questions.php?count=99999999999999"));

    //Example validation
    if (response.statusCode != 200) {
      return Err("HTTP status code was not 200: ${response.body}");
    }

    var questions = staticQuestions
        .followedBy(PaginatedQuestions.fromJson(response.body).results).toList();

    questions = questions.where((element) => element.interactionTypes.contains(type.id)).toList();

    questions.sort((a, b) => a.questionOrder.compareTo(b.questionOrder));

    return Ok(questions);
  }
}
