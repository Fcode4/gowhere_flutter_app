import 'package:app/store/public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:get/get.dart';
import 'package:flutter_baidu_mapapi_map/src/models/bmf_userlocation.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final Controller c = Get.put(Controller());
  BMFMapController myMapController;
  BMFMapOptions mapOptions;

  /// 定位点样式
  BMFUserLocationDisplayParam _displayParam;

  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    myMapController = controller;

    // 显示定位
    myMapController?.showUserLocation(true);
    updateLoaction();

    myMapController?.showBaseIndoorMap(true);

    /// 地图加载回调
    myMapController?.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');
      print('${c.loaction.value}');
    });
  }

  // 位置更新
  updateLoaction() {
    BMFCoordinate coordinate = BMFCoordinate(39.965, 116.404);

    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: 0,
        horizontalAccuracy: 5,
        verticalAccuracy: -1.0,
        speed: -1.0,
        course: -1.0);

    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );

    myMapController?.updateLocationData(userLocation);
    updateMap();
  }

  // 样式更新
  updateMap() {
    BMFUserLocationDisplayParam displayParam = BMFUserLocationDisplayParam(
        locationViewOffsetX: 0,
        locationViewOffsetY: 0,
        accuracyCircleFillColor: Colors.red,
        accuracyCircleStrokeColor: Colors.blue,
        isAccuracyCircleShow: true,
        locationViewHierarchy:
            BMFLocationViewHierarchy.LOCATION_VIEW_HIERARCHY_BOTTOM);
    _displayParam = displayParam;
    myMapController?.updateLocationViewWithParam(displayParam);
  }

  @override
  void initState() {
    double latitude;
    double longitude;
    if (c.loaction.value != {}) {
      latitude = c.loaction.value['latitude'];
      longitude = c.loaction.value['longitude'];
    }
    print('111111:${c.testloaction.value}');
    mapOptions = BMFMapOptions(
        center: BMFCoordinate(latitude ?? 39.917215, longitude ?? 116.380341),
        zoomLevel: 12,
        mapPadding: BMFEdgeInsets(left: 30, top: 0, right: 30, bottom: 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.height,
      child: BMFMapWidget(
        onBMFMapCreated: (controller) {
          onBMFMapCreated(controller);
        },
        mapOptions: mapOptions,
      ),
    );
  }
}
