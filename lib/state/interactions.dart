import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/models/interaction.dart';
import 'package:wildlife_nl_app/services/interaction.dart';

part 'interactions.g.dart';

@riverpod
class Interactions extends _$Interactions {
  int currentPage = 0;
  bool hasNextPage = true;
  bool isLoadingNewPage = true;

  @override
  Future<List<Interaction>> build() async {
    List<Interaction> interactions = [];
    var response = await InteractionService.getInteractions(currentPage, 20,
        accessToken: "");

    if (response.isOk()) {
      var paginatedInteractions = response.unwrap();
      interactions.addAll(paginatedInteractions.results);
      hasNextPage = paginatedInteractions.meta.nextPageUrl != null;
    }

    currentPage++;
    isLoadingNewPage = false;
    return interactions;
  }

  Future<void> getNextPage() async {
    if (isLoadingNewPage && hasNextPage) return;
    isLoadingNewPage = true;
    List<Interaction> interactions = state.value!.toList();
    var response = await InteractionService.getInteractions(currentPage, 20,
        accessToken: "");

    if (response.isOk()) {
      var paginatedInteractions = response.unwrap();
      interactions.addAll(paginatedInteractions.results);
      hasNextPage = paginatedInteractions.meta.nextPageUrl != null;
    }

    state = AsyncData(interactions);
    currentPage++;
    isLoadingNewPage = false;
  }
}
