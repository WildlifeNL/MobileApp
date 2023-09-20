import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:option_result/option_result.dart';
import 'package:wildlife_nl_app/models/example_by_id.dart';

class ExampleService {
  static Future<Result<GetExampleByIdResponse, String>> getExampleById(int id,
      {required String accessToken}) async {
    var response = await http.get(Uri.https("dummyjson.com", "/products/$id"));

    //Example validation
    if (response.statusCode != 200) {
      return Err("HTTP status code was not 200");
    }

    return Ok(GetExampleByIdResponse.fromJson(jsonDecode(response.body)));
  }
}
