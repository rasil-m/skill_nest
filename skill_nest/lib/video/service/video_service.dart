import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:skill_nest/response.dart';
import 'package:skill_nest/video/model/video_model.dart';

class VideoService {
  Future<Object> fetchVideos({required int moduleId}) async {
    Dio _dio = Dio();

    try {
      var response = await _dio.get(
        "https://trogon.info/interview/php/api/videos.php?module_id=$moduleId",
      );

      if (response.statusCode == 200) {
        print('Videos fetched: ${response.data}');

        List<Video> videos = (json.decode(response.data) as List)
            .map((e) => Video.fromJson(e))
            .toList();

        return Success(
          code: 200,
          response: videos,
        );
      }

      return Failure(
        code: response.statusCode ?? 100,
        response: "Failed to load videos",
      );
    } catch (e) {
      return Failure(
        code: 0,
        response: e.toString(),
      );
    }
  }
}
