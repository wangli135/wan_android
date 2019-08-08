import 'package:flutter/material.dart';
import 'package:wan_android/model/home_page_model.dart';
import 'package:wan_android/common/route_table_const.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_android/net/wan_android_http_client.dart';

abstract class UrlFactory {
  String getUrl(int curPage);
}

class ArticleListWidget extends StatelessWidget {
  final List<ArticleItem> _articleList;

  ArticleListWidget(this._articleList);

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((ctx, index) {
      return _creatArticleItem(_articleList[index], context);
    }, childCount: _articleList.length));
  }

  Widget _creatArticleItem(ArticleItem articleItem, BuildContext context) {
    return SizedBox(
      height: 190.0,
      child: Card(
        child: FlatButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteTableConst.ARTICLE_PAGE,
                  arguments: {
                    'url': articleItem.link,
                    'title': articleItem.title
                  });
            },
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Text(articleItem.author),
                  trailing: Text(articleItem.niceDate),
                ),
                ListTile(
                  title: Text(
                    articleItem.title,
                    style: TextStyle(color: Colors.black87, fontSize: 20),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ListTile(
                  leading: ActionChip(
                    label: Text(
                      articleItem.chapterName,
                      style: TextStyle(color: Colors.blue),
                    ),
                    onPressed: () {
                      //TODO 跳转到chapter name
                    },
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: articleItem.collect ? Colors.red : Colors.black45,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            )),
      ),
    );
  }
}

/**
 * 带有下拉刷新、上拉加载的文章列表widget
 */
class PullToRefreshArticleListWidget extends StatefulWidget {
  UrlFactory _urlFactory;

  PullToRefreshArticleListWidget(this._urlFactory);

  @override
  _PullToRefreshArticleListWidgetState createState() =>
      _PullToRefreshArticleListWidgetState();
}

class _PullToRefreshArticleListWidgetState
    extends State<PullToRefreshArticleListWidget>
    with SingleTickerProviderStateMixin {
  final RefreshController _refreshController = RefreshController();

  List<ArticleItem> _articleList = [];

  int curPage = 0;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    curPage = 0;
    ApiClient apiClient = ApiClient.getInstance();
    apiClient.getResponse(widget._urlFactory.getUrl(curPage)).then((val) {
      ArticleList list = ArticleList.fromJson(val);
      if (list.errorCode < 0) {
        setState(() {
          _refreshController.refreshFailed();
        });
      } else {
        curPage++;
        _articleList.clear();
        _articleList.addAll(list.data.datas);
        setState(() {
          _refreshController.refreshCompleted();
        });
      }
    });
  }

  void _onLoad() async {
    ApiClient apiClient = ApiClient.getInstance();
    apiClient.getResponse(widget._urlFactory.getUrl(curPage)).then((val) {
      ArticleList list = ArticleList.fromJson(val);
      if (list.errorCode < 0) {
        setState(() {
          _refreshController.loadFailed();
        });
      } else {
        _articleList.addAll(list.data.datas);
        setState(() {
          if (list.data.datas.length == 0) {
            _refreshController.loadNoData();
          } else {
            curPage++;
            _refreshController.refreshCompleted();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      header: WaterDropHeader(),
      footer: ClassicFooter(),
      onRefresh: _onRefresh,
      onLoading: _onLoad,
      enablePullDown: true,
      enablePullUp: true,
      child: CustomScrollView(
        slivers: <Widget>[ArticleListWidget(_articleList)],
      ),
    );
  }
}
