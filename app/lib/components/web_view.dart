import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  WebView(
      {this.url,
      this.statusBarColor = 'ffffff',
      this.title,
      this.hideAppBar = true,
      this.backForbid = false});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  bool exiting = false;
  // 跳转路径为这些时返回到app
  List CATCH_URLS = [
    'https://m.ctrip.com/',
    'https://m.ctrip.com/html5/',
    'https://m.ctrip.com/html5',
    'https://m.ctrip.com/webapp/you/gsdestination/?seo=0'
  ];
  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  @override
  void initState() {
    flutterWebviewPlugin.close();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {});
    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
          if (CATCH_URLS.contains(state.url) && !exiting) {
            if (widget.backForbid) {
              // flutterWebviewPlugin.launch(widget.url);
            } else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        default:
      }
    });
    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {});
    super.initState();
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  Widget _appbar() {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    String backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = '000000';
    } else {
      backButtonColor = 'ffffff';
    }
    if (widget.hideAppBar) {
      return Container(
        color: Color(int.parse('0xff' + statusBarColorStr)),
        height: MediaQueryData.fromWindow(window).padding.top,
      );
    } else {
      return Container(
        padding:
            EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
        // height: 40,
        color: Color(int.parse('0xff' + statusBarColorStr)),
        child: FractionallySizedBox(
          //占满屏幕宽度
          widthFactor: 1,
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Stack(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.close,
                        color: Color(int.parse('0xff' + backButtonColor)),
                      ),
                    )),
                Positioned(
                  left: 0,
                  right: 0,
                  child: Center(
                      child: Text(
                    widget.title ?? '123',
                    style: TextStyle(
                        color: Color(
                          int.parse('0xff' + backButtonColor),
                        ),
                        fontSize: 20),
                  )),
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            _appbar(),
            Expanded(
              child: WebviewScaffold(
                url: widget.url,
                withZoom: true,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(
                  color: Colors.white,
                  child: Center(
                    child: Text('loading...'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
