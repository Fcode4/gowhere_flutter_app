import 'package:app/components/web_view.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:flutter/material.dart';

class SubNav extends StatelessWidget {
  final List subNavList;
  SubNav({this.subNavList});
  Widget getsubNavList(context) {
    if (subNavList == null) {
      return Text('暂无数据');
    } else {
      List<Widget> items = [];
      // 定义一个2行布局，然后计算应该有多少个tab数量
      int count = (subNavList.length / 2 + 0.5).toInt();
      subNavList.forEach((element) {
        items.add(Expanded(
          child: GestureDetector(
              onTap: () => {
                    NavigatorUtil.push(
                        context,
                        WebView(
                          title: element['title'],
                          url: element['url'],
                          statusBarColor: element['statusBarColor'],
                          hideAppBar: element['hideAppBar'] ?? true,
                        ))
                  },
              child: Column(
                children: [
                  Image.network(
                    element['icon'],
                    width: 32,
                    height: 32,
                  ),
                  Text(element['title'])
                ],
              )),
        ));
      });

      return Column(children: [
        Row(
          children: items.sublist(0, count),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            children: items.sublist(count, items.length),
          ),
        )
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(7, 4, 7, 4),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: getsubNavList(context),
    );
  }
}
