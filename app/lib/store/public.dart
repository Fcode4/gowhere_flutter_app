import 'package:flutter/material.dart';

class PublicState with ChangeNotifier {
  // 状态栏高度
  double statusBarHeight;
  String cityCh = '定位中';
  bool locking = false;
  setCityCh(city) {
    cityCh = city;
    notifyListeners();
  }

  setLocking(flag) {
    locking = flag;
  }

  setStatusBarHeight(context) {
    if (statusBarHeight == null) {
      statusBarHeight = MediaQuery.of(context).padding.top;
      notifyListeners();
    }
  }
}
