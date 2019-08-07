import 'package:flutter/material.dart';
import 'package:wan_android/model/home_page_model.dart';
import 'package:wan_android/common/route_table_const.dart';

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
