import 'dart:ui';
import 'package:app/widget/search_bar.dart';
import 'package:flutter/material.dart';

class AppBar_widget extends StatefulWidget {
  double opacity = 0;
  AppBar_widget({this.opacity});
  @override
  AppBarWidgetState createState() => AppBarWidgetState();
}

class AppBarWidgetState extends State<AppBar_widget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    //AppBar渐变遮罩背景
                    colors: [Color(0x66000000), Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Container(
                padding: EdgeInsets.only(
                    top: MediaQueryData.fromWindow(window).padding.top),
                decoration: BoxDecoration(
                    color: Color.fromARGB(
                        (widget.opacity * 255).toInt(), 255, 255, 255)),
                child: SearchBar(
                  isHome: true,
                  defauleText: '默认文字',
                  opacity: widget.opacity,
                ))),
        Container(
          height: widget.opacity > 0.2 ? 1 : 0,
          decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 0.5)]),
        )
      ],
    );
  }
}
