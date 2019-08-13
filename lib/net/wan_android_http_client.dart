import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ApiClient {
  static const int TIMEOUT = 5000;

  static ApiClient _apiClient = ApiClient._();

  Dio dio;

  ApiClient._() {
    dio = Dio();
    dio.options.connectTimeout = TIMEOUT;
    dio.options.receiveTimeout = TIMEOUT;
    dio.options.responseType = ResponseType.json;
    getCookiePath().then((val) {
      dio.interceptors
          .add(CookieManager(PersistCookieJar(dir: val, ignoreExpires: true)));
    });
  }

  Future<String> getCookiePath() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  static ApiClient getInstance() {
    return _apiClient;
  }

  Future<Map<String, dynamic>> getResponse(String url) async {
    var response = await dio.get(url);
    if (response.statusCode != 200) {
      throw Exception('$url wrong ${response.statusMessage}');
    } else {
      return response.data;
    }
  }

  Future<Map<String, dynamic>> postRequest(
      String url, Map<String, dynamic> queryParemeters) async {
    var response = await dio.post(url, queryParameters: queryParemeters);
    if (response.statusCode != 200) {
      throw Exception('$url wrong ${response.statusMessage}');
    } else {
      return response.data;
    }
  }
}
