import 'package:flutter/material.dart';
import 'package:wan_android/model/knowledge_system_model.dart';
import 'package:wan_android/common/ui/article_list.dart';
//知识体系item详情页

class KnowledgeItemWidget extends StatefulWidget {
  KnowledgeItem knowledgeItem;

  KnowledgeItemWidget(this.knowledgeItem);

  @override
  _KnowledgeItemWidget createState() => _KnowledgeItemWidget();
}

class _KnowledgeItemWidget extends State<KnowledgeItemWidget> {
  @override
  Widget build(BuildContext context) {
    return PullToRefreshArticleListWidget(
        KnowledgeItemUrlFactory(widget.knowledgeItem));
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

class KnowledgeItemUrlFactory implements UrlFactory {
  KnowledgeItem knowledgeItem;

  KnowledgeItemUrlFactory(this.knowledgeItem);

  @override
  String getUrl(int curPage) {
    return "https://www.wanandroid.com/article/list/$curPage/json?cid=${knowledgeItem.id}";
  }
}
