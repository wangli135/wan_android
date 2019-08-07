import 'package:flutter/material.dart';
import 'package:wan_android/model/knowledge_system_model.dart';
import 'package:wan_android/net/wan_android_http_client.dart';
import 'package:wan_android/common/page_state.dart';
import 'package:wan_android/common/route_table_const.dart';
import 'package:wan_android/common/route_table_const.dart';

class KnowledgeSystemWidget extends StatefulWidget {
  @override
  _KnowledgeSystemWidgetState createState() => _KnowledgeSystemWidgetState();
}

class _KnowledgeSystemWidgetState extends State<KnowledgeSystemWidget> {
  static const String KNOWLEDGE_SYSTEM_URL =
      "https://www.wanandroid.com/tree/json";

  PAGE_STATE _page_state = PAGE_STATE.STATE_LOAD;
  KnowledgeSytemResponse _knowledgeSytem;

  @override
  void initState() {
    super.initState();
    _fetchKnowledgeSystem();
  }

  void _fetchKnowledgeSystem() {
    setState(() {
      _page_state = PAGE_STATE.STATE_LOAD;
    });
    ApiClient client = ApiClient.getInstance();
    client.getResponse(KNOWLEDGE_SYSTEM_URL).then((val) {
      _knowledgeSytem = KnowledgeSytemResponse.fromJson(val);
      if (_knowledgeSytem.errorCode < 0) {
        setState(() {
          _page_state = PAGE_STATE.STATE_ERROR;
        });
      } else {
        setState(() {
          _page_state = PAGE_STATE.STATE_SHOW;
        });
      }
    }, onError: (e) {
      setState(() {
        _page_state = PAGE_STATE.STATE_ERROR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _createBody(),
    );
  }

  Widget _createBody() {
    switch (_page_state) {
      case PAGE_STATE.STATE_LOAD:
        return Center(
          child: CircularProgressIndicator(),
        );
      case PAGE_STATE.STATE_ERROR:
        return Center(
          child: RaisedButton(
            onPressed: () {
              _fetchKnowledgeSystem();
            },
            child: Text('出错了，请重试'),
          ),
        );

      case PAGE_STATE.STATE_SHOW:
        return _createShowBody();
    }
  }

  Widget _createShowBody() {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return _createCategoryItem(_knowledgeSytem.data[index]);
      },
      itemCount: _knowledgeSytem.data.length,
    );
  }

  Widget _createCategoryItem(KnowledgeCategory knowledgeCategory) {
    return SizedBox(
      child: Card(
          child: FlatButton(
        onPressed: () {
          Navigator.of(context).pushNamed(RouteTableConst.KNOWLEDGE_TAB_PAGE,
              arguments: knowledgeCategory);
        },
        child: ListTile(
          title: Text(
            knowledgeCategory.name,
            style: TextStyle(color: Colors.black87, fontSize: 20),
          ),
          subtitle: Wrap(
            spacing: 8.0,
            children: _createKnowledgeItem(knowledgeCategory),
          ),
        ),
      )),
    );
  }

  List<Widget> _createKnowledgeItem(KnowledgeCategory knowledgeCategory) {
    List<Widget> widgets = List(knowledgeCategory.children.length);
    for (int i = 0; i < knowledgeCategory.children.length; i++) {
      widgets[i] = ActionChip(
          label: Text(
            knowledgeCategory.children[i].name,
            style: TextStyle(color: Colors.blue),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(RouteTableConst.KNOWLEDGE_ITEM_PAGE,
                arguments: knowledgeCategory.children[i]);
          });
    }
    return widgets;
  }
}
