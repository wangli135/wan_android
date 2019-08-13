import 'package:json_annotation/json_annotation.dart';

part 'home_page_model.g.dart';

/**
 * Banner的一个页面
 */
@JsonSerializable()
class BannerItem {
  String desc;
  int id;
  String imagePath;
  int isVisible;
  int orider;
  String title;
  int type;
  String url;

  BannerItem(
      {this.desc,
      this.id,
      this.imagePath,
      this.isVisible,
      this.orider,
      this.title,
      this.type,
      this.url});

  factory BannerItem.fromJson(Map<String, dynamic> json) =>
      _$BannerItemFromJson(json);

  Map<String, dynamic> toJson() => _$BannerItemToJson(this);
}

@JsonSerializable()
class Banners {
  int errorCode;
  String errorMsg;
  List<BannerItem> data;

  Banners({this.errorCode, this.errorMsg, this.data});

  factory Banners.fromJson(Map<String, dynamic> json) =>
      _$BannersFromJson(json);

  Map<String, dynamic> toJson() => _$BannersToJson(this);
}

@JsonSerializable()
class ArticleItem {
  int id;
  String author;
  String chapterName;
  bool collect;
  String desc;
  String link;
  String niceDate;
  String title;

  ArticleItem(
      {this.id,
      this.author,
      this.chapterName,
      this.collect,
      this.desc,
      this.link,
      this.niceDate,
      this.title});

  factory ArticleItem.fromJson(Map<String, dynamic> json) =>
      _$ArticleItemFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleItemToJson(this);
}

@JsonSerializable()
class PageArticles {
  int curPage;
  List<ArticleItem> datas;

  PageArticles({this.curPage, this.datas});

  factory PageArticles.fromJson(Map<String, dynamic> json) =>
      _$PageArticlesFromJson(json);

  Map<String, dynamic> toJson() => _$PageArticlesToJson(this);
}

@JsonSerializable()
class ArticleList {
  int errorCode;
  String errorMsg;
  PageArticles data;

  ArticleList({this.errorCode, this.errorMsg, this.data});

  factory ArticleList.fromJson(Map<String, dynamic> json) =>
      _$ArticleListFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleListToJson(this);
}

/**
 * 首页 model
 * 顶部Banner+底部文章列表
 */
class HomePageResponse {
  Banners banners;
  List<ArticleItem> articles;
  int curPage;

  HomePageResponse() {
    articles = List();
    curPage = 0;
    banners = Banners(data: []);
  }
}
