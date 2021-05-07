import 'package:flutter/material.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

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
          // backgroundColor: Color(0xffcccccc),
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
          loginBtn('微信登陆', Color(0xff1ecf27)),
          loginBtn('QQ登陆', Color(0xff0CBBFE)),
        ],
      )),
    );
  }

  loginBtn(String label, Color color) {
    return GestureDetector(
      onTap: _login,
      child: Container(
          padding: EdgeInsets.fromLTRB(6, 10, 6, 10),
          margin: EdgeInsets.only(bottom: 10),
          width: 230,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20)),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xffffffff)),
          )),
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
}
