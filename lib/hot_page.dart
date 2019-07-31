import 'package:flutter/material.dart';

class HotPageWidget extends StatefulWidget {
  @override
  _HotPageWidgetState createState() => _HotPageWidgetState();
}

class _HotPageWidgetState extends State<HotPageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Hot',style: TextStyle(color: Colors.blue,fontSize: 30),),
      ),
    );
  }
}
