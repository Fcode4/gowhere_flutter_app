import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class Controller extends GetxController {
  var count = 0.obs;
  final navbar_opacity = 0.0.obs;
  increment() => count++;
  set_opacity(opc) => this.navbar_opacity.value = opc;
}
