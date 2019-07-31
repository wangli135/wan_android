import 'package:flutter/material.dart';

class KnowledgeSystemWidget extends StatefulWidget {
  @override
  _KnowledgeSystemWidgetState createState() => _KnowledgeSystemWidgetState();
}

class _KnowledgeSystemWidgetState extends State<KnowledgeSystemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Knowledge system',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ),
    );
  }
}
