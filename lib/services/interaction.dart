import 'package:http/http.dart' as http;
import 'package:option_result/option_result.dart';
import 'package:wildlife_nl_app/flavors.dart';
import 'package:wildlife_nl_app/models/interaction.dart';

class InteractionService {
  static Future<Result<PaginatedInteractions, String>> getInteractionsByUserId(
      String userId, int page, int pageCount,
      {required String accessToken}) async {
    var response = await http.get(Uri.parse(
        "${F.apiUrl}api/controllers/interactions.php?userId=$userId&page=$page&count=$pageCount"));

    //Example validation
    if (response.statusCode != 200) {
      return Err("HTTP status code was not 200: ${response.body}");
    }

    return Ok(PaginatedInteractions.fromJson(response.body));
  }

  static Future<Result<PaginatedInteractions, String>> getInteractions(
      int page, int pageCount,
      {required String accessToken}) async {
    var response = await http.get(Uri.parse(
        "${F.apiUrl}api/controllers/interactions.php?page=$page&count=$pageCount"));

    //Example validation
    if (response.statusCode != 200) {
      return Err("HTTP status code was not 200: ${response.body}");
    }

    return Ok(PaginatedInteractions.fromJson(response.body));
  }

  static Future<Result<PaginatedInteractions, String>> getInteractionsByType(
      InteractionType type, int page, int pageCount,
      {required String accessToken}) async {
    var response = await http.get(Uri.parse(
        "${F.apiUrl}api/controllers/interactions.php?type=${type.toSnakeCaseString()}&page=$page&count=$pageCount"));

    //Example validation
    if (response.statusCode != 200) {
      return Err("HTTP status code was not 200: ${response.body}");
    }

    return Ok(PaginatedInteractions.fromJson(response.body));
  }
}
