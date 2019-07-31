import 'package:flutter/material.dart';

class HomePageWidget extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Center(
          child: Text(
            'Home Page',
            style: TextStyle(color: Colors.blue, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
