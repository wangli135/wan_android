import 'package:flutter/material.dart';
import 'package:wan_android/common/page_state.dart';
import 'package:wan_android/model/wechat_model.dart';
import 'package:wan_android/net/wan_android_http_client.dart';

class WeChatWidget extends StatefulWidget {
  @override
  _WeChatWidgetState createState() => _WeChatWidgetState();
}

class _WeChatWidgetState extends State<WeChatWidget> {
  static const String WECHAT_URL =
      "https://wanandroid.com/wxarticle/chapters/json";

  PAGE_STATE _page_state = PAGE_STATE.STATE_LOAD;
  WeChatReponse _weChatReponse;

  @override
  void initState() {
    super.initState();
    _fetchWeChat();
  }

  void _fetchWeChat() {
    setState(() {
      _page_state = PAGE_STATE.STATE_LOAD;
    });
    ApiClient client = ApiClient.getInstance();
    client.getResponse(WECHAT_URL).then((val) {
      _weChatReponse = WeChatReponse.fromJson(val);
      if (_weChatReponse.errorCode < 0) {
        setState(() {
          _page_state = PAGE_STATE.STATE_ERROR;
        });
      } else {
        setState(() {
          _page_state = PAGE_STATE.STATE_SHOW;
        });
      }
    }, onError: (e) {
      setState(() {
        _page_state = PAGE_STATE.STATE_ERROR;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _createBody(),
    );
  }

  Widget _createBody() {
    switch (_page_state) {
      case PAGE_STATE.STATE_LOAD:
        return Center(
          child: CircularProgressIndicator(),
        );
      case PAGE_STATE.STATE_ERROR:
        return Center(
          child: RaisedButton(
            onPressed: () {
              _fetchWeChat();
            },
            child: Text('出错了，请重试'),
          ),
        );

      case PAGE_STATE.STATE_SHOW:
        return _createShowBody();
    }
  }

  Widget _createShowBody() {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return SizedBox(
          child: Card(
            child: ListTile(
              title: Text(
                _weChatReponse.data[index].name,
                style: TextStyle(color: Colors.black87, fontSize: 20),
              ),
              onTap: () {
                //TODO 微信公众号跳转
              },
            ),
          ),
        );
      },
      itemCount: _weChatReponse.data.length,
    );
  }
}
