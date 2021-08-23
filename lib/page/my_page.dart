import 'package:app/page/my/login_page.dart';
import 'package:app/page/my/my_live.dart';
import 'package:app/page/my/settings_page.dart';
import 'package:app/page/my/test_page.dart';
import 'package:app/utils/cusBehavior.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:app/utils/service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my/my_map.dart';

class MyPage extends StatefulWidget {
  MyPage({refresh});
  @override
  _MyPageState createState() => _MyPageState();
}

List<Map> menuBarList = [
  {'icon': Icon(Icons.settings), 'label': '应用设置', 'page': SettingsPage()},
  {'icon': Icon(Icons.cloud), 'label': '数据管理'},
  {'icon': Icon(Icons.collections_sharp), 'label': '我的收藏'},
  {'icon': Icon(Icons.autorenew), 'label': '版本信息'},
  {'icon': Icon(Icons.map), 'label': '地图', 'page': MyMap()},
  {'icon': Icon(Icons.live_tv), 'label': '直播', 'page': MyLive()},
  {'icon': Icon(Icons.text_fields), 'label': '测试页面', 'page': TestPage()},
];

class _MyPageState extends State<MyPage> {
// 本地存储
  SharedPreferences prefs;
  String _nick_name;
  List<Map> menuBar = menuBarList;
  _getStorage() async {
    prefs = await SharedPreferences.getInstance();
    print('刷新值${prefs.getString('nick_name')}');
    bool flag = prefs.getString('nick_name') != null;
    setState(() {
      _nick_name = flag ? prefs.getString('nick_name') : null;
    });
  }

  @override
  void initState() {
    _getStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      onTap: () {},
                    ),
                    LimitedBox(
                        maxWidth: 200,
                        child: GestureDetector(
                          onTap: () {
                            if (_nick_name != null) return;
                            NavigatorUtil.push(context, LoginPage())
                                .then((value) {
                              // 刷新
                              value && _getStorage();
                            });
                          },
                          child: Text(
                            _nick_name ?? '请登录',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                  ],
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
                        value && _getStorage();
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
