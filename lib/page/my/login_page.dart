import 'package:app/page/my_page.dart';
import 'package:app/utils/service.dart';
import 'package:flutter/material.dart';
import 'package:m_loading/m_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  SharedPreferences prefs;
  String user_name;
  String pass_word;
  bool show_password = false;
  OutlineInputBorder _inputBoxBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0x00FF0000)),
      borderRadius: BorderRadius.all(Radius.circular(100)));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            '登录',
            style: TextStyle(color: Color(0xff444444)),
          ),
          iconTheme: IconThemeData(color: Color(0xff444444)),
          backgroundColor: Color(0xffcccccc),
          elevation: 0),
      // 安全区widget
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Container(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: TextField(
                onChanged: (v) {
                  setState(() {
                    user_name = v.trim();
                  });
                },
                decoration: InputDecoration(
                  fillColor: Color(0x30cccccc),
                  filled: true,
                  enabledBorder: _inputBoxBorder,
                  focusedBorder: _inputBoxBorder,
                  hintText: '请输入用户名',
                  icon: Icon(Icons.person),
                ),
              ),
            ),
            TextField(
              onChanged: (v) {
                setState(() {
                  pass_word = v.trim();
                });
              },
              obscureText: !show_password,
              decoration: InputDecoration(
                hintText: '请输入密码',
                filled: true,
                enabledBorder: _inputBoxBorder,
                focusedBorder: _inputBoxBorder,
                icon: Icon(Icons.keyboard),
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        show_password = !show_password;
                      });
                    },
                    child: show_password
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20),
              width: MediaQuery.of(context).size.width * 0.7,
              child: OutlineButton(
                child: Text('登录'),
                onPressed: () async {
                  if (user_name != null && pass_word != null) {
                    prefs = await SharedPreferences.getInstance();
                    prefs.setString('nick_name', user_name);
                    // GOdialog.showLoading(
                    //     context,
                    //     BallCircleOpacityLoading(
                    //       ballStyle: BallStyle(
                    //           size: 5,
                    //           color: Colors.blue,
                    //           ballType: BallType.solid),
                    //     ),
                    //     width: 40.0,
                    //     height: 40.0);
                    await Future.delayed(Duration(milliseconds: 400));
                    Navigator.of(context).pop(true);
                  } else {
                    Toast.toast(context, msg: "请输入正确的用户名密码！ ");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('还没有帐号?'),
                  Text(
                    '去注册~',
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
