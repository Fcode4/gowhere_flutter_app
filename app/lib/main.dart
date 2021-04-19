import 'package:app/components/local_nav.dart';
import 'package:app/dao/home_dao.dart';
import 'package:app/page/search_page.dart';
import 'package:app/widget/grid_nav.dart';
import 'package:app/widget/sales_box.dart';
import 'package:app/widget/search_bar.dart';
import 'package:app/widget/sub_nav.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui';
import 'widget/swiper_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<BottomNavigationBarItem> tabarItems;
  int activeTabBar = 0;
  String resStr = '';
  bool loading = true;
  List bannerList;
  List navList;
  List subNavList;
  int bannerHeight = 180;
  double opacity = 0;
  // List tabPage=[SearchPage()];
  Map<String, dynamic> salesBox;
  Map<String, dynamic> gridNav;
  ScrollController controller = ScrollController(initialScrollOffset: 0);

  _onScroll(scrollOffset) {
    double searchBoxOpt;
    int changeBgColor;
    // searchbar刚好重叠至banner底部时改变透明度
    int possitionOpt = bannerHeight - 50;
    if (scrollOffset >= possitionOpt) {
      changeBgColor = 0xffcccccc;
      searchBoxOpt = 1;
    } else {
      searchBoxOpt = scrollOffset / possitionOpt;
      changeBgColor = 0xffffffff;
    }
    setState(() {
      opacity = searchBoxOpt;
    });
  }

  @override
  void initState() {
    controller.addListener(() {
      _onScroll(controller.offset);
    });
    this._setTabBar();
    fetchData();
    super.initState();
  }

  Future<Null> fetchData() async {
    // 使用.then方法时return Future<Null> 会无法在onRefresh使用，应该是异步原因造成？
    try {
      Map res = await HomeData.getHomedate();
      setState(() {
        resStr = json.encode(res);
        bannerList = res['bannerList'];
        navList = res['localNavList'];
        gridNav = res['gridNav'];
        subNavList = res['subNavList'];
        salesBox = res['salesBox'];
        loading = false;
      });
    } catch (e) {
      setState(() {
        resStr = 'nodata';
        loading = false;
      });
    }
    //  Map res=await HomeData.getHomedate().then((res) {

    //     setState(() {
    //       resStr = json.encode(res);
    //       navList = res['localNavList'];
    //       gridNav = res['gridNav'];
    //       subNavList = res['subNavList'];
    //       salesBox = res['salesBox'];
    //     });
    //   }).catchError((e) {

    //   });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: activeTabBar == 1
          ? SearchPage()
          : MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: _homeView(),
            ),
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

  Widget _appBar() {
    // 第一种背景类型
    // return Opacity(
    //     opacity: opacity,
    //     child: Container(
    //         padding: EdgeInsets.only(
    //             top: MediaQueryData.fromWindow(window).padding.top),
    //         // height: 80,
    //         width: double.infinity,
    //         decoration: BoxDecoration(color: Color(0xffffffff)),
    //         child: SearchBar(
    //             isHome: true,
    //             defauleText: '默认文字',
    //             opacity: opacity,
    //             )));
    // 第二种背景类型
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    //AppBar渐变遮罩背景
                    colors: [Color(0x66000000), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Container(
                padding: EdgeInsets.only(
                    top: MediaQueryData.fromWindow(window).padding.top),
                decoration: BoxDecoration(
                    color:
                        Color.fromARGB((opacity * 255).toInt(), 255, 255, 255)),
                child: SearchBar(
                  isHome: true,
                  defauleText: '默认文字',
                  opacity: opacity,
                ))),
        Container(
          height: opacity > 0.2 ? 1 : 0,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }

  Widget _listView() {
    return ListView(
      controller: controller,
      children: [
        SwiperHome(bannerList: bannerList, bannerHeight: bannerHeight),
        LocalNav(navList: navList),
        GridNav(gridNav: gridNav),
        SubNav(subNavList: subNavList),
        SalesBox(salesBox: salesBox),
        // Text("$resStr")
      ],
    );
  }

  Widget _homeView() {
    if (!loading) {
      return Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: Color(0xFFF2F2F2)),
            child: RefreshIndicator(
              onRefresh: fetchData,
              child: _listView(),
            ),
          ),
          _appBar()
        ],
      );
    } else {
      return Container(
        child: Center(
          child: Text('加载中...'),
        ),
      );
    }
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
