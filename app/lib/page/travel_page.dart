import 'dart:ui';
import 'package:app/components/waterfall_flow_list.dart';
import 'package:app/dao/trave_dao.dart';
import 'package:flutter/material.dart';

class TravelPage extends StatefulWidget {
  @override
  _TravelPageState createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  List tabs;
  TabController _controller;
  @override
  void initState() {
    _controller = TabController(length: 0, vsync: this);
    _getPageData();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _getPageData() async {
    Map<String, dynamic> data = await TraveData.fetch();
    setState(() {
      tabs = data['tabs'] ?? [];
      _controller =
          TabController(length: data['tabs']?.length ?? 0, vsync: this);
    });
  }

  _getNav() {
    if (tabs != null && tabs.length > 0) {
      return TabBar(
          controller: _controller,
          onTap: (index) {
            print(index);
          },
          // 不加的话会文字内容可能无法完全展示也无法滚动
          isScrollable: true,
          labelColor: Color(0xff000000),
          labelStyle: TextStyle(fontSize: 16),
          indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Color(0xff2fcfbb), width: 2),
              insets: EdgeInsets.only(bottom: 10)),
          tabs: tabs.map<Tab>((v) {
            return Tab(
              text: v['labelName'],
            );
          }).toList());
    } else {
      return Container();
    }
  }

  _getTabBarView() {
    if (tabs != null && tabs.length > 0) {
      // 必须要给一个有高度的容器，Flexible||Expanded可以自动撑满剩余空间
      return Flexible(
          child: TabBarView(
        controller: _controller,
        children: tabs.map((tab) {
          return WaterfallFlowList(groupChannelCode: tab['groupChannelCode']);
          // return Text('${tab['groupChannelCode']}');
        }).toList(),
      ));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
        child: Column(children: [_getNav(), _getTabBarView()]),
      ),
    );
  }
}
