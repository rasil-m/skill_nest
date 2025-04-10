import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:skill_nest/modules/model/module_model.dart';
import 'package:skill_nest/response.dart';

class ModulesService {
  Future<Object> fetchChapters({required int subjectId}) async {
    Dio _dio = Dio();
    try {
      var response = await _dio.get(
        "https://trogon.info/interview/php/api/modules.php?subject_id=$subjectId",
      );

      if (response.statusCode == 200) {
        print('Chapters fetched: ${response.data}');

        // Decode the JSON string if necessary
        List<Modules> chapters = (json.decode(response.data) as List)
            .map((e) => Modules.fromJson(e))
            .toList();

        return Success(
          code: 200,
          response: chapters,
        );
      }

      return Failure(
        code: response.statusCode!,
        response: "Failed to load chapters",
      );
    } catch (e) {
      return Failure(code: 0, response: e.toString());
    }
  }
}
