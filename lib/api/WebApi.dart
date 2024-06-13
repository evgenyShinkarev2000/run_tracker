import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:run_tracker/data/models/models.dart';

class WebApi {
  final Uri baseUrl = Uri(scheme: "http", host: "10.0.2.2", port: 5222);
  late final _client = Dio(BaseOptions(
    baseUrl: "$baseUrl/",
    contentType: "application/json",
    headers: {
      "id": 0,
    },
  ));

  Future<int> shareRunCover(RunCoverData runCover) async {
    try {
      final dto = runCoverToDto(runCover);
      final response = await _client.post("RunCover/Share", data: dto);
      if (response.statusCode == 200) {
        return response.data;
      }

      throw Exception(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Uri buildShareUri(int runCoverExternalId) {
    return Uri.parse("http://10.0.2.2:5173/RunCover/$runCoverExternalId");
  }
}

String runCoverToDto(RunCoverData runCoverData) {
  final map = runCoverData.toJson();
  map["key"] = runCoverData.key;
  map["start"] = runCoverData.startDateTime.toIso8601String();
  map.remove("startDateTime");

  final t = jsonEncode(map);

  return t;
}
