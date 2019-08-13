import 'package:flutter/material.dart';
import 'package:wan_android/common/route_table_const.dart';
import 'package:wan_android/net/wan_android_http_client.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_android/model/user_center.dart';
import 'package:wan_android/common/shared_preference.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  GlobalKey _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouteTableConst.REGISTER_PAGE);
              },
              child: Text(
                '注册',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Form(
          child: Column(children: <Widget>[
            TextFormField(
              autofocus: true,
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText: '用户名', hintText: '用户名', icon: Icon(Icons.person)),
              validator: (v) {
                return v.trim().length > 0 ? null : '用户名不能为空';
              },
            ),
            TextFormField(
              autofocus: true,
              controller: _passwordController,
              decoration: InputDecoration(
                  labelText: '密码', hintText: '密码', icon: Icon(Icons.lock)),
              obscureText: true,
              validator: (v) {
                return v.trim().length > 0 ? null : '密码不能为空';
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      padding: EdgeInsets.all(15.0),
                      child: Text("登录"),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () {
                        if ((_formKey.currentState as FormState).validate()) {
                          login(_usernameController.text,
                              _passwordController.text);
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
    );
  }

  void login(String username, String password) {
    ApiClient apiClient = ApiClient.getInstance();
    Map<String, dynamic> queryParameters = {
      'username': username,
      'password': password,
    };
    apiClient
        .postRequest('https://www.wanandroid.com/user/login', queryParameters)
        .then((val) {
      BaseModel registerModel = BaseModel.fromJson(val);
      if (registerModel.errorCode < 0) {
        Fluttertoast.showToast(msg: registerModel.errorMsg);
      } else {
        Fluttertoast.showToast(msg: '登录成功');
        KvStores.save(KeyConst.USER_NAME, username);
        KvStores.save(KeyConst.PASSWORD, password);
        KvStores.save(KeyConst.LOGIN, true);
        Navigator.of(context).pop();
      }
    });
  }
}
