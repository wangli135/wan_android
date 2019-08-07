import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ArticlePageWidget extends StatefulWidget {
  ArticlePageWidget();

  @override
  _ArticlePageWidgetState createState() => _ArticlePageWidgetState();
}

class _ArticlePageWidgetState extends State<ArticlePageWidget> {
  WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    var args =
    ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, dynamic>;
    String url = args['url'];
    String title = args['title'];


    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                if (_controller != null) {
                  _controller.canGoBack().then((canGoBack) {
                    if (canGoBack) {
                      _controller.goBack();
                    } else {
                      Navigator.of(context).pop();
                    }
                  });
                } else {
                  Navigator.of(context).pop();
                }
              }),
          title: Text(title),
        ),
        body: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: url,
          onWebViewCreated: (controller) {
            _controller = controller;
          },
        ),
      ),
    );
  }
}
