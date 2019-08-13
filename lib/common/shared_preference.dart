import 'package:shared_preferences/shared_preferences.dart';

class KeyConst {
  static String USER_NAME = "username";
  static String PASSWORD = "password";
  static String LOGIN = "login";
}

class KvStores {
  static save(String key, dynamic value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (value is bool) {
      sharedPreferences.setBool(key, value);
    } else if (value is String) {
      sharedPreferences.setString(key, value);
    } else if (value is int) {
      sharedPreferences.setInt(key, value);
    } else if (value is double) {
      sharedPreferences.setDouble(key, value);
    } else if (value is List<String>) {
      sharedPreferences.setStringList(key, value);
    } else {
      throw Exception('不支持${value.runtimeType}类型');
    }
  }

  static dynamic get(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }
}
