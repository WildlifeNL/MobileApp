import 'dart:developer' as developer;

import 'package:option_result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/models/example_by_id.dart';
import 'package:wildlife_nl_app/utilities/cache_ref.dart';

import '../services/example.dart';

part "example_by_id.g.dart";

@riverpod
class GetExampleById extends _$GetExampleById {
  @override
  Future<Result<GetExampleByIdResponse, String>> build(int id) async {
    //Access token is not used for the example
    var response = await ExampleService.getExampleById(id, accessToken: "");

    switch (response) {
      case Ok():
        ref.cache(const Duration(seconds: 5));
      case Err():
        developer.log(response.unwrapErr());
    }

    return response;
  }
}
