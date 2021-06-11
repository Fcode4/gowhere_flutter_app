import 'package:app/page/my_page.dart';
import 'package:app/utils/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  SharedPreferences prefs;
  List arr = [
    {
      'label': '通用',
      'border': Border(bottom: BorderSide(color: Color(0xfff5f5f5), width: 1))
    },
    {
      'label': '隐私',
      'border': Border(bottom: BorderSide(color: Color(0xfff5f5f5), width: 1))
    },
    {'label': '消息提醒'},
    {'label': null},
    {'label': '切换帐号'},
    {'label': null},
    {'label': '退出登录', 'popup': GOdialog},
  ];

  List outputarr = [
    '关闭应用',
    '退出帐号',
    '取消',
  ];

  List<Widget> arr2Element(context) {
    return arr.map((e) {
      return e['label'] != null
          ? InkWell(
              splashColor: Colors.cyanAccent,
              onTap: () {
                if (e['popup'] != null) {
                  showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.white,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                      builder: (BuildContext context) {
                        return Container(
                          height: 100,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: outputarr
                                  .map((e) => GestureDetector(
                                        onTap: () async {
                                          switch (e) {
                                            case '取消':
                                              Navigator.pop(context);
                                              break;
                                            case '关闭应用':
                                              SystemNavigator.pop();
                                              break;
                                            case '退出帐号':
                                              prefs = await SharedPreferences
                                                  .getInstance();
                                              prefs.remove('nick_name');
                                              Navigator.of(context)
                                                ..pop()
                                                ..pop(true);

                                              break;
                                            default:
                                              return;
                                          }
                                        },
                                        child: Text(e),
                                      ))
                                  .toList()),
                        );
                      });
                } else {
                  Toast.toast(context, msg: "暂未开放，敬请期待 ");
                }
              },
              child: Container(
                padding: EdgeInsets.fromLTRB(8, 18, 8, 18),
                decoration: BoxDecoration(
                    color: Colors.white, border: e['border'] ?? null),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${e['label']}'),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    )
                  ],
                ),
              ),
            )
          : SizedBox(
              height: 10,
            );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '设置',
            style: TextStyle(color: Color(0xff444444)),
          ),
          iconTheme: IconThemeData(color: Color(0xff444444)),
          backgroundColor: Color(0xffcccccc),
          elevation: 0),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xfff5f5f5),
        child: Column(children: arr2Element(context)),
      ),
    );
  }
}
