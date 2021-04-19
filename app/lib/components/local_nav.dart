import 'package:app/components/web_view.dart';
import 'package:flutter/material.dart';

//导航nav组件
class LocalNav extends StatelessWidget {
  final List navList;
  //required声明必传参数，注意语法书写格式
  LocalNav({Key key, @required this.navList}) : super(key: key);
  Widget _getNavList(context) {
    List<Widget> items = [];
    //必须做null判断
    if (navList != null) {
      navList.forEach((element) {
        items.add(_items(element, context));
      });
    }

    return Row(
      //元素在水平方向的排列方式
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  Widget _items(element, context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebView(
                        title: element['title'],
                        url: element['url'],
                        statusBarColor: element['statusBarColor'],
                        hideAppBar: element['hideAppBar'],
                      )));
        },
        child: Column(
          children: [
            Image.network(
              element['icon'],
              width: 32,
              height: 32,
            ),
            Text(
              element['title'],
              style: TextStyle(fontSize: 12),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.fromLTRB(7, 10, 7, 10),
      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: _getNavList(context),
    );
  }
}
