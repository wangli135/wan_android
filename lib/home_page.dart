import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:banner/banner.dart';
import 'package:wan_android/model/home_page_model.dart';
import 'package:wan_android/net/wan_android_http_client.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_android/common/route_table_const.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with SingleTickerProviderStateMixin {
  final Key key = GlobalKey();

  static const String BANNER_URL = "https://www.wanandroid.com/banner/json";
  static const String HOME_PAGE_ARTICLES_URL =
      "https://www.wanandroid.com/article/list/%d/json";

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final ScrollController _scrollController = ScrollController();

  int curPage = 0;

  HomePageResponse _homePageModel = HomePageResponse();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void _onRefresh() async {
    curPage = 0;
    int errorNum = 0;
    ApiClient apiClient = ApiClient.getInstance();
    await apiClient.getResponse(BANNER_URL).then((val) {
      _homePageModel.banners = Banners.fromJson(val);
      if (_homePageModel.banners.errorCode < 0) {
        errorNum++;
      }
    }, onError: (error) {
      errorNum++;
    });
    await apiClient
        .getResponse('https://www.wanandroid.com/article/list/$curPage/json')
        .then((val) {
      HomeArticles homeArticles = HomeArticles.fromJson(val);
      if (homeArticles.errorCode < 0) {
        errorNum++;
      } else {
        _homePageModel.articles.clear();
        _homePageModel.articles.addAll(homeArticles.data.datas);
        curPage++;
      }
    }, onError: (error) {
      errorNum++;
    });

    setState(() {});

    if (errorNum == 2) {
      _refreshController.refreshFailed();
    } else {
      _refreshController.refreshCompleted();
    }
  }

  void _onLoadig() async {
    bool wrong = false;

    ApiClient apiClient = ApiClient.getInstance();
    await apiClient
        .getResponse('https://www.wanandroid.com/article/list/$curPage/json')
        .then((val) {
      HomeArticles homeArticles = HomeArticles.fromJson(val);
      if (homeArticles.errorCode < 0) {
        wrong = true;
      } else {
        _homePageModel.articles.addAll(homeArticles.data.datas);
        curPage++;
      }
    }, onError: (error) {
      wrong = true;
    });

    setState(() {});

    if (wrong) {
      _refreshController.loadFailed();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(child: _buildBody());
  }

  Widget _buildBody() {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          } else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      onRefresh: _onRefresh,
      onLoading: _onLoadig,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[_createBanner(), _createArticleList()],
      ),
    );
  }

  Widget _createBanner() {
    return SliverToBoxAdapter(
      child: BannerView(
        data: _homePageModel.banners.data,
        buildShowView: (index, data) {
          var currentBanner = data as BannerItem;
          return Container(
            child: Image.network(
              currentBanner.imagePath,
              fit: BoxFit.cover,
            ),
          );
        },
        height: 200,
        onBannerClickListener: (index, data) {
          var currentBanner = data as BannerItem;
          Navigator.of(context).pushNamed(RouteTableConst.ARTICLE_PAGE,
              arguments: {
                'url': currentBanner.url,
                'title': currentBanner.title
              });
        },
      ),
    );
  }

  Widget _createArticleList() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((ctx, index) {
      return _creatArticleItem(_homePageModel.articles[index]);
    }, childCount: _homePageModel.articles.length));
  }

  Widget _creatArticleItem(ArticleItem articleItem) {
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
