import 'dart:convert';

import 'package:dart_casing/dart_casing.dart';
import 'package:http/http.dart' as http;
import 'package:option_result/option_result.dart';
import 'package:wildlife_nl_app/flavors.dart';
import 'package:wildlife_nl_app/models/interaction.dart';
import 'package:wildlife_nl_app/models/interaction_type.dart';

class InteractionService {
  static Future<Result<PaginatedInteractions, String>> getInteractions(
      int page, int pageCount,
      {required String userId}) async {
    var response = await http.get(Uri.parse(
        "${F.apiUrl}api/controllers/interactions.php?userId=$userId&page=$page&count=$pageCount"));

    //Example validation
    if (response.statusCode != 200) {
      return Err("HTTP status code was not 200: ${response.body}");
    }

    return Ok(PaginatedInteractions.fromJson(response.body));
  }


  // static Future<Result<PaginatedInteractions, String>> getInteractionsByType(
  //     InteractionTypeKey type, int page, int pageCount,
  //     {required String accessToken}) async {
  //   return Ok(PaginatedInteractions(results: [
  //
  //   ], meta: PaginatedMeta(nextPageUrl: null, lastPageUrl: null)));
  // }

  static Future<Result<PaginatedInteractions, String>> getInteractionsByType(
      InteractionTypeKey type, int page, int pageCount,
      {required String userId}) async {
    var response = await http.get(Uri.parse(
        "${F.apiUrl}api/controllers/interactions.php?type=${Casing.snakeCase(type.name)}&page=$page&count=$pageCount&userId=$userId"));

    //Example validation
    if (response.statusCode != 200) {
      return Err("Interactions status code was not 200: ${response.body}");
    }

    return Ok(PaginatedInteractions.fromJson(response.body));
  }

  static Future<Result<List<InteractionType>, String>> getInteractionTypes({required String userId}) async {
    var response = await http.get(Uri.parse(
        "${F.apiUrl}api/controllers/interactions.php/types"));

    //Example validation
    if (response.statusCode != 200) {
      return Err("HTTP status code was not 200: ${response.body}");
    }

    Iterable lol = jsonDecode(response.body);

    return Ok(lol.map((e) => InteractionType.fromJson(e)).toList());
  }
}
