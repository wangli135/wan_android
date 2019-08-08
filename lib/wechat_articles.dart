import 'package:flutter/material.dart';
import 'package:wan_android/common/ui/article_list.dart';
import 'package:wan_android/model/wechat_model.dart';

class WeChatUrlFactory implements UrlFactory {
  WeChatItem _weChatItem;

  WeChatUrlFactory(this._weChatItem);

  @override
  String getUrl(int curPage) {
    return 'https://wanandroid.com/wxarticle/list/${_weChatItem.id}/$curPage/json';
  }
}

class WeChatArticleListWidget extends StatefulWidget {
  @override
  _WeChatArticleListWidgetState createState() =>
      _WeChatArticleListWidgetState();
}

class _WeChatArticleListWidgetState extends State<WeChatArticleListWidget> {
  @override
  Widget build(BuildContext context) {
    WeChatItem weChatItem =
        ModalRoute.of(context).settings.arguments as WeChatItem;

    return Scaffold(
      appBar: AppBar(
        title: Text(weChatItem.name),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: PullToRefreshArticleListWidget(WeChatUrlFactory(weChatItem)),
    );
  }
}
