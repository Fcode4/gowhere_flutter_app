import 'dart:ui';

import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Padding(
            padding: EdgeInsets.only(
              top: Utils.navHeight,
            ),
            child: Container(
                child: Row(
              children: [
                Text('this is testpage'),
                Expanded(
                    child: Container(
                  height: 20,
                  decoration: BoxDecoration(color: Color(0xffff6600)),
                ))
              ],
            ))),
      ),
    );
  }
}
