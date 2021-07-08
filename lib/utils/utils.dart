import 'package:app/store/public.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models.dart';

class Utils {
  static void showSnackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: 2),
      ),
    );
  }

  static Widget getSusItem(BuildContext context, String tag,
      {double susHeight = 40}) {
    if (tag == '★') {
      tag = '★ 热门城市';
    }
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 16.0),
      color: Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        '$tag',
        softWrap: false,
        style: TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }

  static Widget getListItem(BuildContext context, CityModel model, target) {
    return ListTile(
      title: Text(model.name),
      onTap: () {
        target.setCityCh(model.name);
        target.setLocking(true);

        Utils.showSnackBar(context, 'onItemClick : ${model.name}');
      },
    );
  }
}
