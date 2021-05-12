import 'package:app/page/home_widget.dart';
import 'package:app/page/my_page.dart';
import 'package:app/page/travel_page.dart';
import 'package:app/page/trip_page.dart';
import 'package:flutter/material.dart';
import 'package:app/page/search_page.dart';
import 'dart:ui';
import 'package:flutter/services.dart';

///推送
import 'package:jpush_flutter/jpush_flutter.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<BottomNavigationBarItem> tabarItems;
  int activeTabBar = 0;
  String debugLable = 'Unknown'; /*错误信息*/
  final JPush jpush = new JPush(); /* 初始化极光插件*/
  @override
  void initState() {
    _setJgOpction();
    this._setTabBar();
    super.initState();
  }

  _setJgOpction() {
    /// 配置jpush(不要省略）
    ///debug就填debug:true，生产环境production:true
    jpush.setup(
        appKey: 'a6640541f76553a08e4ced5c',
        channel: 'developer-default',
        production: false,
        debug: true);

    /// 监听jpush
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    jpush.addEventHandler(
      //通知类消息,极光后台发送和本地都会接收到
      onReceiveNotification: (Map<String, dynamic> message) async {
        print('通知类${message}');
      },

      //推送点击监听
      onOpenNotification: (Map<String, dynamic> message) async {
        /// 点击通知栏消息，在此时通常可以做一些页面跳转等
        print('===========================${message.toString()}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabPage = [
      HomeWidget(),
      SearchPage(),
      TripPage(),
      TravelPage(),
      MyPage()
    ];
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: tabPage[activeTabBar],
        // webview页面不会隐藏，因为页面没有dispose,他总在其他元素之上
        // body: IndexedStack(index: activeTabBar, children: tabPage),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: activeTabBar,
            onTap: (index) {
              setState(() {
                activeTabBar = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Color(0xff888888),
            items: tabarItems),
      ),
    );
  }

  _setTabBar() {
    List tabbar = [
      {'label': '首页', 'icon': Icons.home},
      {'label': '搜索', 'icon': Icons.search},
      {'label': '行程', 'icon': Icons.storage},
      {'label': '旅拍', 'icon': Icons.local_see},
      {'label': '我的', 'icon': Icons.person},
    ];
    List<BottomNavigationBarItem> view = [];
    tabbar.forEach((element) {
      view.add(BottomNavigationBarItem(
          label: element['label'], icon: Icon(element['icon'])));
    });
    setState(() {
      tabarItems = view;
    });
  }
}
