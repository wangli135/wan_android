import 'package:dio/dio.dart';
import 'dart:convert';

class ApiClient {
  static const int TIMEOUT = 5000;

  static ApiClient apiClient = ApiClient._();

  Dio dio;

  ApiClient._() {
    dio = Dio();
    dio.options.connectTimeout = TIMEOUT;
    dio.options.receiveTimeout = TIMEOUT;
    dio.options.responseType = ResponseType.json;
  }

  static ApiClient getInstance() {
    return apiClient;
  }


  Future<Map<String, dynamic>> getResponse(String url) async {
    var response = await dio.get(url);
    if (response.statusCode != 200) {
      throw Exception('$url wrong ${response.statusMessage}');
    } else {
      return response.data;
    }
  }
}