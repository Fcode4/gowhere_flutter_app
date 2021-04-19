import 'dart:ui';

import 'package:app/dao/trave_dao.dart';
import 'package:flutter/material.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  List tabs;
  @override
  void initState() {
    _getPageData();
    super.initState();
  }

  _getPageData() async {
    Map<String, dynamic> data = await TraveData.fetch();
    setState(() {
      tabs = data['tabs'];
    });
    print('${data.toString()}');
  }

  _getNav() {
    if (tabs != null && tabs.length > 0) {
      // List items = [];
      // tabs.forEach((element) {
      //   items.add(
      //   element['labelName']

      //   );
      // });
      return TabBar(
          tabs: tabs.map<Tab>((v) {
        return Tab(
          text: v['labelName'],
        );
      }).toList());
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
        child: Column(children: [_getNav()]),
      ),
    );
  }
}
