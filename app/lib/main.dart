import 'package:app/page/home_page.dart';
import 'package:app/page/home_widget.dart';
import 'package:app/store/public.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // 设置首屏图时间
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // 启动时显示
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(debugShowCheckedModeBanner: false, home: Splash());
        } else {
          // 时间过后显示
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => Opt(),
              ),
              ChangeNotifierProvider(
                create: (_) => PublicState(),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'go_where',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: MyHomePage(),
            ),
          );
        }
      },
    );
  }
}

// 欢迎页面
class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        'images/welcome.png',
        fit: BoxFit.cover,
      ),
    ));
  }
}
