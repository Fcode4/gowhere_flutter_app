import 'package:app/page/home_widget.dart';
import 'package:app/page/my_page.dart';
import 'package:app/page/travel_page.dart';
import 'package:flutter/material.dart';
import 'package:app/page/search_page.dart';
import 'dart:ui';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<BottomNavigationBarItem> tabarItems;
  int activeTabBar = 0;
  @override
  void initState() {
    this._setTabBar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List tabPage = [HomeWidget(), SearchPage(), TravelPage(), MyPage()];
    return Scaffold(
      body: tabPage[activeTabBar],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: activeTabBar,
          onTap: (index) {
            setState(() {
              activeTabBar = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xffff66000),
          unselectedItemColor: Color(0xff000000),
          items: tabarItems),
    );
  }

  _setTabBar() {
    List tabbar = [
      {'label': '首页', 'icon': Icons.home},
      {'label': '搜索', 'icon': Icons.search},
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
