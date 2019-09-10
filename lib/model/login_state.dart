import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginState with ChangeNotifier {
  bool _isLogin = false;
  String _userName = "";

  bool isLogin() => _isLogin;

  String getUserName() => _userName;

  void login(String name) {
    _isLogin = true;
    _userName = name;
    notifyListeners();
  }

  void logout() {
    _isLogin = false;
    _userName = null;
    notifyListeners();
  }
}
