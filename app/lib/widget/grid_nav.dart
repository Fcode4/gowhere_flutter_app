import 'package:app/components/web_view.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:flutter/material.dart';

class GridNav extends StatelessWidget {
  final Map<String, dynamic> gridNav;
  GridNav({this.gridNav});

  Widget _cloumnLayout(context) {
    if (gridNav != null) {
      Map rowData = gridNav['flight'] ?? {};
      Map travel = gridNav['travel'] ?? {};
      Map hotel = gridNav['hotel'] ?? {};
      List layout = [];
      List<Widget> layoutView = [];
      int count = 0;
      layout..add(rowData)..add(travel)..add(hotel);
      layout.forEach((element) {
        count++;
        layoutView.add(_renderGrid(element, count, context));
      });
      return Column(
        children: layoutView,
      );
    } else {
      return Text('noData');
    }
  }

  Widget _renderGrid(item, count, context) {
    if (gridNav != null) {
      List<Widget> rowitem = [];
      List towItems = [];
      Map rowData = item;
      rowData.forEach((key, value) {
        if (value is String == false) {
          if (value['icon'] != null) {
            rowitem.add(_rowItem(value, context));
          } else {
            towItems.add(value);
            if (towItems.length == 2) {
              rowitem.add(_towItems(towItems, context));
              towItems = [];
            }
          }
        }
      });
      Color startColor = Color(int.parse('0xff' + item['startColor']));
      Color endColor = Color(int.parse('0xff' + item['endColor']));

      return Container(
        //GridView包裹容器必须设置高度
        margin: EdgeInsets.only(bottom: count != 3 ? 2 : 0),
        height: 88,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [startColor, endColor])),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          children: rowitem,
        ),
      );
    } else {
      return Text('noData');
    }
  }

  Widget _rowItem(item, context) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            WebView(
              title: item['title'],
              url: item['url'],
              statusBarColor: item['statusBarColor'],
              hideAppBar: item['hideAppBar'] ?? true,
            ));
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => WebView(
        //               title: item['title'],
        //               url: item['url'],
        //               statusBarColor: item['statusBarColor'],
        //               hideAppBar: item['hideAppBar'] ?? true,
        //             )));
      },
      child: Container(
        padding: EdgeInsets.all(5),
        child: Stack(
          children: [
            Image.network(
              item['icon'],
              height: 84,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Positioned(
                left: 0,
                right: 0,
                child: Center(
                  child: Text('${item['title']}',
                      style: TextStyle(color: Colors.white)),
                ))
          ],
        ),
      ),
    );
  }

  Widget _towItems(List item, context) {
    List<Widget> labelItem = [];
    int count = 0;
    item.forEach((element) {
      count++;
      labelItem.add(FractionallySizedBox(
        widthFactor: 1,
        child: GestureDetector(
            onTap: () {
              NavigatorUtil.push(
                  context,
                  WebView(
                    title: element['title'],
                    url: element['url'],
                    statusBarColor: element['statusBarColor'],
                    hideAppBar: element['hideAppBar'] ?? true,
                  ));
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => ));
            },
            child: Container(
                height: 44,
                decoration: BoxDecoration(
                    border: Border(
                  left: BorderSide(width: 2, color: Colors.white),
                  bottom: BorderSide(
                      width: count == 1 ? 2 : 0, color: Colors.white),
                )),
                // margin: EdgeInsets.only(bottom: count == 1 ? 2 : 0, left: 2),
                child: Center(
                  child: Text(
                    element['title'],
                    style: TextStyle(color: Colors.white),
                  ),
                ))),
      ));
    });
    return Column(children: labelItem);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        /* 不能直接使用container的圆角，因为层级不一样无法应用,这里使用PhysicalModel */
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(10),
          child: _cloumnLayout(context),
        ));
  }
}
