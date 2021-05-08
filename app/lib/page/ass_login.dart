import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:slimy_card/slimy_card.dart';

class AssLogin extends StatefulWidget {
  @override
  _AssLoginState createState() => _AssLoginState();
}

class _AssLoginState extends State<AssLogin> {
  String debugLable = 'Unknown'; /*错误信息*/
  final JPush jpush = new JPush(); /* 初始化极光插件*/
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.transparent
          ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Image.asset(
              'images/app_logo.png',
              height: 200,
              width: 200,
            ),
          ),
          loginBtn('微信登陆', Color(0xff1ecf27), 0xe63d),
          loginBtn('QQ登陆', Color(0xff0CBBFE), 0xe645),
          GestureDetector(
            onTap: _clickAbout,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('关于'),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  loginBtn(String label, Color color, num iconValue) {
    return GestureDetector(
      onTap: _login,
      child: Container(
          padding: EdgeInsets.fromLTRB(6, 10, 6, 10),
          margin: EdgeInsets.only(bottom: 10),
          width: 230,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20)),
          child: Stack(alignment: Alignment.centerLeft, children: [
            Positioned(
              left: 10,
              child: Icon(IconData(iconValue, fontFamily: 'AntdIcons'),
                  size: 16, color: Colors.white),
            ),
            Center(
                child: Text(
              label,
              style: TextStyle(color: Color(0xffffffff)),
            ))
          ])),
    );
  }

  _login() {
    /*x秒后出发本地推送*/
    var fireDate = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().millisecondsSinceEpoch);
    var localNotification = LocalNotification(
      id: 234,
      title: '极光推送',
      buildId: 1,
      content: '极光推送的测试',
      fireTime: fireDate,
      subtitle: 'subtitle',
    );

    jpush.sendLocalNotification(localNotification).then((res) {
      setState(() {
        debugLable = res;
      });
    });

    // showGeneralDialog(
    //     context: context,
    //     barrierDismissible: true,
    //     barrierLabel: '',
    //     transitionDuration: Duration(milliseconds: 200),
    //     pageBuilder: (BuildContext context, Animation<double> animation,
    //         Animation<double> secondaryAnimation) {
    //       return Center(
    //         child: Container(
    //           padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
    //           decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(6),
    //             color: Colors.white,
    //           ),
    //           child: Text(
    //             '暂未开放',
    //             textAlign: TextAlign.center,
    //             style: TextStyle(
    //               fontSize: 20,
    //               fontWeight: FontWeight.w100,
    //               color: Color(0xff999999),
    //               decoration: TextDecoration.none,
    //             ),
    //           ),
    //         ),
    //       );
    //     });
  }

  _clickAbout() {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: '',
        transitionDuration: Duration(milliseconds: 200),
        pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return Center(
            child: StreamBuilder(
              initialData: false,
              stream: slimyCard.stream,
              builder: ((BuildContext context, AsyncSnapshot snapshot) {
                return ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    SizedBox(height: 70),
                    SlimyCard(
                      color: Colors.indigo[300],
                      // topCardWidget: topCardWidget((snapshot.data)
                      //     ? 'images/app_logo.png'
                      //     : 'images/welcome.png'),
                      topCardWidget: topCardWidget('images/app_logo.png'),
                      bottomCardWidget: bottomCardWidget(),
                    ),
                  ],
                );
              }),
            ),
          );
        });
  }

  Widget topCardWidget(String imagePath) {
    return Stack(children: [
      Positioned(
          right: 10,
          top: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Icon(Icons.close),
          )),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(image: AssetImage(imagePath)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Text(
            'FlutterGo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              decoration: TextDecoration.none,
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              '一款旅游App,设计初衷于面向大前端在RN和Flutter中实现应用开发',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
        ],
      )
    ]);
  }

  Widget bottomCardWidget() {
    return Column(
      children: [
        Text(
          'https://flutterdevs.com/',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 15),
        Expanded(
          child: Text(
            'QQ：704301744',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.none,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
