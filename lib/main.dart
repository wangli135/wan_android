import 'package:flutter/material.dart';
import 'package:wan_android/home_page.dart';
import 'package:wan_android/knowledge_system.dart';
import 'package:wan_android/hot_page.dart';

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
  ];

  List<Widget> _mainBody = [HomePageWidget(), KnowledgeSystemWidget()];

  int _selectBottomIndex = 0;
  bool _isHotShowPage;
  String _title='';

  @override
  void initState() {
    super.initState();
    _selectBottomIndex = 0;
    _isHotShowPage = false;
    _title = '玩Android';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        actions: <Widget>[
          IconButton(
              icon: Image.asset("images/hot.png"),
              onPressed: () {
                setState(() {
                  _title = 'Hot';
                  _isHotShowPage = true;
                });
              }),
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
            _title = '玩Android';
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
          SizedBox(
            height: 240,
            child: Stack(
              alignment: AlignmentDirectional.center,
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: 240,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlutterLogo(
                        size: 70,
                      ),
                      Padding(padding: EdgeInsets.all(12)),
                      Text(
                        '未登录',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ),
                Positioned(
                    right: 16,
                    bottom: 16,
                    child: FlatButton(
                        onPressed: () {},
                        child: Text(
                          '点击登录',
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('我喜欢的'),
            onTap: () {},
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
