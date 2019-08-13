// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_page_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerItem _$BannerItemFromJson(Map<String, dynamic> json) {
  return BannerItem(
    desc: json['desc'] as String,
    id: json['id'] as int,
    imagePath: json['imagePath'] as String,
    isVisible: json['isVisible'] as int,
    orider: json['orider'] as int,
    title: json['title'] as String,
    type: json['type'] as int,
    url: json['url'] as String,
  );
}

Map<String, dynamic> _$BannerItemToJson(BannerItem instance) =>
    <String, dynamic>{
      'desc': instance.desc,
      'id': instance.id,
      'imagePath': instance.imagePath,
      'isVisible': instance.isVisible,
      'orider': instance.orider,
      'title': instance.title,
      'type': instance.type,
      'url': instance.url,
    };

Banners _$BannersFromJson(Map<String, dynamic> json) {
  return Banners(
    errorCode: json['errorCode'] as int,
    errorMsg: json['errorMsg'] as String,
    data: (json['data'] as List)
        ?.map((e) =>
            e == null ? null : BannerItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BannersToJson(Banners instance) => <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'data': instance.data,
    };

ArticleItem _$ArticleItemFromJson(Map<String, dynamic> json) {
  return ArticleItem(
    author: json['author'] as String,
    chapterName: json['chapterName'] as String,
    collect: json['collect'] as bool,
    desc: json['desc'] as String,
    link: json['link'] as String,
    niceDate: json['niceDate'] as String,
    title: json['title'] as String,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$ArticleItemToJson(ArticleItem instance) =>
    <String, dynamic>{
      'author': instance.author,
      'chapterName': instance.chapterName,
      'collect': instance.collect,
      'desc': instance.desc,
      'link': instance.link,
      'niceDate': instance.niceDate,
      'title': instance.title,
      'id':instance.id,
    };

PageArticles _$PageArticlesFromJson(Map<String, dynamic> json) {
  return PageArticles(
    curPage: json['curPage'] as int,
    datas: (json['datas'] as List)
        ?.map((e) =>
            e == null ? null : ArticleItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PageArticlesToJson(PageArticles instance) =>
    <String, dynamic>{
      'curPage': instance.curPage,
      'datas': instance.datas,
    };

ArticleList _$ArticleListFromJson(Map<String, dynamic> json) {
  return ArticleList(
    errorCode: json['errorCode'] as int,
    errorMsg: json['errorMsg'] as String,
    data: json['data'] == null
        ? null
        : PageArticles.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ArticleListToJson(ArticleList instance) =>
    <String, dynamic>{
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
      'data': instance.data,
    };
