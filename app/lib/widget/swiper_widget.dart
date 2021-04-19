import 'dart:ui';

import 'package:app/components/web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class SwiperHome extends StatelessWidget {
  final List bannerList;
  int bannerHeight;
  SwiperHome({this.bannerList, this.bannerHeight});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: bannerHeight + MediaQueryData.fromWindow(window).padding.top,
      child: bannerList != null
          ? Swiper(
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebView(
                                    title: '',
                                    url: bannerList[index]['url'],
                                    hideAppBar: (index == 1 || index == 3)
                                        ? true
                                        : false,
                                  )));
                    },
                    child: Image.network(
                      bannerList[index]['icon'],
                      fit: BoxFit.cover,
                    ));
              },
              itemCount: bannerList.length,
              pagination: SwiperPagination(),
            )
          : Text(''),
    );
  }
}
