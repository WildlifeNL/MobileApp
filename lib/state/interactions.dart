import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:option_result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/models/interaction.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';
import 'package:wildlife_nl_app/services/interaction.dart';

part 'interactions.g.dart';
part 'interactions.freezed.dart';


@freezed
class InteractionState with _$InteractionState {
  const factory InteractionState({
    required int currentPage,
    required bool hasNextPage,
    required bool isLoadingNewPage,
    required List<Interaction> items,
  }) = _InteractionState;

  factory InteractionState.fromJson(Map<String, Object?> json)
  => _$InteractionStateFromJson(json);
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

@riverpod
class MapInteractions extends _$MapInteractions {
  @override
  Future<InteractionState> build() async {
    Result<PaginatedInteractions, String> response;
    response = await InteractionService.getInteractions(1, 9999, accessToken: "");

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


}
