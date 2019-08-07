import 'package:flutter/material.dart';
import 'package:wan_android/model/knowledge_system_model.dart';
import 'package:wan_android/knowledge_system_item.dart';

class KnowledgeTabWidget extends StatefulWidget {
  @override
  _KnowledgeTabWidgetState createState() => _KnowledgeTabWidgetState();
}

class _KnowledgeTabWidgetState extends State<KnowledgeTabWidget>
    with TickerProviderStateMixin {
  TabController _tabController;

  KnowledgeCategory _knowledgeCategory;

  List<Tab> _tabs;
  List<Widget> _children;

  @override
  void initState() {
    super.initState();

  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _knowledgeCategory =
    ModalRoute.of(context).settings.arguments as KnowledgeCategory;

    _tabs=List(_knowledgeCategory.children.length);
    _children=List(_knowledgeCategory.children.length);

    for (int i = 0; i < _knowledgeCategory.children.length; i++) {
      _tabs[i] = Tab(
        child: Text(_knowledgeCategory.children[i].name),
      );
      _children[i] = KnowledgeItemWidget(_knowledgeCategory.children[i],
      );
    }
    _tabController = TabController(length: _tabs.length, vsync: this);
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_knowledgeCategory.name),
        bottom: TabBar(
          tabs: _tabs,
          controller: _tabController,
          isScrollable: true,
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){
          Navigator.of(context).pop();
        }),
      ),
      body: TabBarView(
        children: _children,
        controller: _tabController,
      ),
    );
  }
}
