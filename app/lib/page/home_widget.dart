import 'dart:convert';
import 'package:app/components/local_nav.dart';
import 'package:app/dao/home_dao.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/grid_nav.dart';
import 'package:app/widget/sales_box.dart';
import 'package:app/widget/sub_nav.dart';
import 'package:app/widget/swiper_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 基于ChangeNotifier使用provider；
class Opt with ChangeNotifier {
  double _opacity = 0;
  void increment(opt) {
    _opacity = opt;
    notifyListeners();
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int activeTabBar = 0;
  String resStr = '';
  bool loading = true;
  List bannerList;
  List navList;
  List subNavList;
  int bannerHeight = 180;
  double opacity = 0;
  Map<String, dynamic> salesBox;
  Map<String, dynamic> gridNav;
  // 之间创建实例，在scroll事件时改变实例中的值；
  var _optModel = Opt();
  // 滚动监听
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
    opacity = searchBoxOpt;
    //直接使用实例的方法改变实例中的值
    _optModel.increment(searchBoxOpt);
  }

  @override
  void initState() {
    controller.addListener(() {
      _onScroll(controller.offset);
    });

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
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: _homeView(),
      ),
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
          // 使用MultiProvider包裹需要局部更新的widget
          MultiProvider(
            // 直接使用创建好的实例,最小粒度更新widget,只要_optModel的值改变就会重新打包这个局部widget
            providers: [ChangeNotifierProvider(create: (_) => _optModel)],
            child: Consumer<Opt>(
              builder: (context, optModel, _) {
                return AppBar_widget(opacity: optModel._opacity);
              },
            ),
          ),
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
}
