import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:skill_nest/home/model/subject_model.dart';
import 'package:skill_nest/response.dart';

class HomeService {
  Future<Object> fetchSubjects() async {
    Dio _dio = Dio();
    try {
      var response = await _dio.get(
        "https://trogon.info/interview/php/api/subjects.php",
      );
      if (response.statusCode == 200) {
        List<Subject> subjects = (json.decode(response.data) as List)
            .map((e) => Subject.fromJson(e))
            .toList();

        return Success(
          code: 200,
          response: subjects,
        );
      }
      return Failure(code: response.statusCode!, response: "Failure");
    } catch (e) {
      print("Error is $e");
      return Failure(
        code: 0,
        response: e.toString(),
      );
    }
  }
}
