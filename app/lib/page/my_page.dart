import 'dart:developer';

import 'package:app/components/web_view.dart';
import 'package:app/page/my/login_page.dart';
import 'package:app/page/my/settings_page.dart';
import 'package:app/utils/cusBehavior.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:app/utils/service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  MyPage({refresh});
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
// 本地存储
  SharedPreferences prefs;
  String _nick_name;

  List<Map> menuBar = [
    {'icon': Icon(Icons.settings), 'label': '应用设置', 'page': SettingsPage()},
    {'icon': Icon(Icons.cloud), 'label': '数据管理'},
    {'icon': Icon(Icons.collections_sharp), 'label': '我的收藏'},
    {'icon': Icon(Icons.autorenew), 'label': '版本信息'},
  ];
  _getStorg() async {
    prefs = await SharedPreferences.getInstance();
    print('刷新值${prefs.getString('nick_name')}');
    if (prefs.getString('nick_name') != null) {
      setState(() {
        _nick_name = prefs.getString('nick_name');
      });
    } else {
      setState(() {
        _nick_name = null;
      });
    }
  }

  @override
  void initState() {
    print('执行：initState');
    _getStorg();
    super.initState();
  }

  @override
  void deactivate() {
    print('执行:${prefs.getString('nick_name')}');
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title:
      // ),
      // body: WebView(
      //   url: 'https://m.ctrip.com/webapp/myctrip/',
      //   hideAppBar: true,
      //   backForbid: true,
      //   statusBarColor: '4c5bca',
      // ),
      body: ScrollConfiguration(
        behavior: CusBehavior(),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 20, bottom: 15),
                title: Row(
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      onTap: () {
                        print('123123');
                      },
                    ),
                    LimitedBox(
                        maxWidth: 200,
                        child: GestureDetector(
                          onTap: () {
                            if (_nick_name == null) {
                              NavigatorUtil.push(context, LoginPage())
                                  .then((value) {
                                // 刷新
                                if (value) {
                                  _getStorg();
                                }
                              });
                            }
                          },
                          child: Text(
                            _nick_name ?? '请登录',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                  ],
                ),
                background: Image.network(
                  'https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fimg.pconline.com.cn%2Fimages%2Fupload%2Fupc%2Ftx%2Fitbbs%2F1710%2F08%2Fc23%2F62226714_1507462198518_mthumb.jpg&refer=http%3A%2F%2Fimg.pconline.com.cn&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 80.0,
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    if (menuBar[index]['page'] != null) {
                      NavigatorUtil.push(context, menuBar[index]['page'])
                          .then((value) {
                        // 刷新
                        if (value) {
                          _getStorg();
                        }
                      });
                    } else {
                      Toast.toast(context, msg: "暂未开放，敬请期待 ");
                    }
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          menuBar[index]['icon'],
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(menuBar[index]['label']),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }, childCount: menuBar.length),
            )
          ],
        ),
      ),
    );
  }
}
