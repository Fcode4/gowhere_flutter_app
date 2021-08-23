import 'dart:async';
import 'dart:convert';
import 'package:app/components/local_nav.dart';
import 'package:app/dao/home_dao.dart';
import 'package:app/store/public.dart';
import 'package:app/utils/cusBehavior.dart';
import 'package:app/widget/app_bar.dart';
import 'package:app/widget/grid_nav.dart';
import 'package:app/widget/sales_box.dart';
import 'package:app/widget/sub_nav.dart';
import 'package:app/widget/swiper_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m_loading/m_loading.dart';
import 'package:provider/provider.dart';
import 'package:amap_location_flutter_plugin/amap_location_flutter_plugin.dart';
import 'package:amap_location_flutter_plugin/amap_location_option.dart';
import 'package:permission_handler/permission_handler.dart';
import '../store/public.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  final Controller c = Get.put(Controller());
  int activeTabBar = 0;
  String resStr = '';
  bool loading = true;
  List bannerList;
  List navList;
  List subNavList;
  int bannerHeight = 180;
  Map<String, dynamic> salesBox;
  Map<String, dynamic> gridNav;
  // 滚动监听
  ScrollController controller = ScrollController(initialScrollOffset: 0);
  StreamSubscription<Map<String, Object>> _locationListener;
  AmapLocationFlutterPlugin _locationPlugin = AmapLocationFlutterPlugin();
  var _publicStatus;
  _onScroll(scrollOffset) {
    double searchBoxOpt;
    // searchbar刚好重叠至banner底部时改变透明度
    int possitionOpt = bannerHeight - 50;
    if (scrollOffset >= possitionOpt) {
      searchBoxOpt = 1;
    } else {
      searchBoxOpt = scrollOffset / possitionOpt;
    }
    //设置getx中的值
    c.set_opacity(searchBoxOpt);
  }

  @override
  void initState() {
    c.set_opacity(0.0);
    controller.addListener(() {
      _onScroll(controller.offset);
    });
    _publicStatus = context.read<PublicState>();

    /// 动态申请定位权限
    requestPermission();

    ///设置Android的apiKey<br>
    AmapLocationFlutterPlugin.setApiKey(
        "5f9564992a17368de8b80f7b8e9d0e14", "dfb64c0463cb53927914364b5c09aba0");

    ///注册定位结果监听
    _locationListener = _locationPlugin
        .onLocationChanged()
        .listen((Map<String, Object> result) {
      if (result != null &&
          result['city'] != null &&
          result['city'] != '' &&
          _publicStatus.locking == false) {
        c.setLoaction(result);
        _publicStatus.setCityCh(result['city']);
      }
    });
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    ///移除定位监听
    if (null != _locationListener) {
      _locationListener.cancel();
    }

    ///销毁定位
    if (null != _locationPlugin) {
      _locationPlugin.destroy();
    }
    super.dispose();
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

  /// 动态申请定位权限
  void requestPermission() async {
    // 申请权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      _startLocation();
      print("定位权限申请通过");
    } else {
      _publicStatus.setCityCh('定位失败');
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  ///开始定位
  void _startLocation() {
    if (null != _locationPlugin) {
      ///开始定位之前设置定位参数
      _setLocationOption();
      _locationPlugin.startLocation();
    }
  }

  ///停止定位
  void _stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
  }

  ///设置定位参数
  void _setLocationOption() {
    if (null != _locationPlugin) {
      AMapLocationOption locationOption = new AMapLocationOption();

      ///是否单次定位
      locationOption.onceLocation = false;

      ///是否需要返回逆地理信息
      locationOption.needAddress = true;

      ///逆地理信息的语言类型
      /// ///[GeoLanguage.DEFAULT] 自动适配
      ///[GeoLanguage.EN] 英文
      ///[GeoLanguage.ZH] 中文
      locationOption.geoLanguage = GeoLanguage.ZH;

      locationOption.desiredLocationAccuracyAuthorizationMode =
          AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;
      locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

      ///设置Android端连续定位的定位间隔
      // locationOption.locationInterval = 2000;

      ///设置Android端的定位模式<br>
      ///可选值：<br>
      ///<li>[AMapLocationMode.Battery_Saving]</li>
      ///<li>[AMapLocationMode.Device_Sensors]</li>
      ///<li>[AMapLocationMode.Hight_Accuracy]</li>
      locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

      ///将定位参数设置给定位插件
      _locationPlugin.setLocationOption(locationOption);
    }
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
          //使用getx的observer组件包裹需要局部更新的widget
          Obx(() => AppBar_widget(opacity: c.navbar_opacity.value))
        ],
      );
    } else {
      return Center(
        child: Container(
          height: 40,
          width: 40,
          child: BallCircleOpacityLoading(
            ballStyle: BallStyle(
              size: 5,
              color: Colors.blue,
              ballType: BallType.solid,
            ),
          ),
        ),
      );
    }
  }

  Widget _listView() {
    List listData = [
      SwiperHome(bannerList: bannerList, bannerHeight: bannerHeight),
      LocalNav(navList: navList),
      GridNav(gridNav: gridNav),
      SubNav(subNavList: subNavList),
      SalesBox(salesBox: salesBox),
    ];
    return ScrollConfiguration(
      behavior: CusBehavior(),
      child: ListView.builder(
        controller: controller,
        itemCount: listData?.length,
        itemBuilder: (BuildContext context, int index) {
          return listData[index];
        },
      ),
    );
  }
}
