import 'package:flutter/material.dart';
import 'package:wan_android/model/knowledge_system_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_android/model/home_page_model.dart';
import 'package:wan_android/net/wan_android_http_client.dart';
import 'package:wan_android/common/ui/article_list.dart';
//知识体系item详情页

class KnowledgeItemWidget extends StatefulWidget {
  KnowledgeItem knowledgeItem;

  KnowledgeItemWidget(this.knowledgeItem);

  @override
  _KnowledgeItemWidget createState() => _KnowledgeItemWidget();
}

class _KnowledgeItemWidget extends State<KnowledgeItemWidget>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController = RefreshController();

  final List<ArticleItem> _articleList = [];

  int curPage = 0;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  _onLoading() async {
    ApiClient apiClient = ApiClient.getInstance();
    await apiClient
        .getResponse(
            "https://www.wanandroid.com/article/list/$curPage/json?cid=${widget.knowledgeItem.id}")
        .then((val) {
      ArticleList articleList = ArticleList.fromJson(val);
      if (articleList.errorCode < 0) {
        setState(() {
          _refreshController.loadFailed();
        });
      } else {
        _articleList.addAll(articleList.data.datas);
        setState(() {
          if (articleList.data.datas.length == 0) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
            curPage++;
          }
        });
      }
    }, onError: (e) {
      _refreshController.loadFailed();
    });
  }

  _onRefresh() async {
    curPage = 0;
    ApiClient apiClient = ApiClient.getInstance();
    await apiClient
        .getResponse(
            "https://www.wanandroid.com/article/list/$curPage/json?cid=${widget.knowledgeItem.id}")
        .then((val) {
      ArticleList articleList = ArticleList.fromJson(val);
      if (articleList.errorCode < 0) {
        setState(() {
          _refreshController.refreshFailed();
        });
      } else {
        _articleList.clear();
        _articleList.addAll(articleList.data.datas);
        setState(() {
          _refreshController.refreshCompleted();
          curPage++;
        });
      }
    }, onError: (e) {
      _refreshController.refreshFailed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: true,
      header: WaterDropHeader(),
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      footer: ClassicFooter(),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          ArticleListWidget(_articleList),
        ],
      ),
    );
  }
}

class KnowledgeItemPageWidget extends StatefulWidget {
  KnowledgeItem knowledgeItem;

  KnowledgeItemPageWidget({this.knowledgeItem});

  @override
  _KnowledgeItemPageWidgetState createState() =>
      _KnowledgeItemPageWidgetState();
}

class _KnowledgeItemPageWidgetState extends State<KnowledgeItemPageWidget> {
  @override
  Widget build(BuildContext context) {
    KnowledgeItem item = null;
    if (widget.knowledgeItem == null) {
      item = ModalRoute.of(context).settings.arguments as KnowledgeItem;
    } else {
      item = widget.knowledgeItem;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(item.name),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: KnowledgeItemWidget(item),
    );
  }
}

//class KnowledgeItemPageWidget extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    KnowledgeItem item =
//        ModalRoute.of(context).settings.arguments as KnowledgeItem;
//
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          title: Text(item.name),
//          leading: IconButton(
//              icon: Icon(Icons.arrow_back),
//              onPressed: () {
//                Navigator.of(context).pop();
//              }),
//        ),
//        body: KnowledgeItemWidget(item),
//      ),
//    );
//  }
//}
