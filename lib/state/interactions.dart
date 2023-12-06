import 'package:option_result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/models/interaction.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/services/interaction.dart';

part 'interactions.g.dart';

class InteractionState {
  final int currentPage;
  final bool hasNextPage;
  final bool isLoadingNewPage;

  final List<Interaction> items;

  InteractionState({
    required this.items,
    required this.currentPage,
    required this.hasNextPage,
    required this.isLoadingNewPage,
  });

  InteractionState copyWith({
    List<Interaction>? items,
    int? currentPage,
    bool? hasNextPage,
    bool? isLoadingNewPage,
  }) =>
      InteractionState(
        items: items ?? this.items,
        currentPage: currentPage ?? this.currentPage,
        hasNextPage: hasNextPage ?? this.hasNextPage,
        isLoadingNewPage: isLoadingNewPage ?? this.isLoadingNewPage,
      );
}

@riverpod
class Interactions extends _$Interactions {
  @override
  Future<InteractionState> build(InteractionType? activityType) async {
    Result<PaginatedInteractions, String> response;
    if(activityType != null){
      response = await InteractionService.getInteractionsByType(activityType.typeKey,1, 10, accessToken: "");
    } else {
      response = await InteractionService.getInteractions(1, 10, accessToken: "");
    }

    if (response.isOk()) {
      var paginatedInteractions = response.unwrap();
      return InteractionState(
        items: paginatedInteractions.results,
        hasNextPage: paginatedInteractions.meta.nextPageUrl != null,
        currentPage: 1,
        isLoadingNewPage: false,
      );
    } else {
      throw Exception(response.unwrapErr());
    }
  }

  Future<void> getNextPage() async {
    if (state.value == null ||
        state.requireValue.isLoadingNewPage ||
        !state.requireValue.hasNextPage) return;
    state = AsyncData(state.value!.copyWith(isLoadingNewPage: true));
    var response = await InteractionService.getInteractions(
      state.requireValue.currentPage + 1,
      10,
      accessToken: "",
    );

    if (response.isOk()) {
      var paginatedInteractions = response.unwrap();

      state = AsyncData(
        InteractionState(
            items: [
              ...state.requireValue.items,
              ...paginatedInteractions.results
            ],
            hasNextPage: paginatedInteractions.meta.nextPageUrl != null,
            currentPage: state.requireValue.currentPage + 1,
            isLoadingNewPage: false),
      );
    } else {
      state = AsyncData(state.value!.copyWith(isLoadingNewPage: false));
    }
  }
}
