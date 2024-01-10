import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/services/interaction.dart';

part 'interaction_types.g.dart';

@riverpod
class InteractionTypes extends _$InteractionTypes {
  @override
  Future<List<InteractionType>> build() async {
    var response = await InteractionService.getInteractionTypes(userId: "");

    if (response.isOk()) {
      return response();
    } else {
      throw Exception(response.unwrapErr());
    }
  }
}
