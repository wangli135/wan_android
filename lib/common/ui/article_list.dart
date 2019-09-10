import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android/model/home_page_model.dart';
import 'package:wan_android/common/route_table_const.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_android/model/login_state.dart';
import 'package:wan_android/net/wan_android_http_client.dart';
import 'package:wan_android/common/shared_preference.dart';
import 'package:wan_android/model/user_center.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      return ArticleItemWidget(_articleList[index]);
    }, childCount: _articleList.length));
  }
}

class ArticleItemWidget extends StatefulWidget {
  final ArticleItem _articleItem;

  ArticleItemWidget(this._articleItem);

  @override
  _ArticleItemWidgetState createState() => _ArticleItemWidgetState();
}

class _ArticleItemWidgetState extends State<ArticleItemWidget> {
  @override
  Widget build(BuildContext context) {
    ArticleItem articleItem = widget._articleItem;
    LoginState loginState = Provider.of<LoginState>(context);
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
                  leading: Chip(
                    label: Text(
                      articleItem.chapterName,
                      style: TextStyle(color: Colors.blue, fontSize: 14),
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: loginState.isLogin() && articleItem.collect
                          ? Colors.red
                          : Colors.black45,
                    ),
                    onPressed: () {
                      KvStores.get(KeyConst.LOGIN).then((login) {
                        if (login!=null&&login) {
                          if (articleItem.collect) {
                            uncollectArticle(articleItem);
                          } else {
                            collectArticle(articleItem);
                          }
                        } else {
                          Navigator.of(context)
                              .pushNamed(RouteTableConst.LOGIN_PAGE);
                        }
                      });
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /// 收藏
  collectArticle(ArticleItem articleItem) {
    ApiClient apiClient = ApiClient.getInstance();
    apiClient
        .postRequest(
            'https://www.wanandroid.com/lg/collect/${articleItem.id}/json',
            null)
        .then((val) {
      BaseModel baseModel = BaseModel.fromJson(val);
      if (baseModel.errorCode == 0) {
        setState(() {
          articleItem.collect = true;
        });
        Fluttertoast.showToast(msg: '收藏成功');
      } else {
        Fluttertoast.showToast(msg: '收藏失败，${baseModel.errorMsg}');
      }
    });
  }

  /// 取消收藏
  uncollectArticle(ArticleItem articleItem) {
    ApiClient apiClient = ApiClient.getInstance();
    apiClient
        .postRequest(
            'https://www.wanandroid.com/lg/uncollect_originId/${articleItem.id}/json',
            null)
        .then((val) {
      BaseModel baseModel = BaseModel.fromJson(val);
      if (baseModel.errorCode == 0) {
        setState(() {
          articleItem.collect = false;
        });
        Fluttertoast.showToast(msg: '取消收藏成功');
      } else {
        Fluttertoast.showToast(msg: '取消收藏失败，${baseModel.errorMsg}');
      }
    });
  }
}

/// 带有下拉刷新、上拉加载的文章列表widget
class PullToRefreshArticleListWidget extends StatefulWidget {
  final UrlFactory _urlFactory;

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
