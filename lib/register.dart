import 'package:flutter/material.dart';
import 'package:wan_android/net/wan_android_http_client.dart';
import 'package:wan_android/model/user_center.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_android/common/route_table_const.dart';

class RegisterWidget extends StatefulWidget {
  @override
  _RegisterWidgetState createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _repasswordController = TextEditingController();

  GlobalKey _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Form(
            child: Column(children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: '用户名',
                    hintText: '用户名',
                    icon: Icon(Icons.person)),
                validator: (v) {
                  return v.trim().length > 0 ? null : '用户名不能为空';
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                    labelText: '密码', hintText: '密码', icon: Icon(Icons.lock)),
                obscureText: true,
                validator: (v) {
                  return v.trim().length > 0
                      ? (v.length > 5 ? null : '密码长度不能少于6位')
                      : '密码不能为空';
                },
              ),
              TextFormField(
                controller: _repasswordController,
                decoration: InputDecoration(
                    labelText: '确认密码',
                    hintText: '密码确认',
                    icon: Icon(Icons.lock)),
                obscureText: true,
                validator: (v) {
                  return v.trim().length > 0
                      ? (v == _passwordController.text ? null : '两次密码不相同')
                      : '密码不能为空';
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text("注册"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          if ((_formKey.currentState as FormState).validate()) {
                            register(
                                _usernameController.text,
                                _passwordController.text,
                                _repasswordController.text);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ]),
            key: _formKey,
            autovalidate: true,
          ),
        ),
      ),
    );
  }

  void register(String userName, String password, String repassword) {
    ApiClient apiClient = ApiClient.getInstance();
    Map<String, dynamic> queryParameters = {
      'username': userName,
      'password': password,
      'repassword': repassword
    };
    apiClient
        .postRequest(
            'https://www.wanandroid.com/user/register', queryParameters)
        .then((val) {
      BaseModel registerModel = BaseModel.fromJson(val);
      if (registerModel.errorCode < 0) {
        Fluttertoast.showToast(msg: registerModel.errorMsg);
      } else {
        Fluttertoast.showToast(msg: '注册成功');
        Navigator.of(context).pop();
      }
    });
  }
}
