import 'package:app/components/web_view.dart';
import 'package:flutter/material.dart';

class SalesBox extends StatelessWidget {
  final Map salesBox;
  BorderSide borderSide = BorderSide(width: 0.8, color: Color(0xfff2f2f2));
  SalesBox({this.salesBox});
  Widget _titleBox(context) {
    if (salesBox != null) {
      return Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(
              width: 1,
              color: Color(0xfff2f2f2),
            ),
          )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                salesBox['icon'],
                height: 20,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                margin: EdgeInsets.fromLTRB(10, 1, 8, 1),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // color: Colors.blue,
                    gradient: LinearGradient(
                        colors: [Color(0xffff4e63), Color(0xffff6cc9)])),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebView(
                                  title: '活动',
                                  url: salesBox['moreUrl'],
                                  hideAppBar: false)));
                    },
                    child: Text(
                      '获取更多福利>',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ));
    } else {
      return Container();
    }
  }

  Widget _cardBox(context) {
    if (salesBox != null) {
      int count = 0;
      List<Widget> items = [];
      for (int i = 1; i <= 2; i++) {
        String bigCard = 'bigCard$i';
        String item1 = 'smallCard${count + i}';
        count++;
        String item2 = 'smallCard${count + i}';
        items.add(Container(
          decoration: BoxDecoration(
            border: Border(right: i == 1 ? borderSide : BorderSide.none),
          ),
          child: Column(children: [
            _item(salesBox[bigCard]['icon'], salesBox[bigCard]['url'], context,
                true,
                bottomBorder: true),
            _item(salesBox[item1]['icon'], salesBox[bigCard]['url'], context,
                false,
                bottomBorder: true),
            _item(salesBox[item2]['icon'], salesBox[bigCard]['url'], context,
                false),
          ]),
        ));
      }
      return Container(
          child: salesBox == null
              ? Text('没数据')
              : Row(
                  children: items,
                ));
    } else {
      return Container();
    }
  }

  Widget _item(iconUrl, path, context, bool big, {bool bottomBorder = false}) {
    print('测试重复构建？');
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    WebView(title: '', url: path, hideAppBar: false)));
      },
      child: Container(
        decoration: BoxDecoration(
            border:
                Border(bottom: bottomBorder ? borderSide : BorderSide.none)),
        child: Image.network(
          iconUrl,
          fit: BoxFit.fill,
          width: MediaQuery.of(context).size.width / 2 - 11,
          height: big ? 150 : 90,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(children: [_titleBox(context), _cardBox(context)]),
    );
  }
}
