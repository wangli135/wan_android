import 'package:flutter/material.dart';

class WeChatWidget extends StatefulWidget {
  @override
  _WeChatWidgetState createState() => _WeChatWidgetState();
}

class _WeChatWidgetState extends State<WeChatWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          '公众号',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ),
    );
  }
}
