import 'package:flutter/material.dart';
import 'package:wan_android/home_page.dart';
import 'package:wan_android/knowledge_system.dart';
import 'package:wan_android/hot_page.dart';
import 'package:wan_android/wechat.dart';
import 'package:wan_android/ali_icon.dart';
import 'package:wan_android/net/wan_android_http_client.dart';
import 'package:wan_android/model/home_page_model.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '玩Android',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<BottomNavigationBarItem> _bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
    BottomNavigationBarItem(icon: Icon(Icons.pages), title: Text('知识体系')),
    BottomNavigationBarItem(icon: Icon(AliIcons.wechat), title: Text('公众号')),
  ];

  List<Widget> _mainBody = [
    HomePageWidget(),
    KnowledgeSystemWidget(),
    WeChatWidget()
  ];

  int _selectBottomIndex = 0;
  bool _isHotShowPage;

  @override
  void initState() {
    super.initState();
    _selectBottomIndex = 0;
    _isHotShowPage = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _bottomItems[_selectBottomIndex].title,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      drawer: Drawer(
        child: LeftDrawer(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomItems,
        currentIndex: _selectBottomIndex,
        onTap: (index) {
          setState(() {
            _isHotShowPage = false;
            _selectBottomIndex = index;
          });
        },
      ),
      body: _getBodyWidget(),
    );
  }

  Widget _getBodyWidget() {
    if (_isHotShowPage) {
      return HotPageWidget();
    } else {
      return _mainBody[_selectBottomIndex];
    }
  }
}

class LeftDrawer extends StatefulWidget {
  @override
  _LeftDrawerState createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
//          SizedBox(
//            height: 240,
//            child: Stack(
//              alignment: AlignmentDirectional.center,
//              fit: StackFit.expand,
//              children: <Widget>[
//                Container(
//                  color: Colors.blue,
//                  height: 240,
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.center,
//                    children: <Widget>[
//                      FlutterLogo(
//                        size: 70,
//                      ),
//                      Padding(padding: EdgeInsets.all(12)),
//                      Text(
//                        '未登录',
//                        style: TextStyle(color: Colors.white, fontSize: 20),
//                      )
//                    ],
//                  ),
//                ),
//                Positioned(
//                    right: 16,
//                    bottom: 16,
//                    child: FlatButton(
//                        onPressed: () {},
//                        child: Text(
//                          '点击登录',
//                          style: TextStyle(color: Colors.white),
//                        )))
//              ],
//            ),
//          ),
          DrawerHeader(
            child: Stack(
              alignment: AlignmentDirectional.center,
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlutterLogo(
                        size: 48,
                      ),
                      Padding(padding: EdgeInsets.all(8)),
                      Text(
                        '未登录',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
                Positioned(
                    right: 1,
                    bottom: 1,
                    child: FlatButton(
                        onPressed: () {},
                        child: Text(
                          '点击登录',
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('我喜欢的'),
            onTap: () {
              ApiClient.getInstance()
                  .getResponse("https://www.wanandroid.com/banner/json")
                  .then((val) {
                Banners banners = Banners.fromJson(val);

                print(banners.data[0].url);
                print(banners.errorCode);
                print(banners.errorMsg);
              });
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('关于我们'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
