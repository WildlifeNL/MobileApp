import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:option_result/result.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wildlife_nl_app/flavors.dart';
import 'package:wildlife_nl_app/models/animal.dart';

part 'animal_types.g.dart';

@riverpod
class AnimalTypes extends _$AnimalTypes {
  @override
  Future<List<Animal>> build() async {
    var response = await getAnimalTypes(accessToken: "");

    if (response.isOk()) {
      return response();
    } else {
      throw Exception(response.unwrapErr());
    }
  }

  static Future<Result<List<Animal>, String>> getAnimalTypes(
      {required String accessToken}) async {
    var response = await http.get(Uri.parse(
        "${F.apiUrl}api/controllers/animals.php?page=1&count=99999999999999"));

    //Example validation
    if (response.statusCode != 200) {
      return Err("HTTP status code was not 200: ${response.body}");
    }

    return Ok(PaginatedAnimals.fromJson(jsonDecode(response.body)).results);
  }
}
