import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wan_android/home_page.dart';
import 'package:wan_android/knowledge_system.dart';
import 'package:wan_android/hot_page.dart';
import 'package:wan_android/wechat.dart';
import 'package:wan_android/ali_icon.dart';
import 'package:wan_android/net/wan_android_http_client.dart';
import 'package:wan_android/model/home_page_model.dart';
import 'package:wan_android/article_detail_page.dart';
import 'package:wan_android/common/route_table_const.dart';
import 'package:wan_android/knowledge_system_item.dart';
import 'package:wan_android/knowledge_system_tab.dart';
import 'package:wan_android/wechat_articles.dart';
import 'package:wan_android/login.dart';
import 'package:wan_android/register.dart';

import 'model/login_state.dart';
import 'common/shared_preference.dart';
import 'model/user_center.dart';

void main() {
  final _loginState = LoginState();

  KvStores.get(KeyConst.LOGIN).then((isLogin) {
    if (isLogin != null && isLogin) {
      KvStores.get(KeyConst.USER_NAME).then((name) {
        _loginState.login(name);
      });
    } else {
      _loginState.logout();
    }
    runApp(Provider<LoginState>.value(
      child: ChangeNotifierProvider.value(
        value: _loginState,
        child: MyApp(),
      ),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '玩Android',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      routes: {
        RouteTableConst.ARTICLE_PAGE: (context) => ArticlePageWidget(),
        RouteTableConst.KNOWLEDGE_ITEM_PAGE: (context) =>
            KnowledgeItemPageWidget(),
        RouteTableConst.KNOWLEDGE_TAB_PAGE: (context) => KnowledgeTabWidget(),
        RouteTableConst.WECHAT_ARTICLES_PAGE: (context) =>
            WeChatArticleListWidget(),
        RouteTableConst.LOGIN_PAGE: (context) => LoginWidget(),
        RouteTableConst.REGISTER_PAGE: (context) => RegisterWidget()
      },
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
    final _loginState = Provider.of<LoginState>(context);

    return Container(
      child: Column(
        children: <Widget>[
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
                        _loginState.isLogin()
                            ? _loginState.getUserName()
                            : '未登录',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
                Positioned(
                    right: 1,
                    bottom: 1,
                    child: FlatButton(
                        onPressed: () {
                          if (_loginState.isLogin()) {
                            logout(_loginState);
                          } else {
                            Navigator.of(context)
                                .pushNamed(RouteTableConst.LOGIN_PAGE);
                          }
                        },
                        child: Text(
                          _loginState.isLogin() ? '退出登录' : '点击登录',
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

/**
 * 登出
 */
void logout(LoginState loginState) {
  ApiClient apiClient = ApiClient.getInstance();
  apiClient
      .getResponse("https://www.wanandroid.com/user/logout/json")
      .then((val) {
    BaseModel baseModel = BaseModel.fromJson(val);
    if (baseModel.errorCode == 0) {
      Fluttertoast.showToast(msg: '退出成功');
      KvStores.save(KeyConst.LOGIN, false);
      KvStores.save(KeyConst.USER_NAME, "");
      loginState.logout();
    } else {
      Fluttertoast.showToast(msg: '退出失败,${baseModel.errorMsg}');
    }
  });
}
