import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorUtil {
  static Future push(BuildContext context, Widget page) async {
    final value = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => page));
    return value;
  }
}
