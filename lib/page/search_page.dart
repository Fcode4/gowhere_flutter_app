import 'dart:ui';
import 'package:app/components/web_view.dart';
import 'package:app/utils/cusBehavior.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:app/utils/utils.dart';
import 'package:app/widget/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keframe/frame_separate_widget.dart';
import 'package:keframe/size_cache_widget.dart';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

class SearchPage extends StatefulWidget {
  final bool backIcon;
  final String keyWord;
  SearchPage({this.backIcon = false, this.keyWord});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List listData;
  String keyWord;
  TextStyle normalStyle = TextStyle(color: Colors.black87, fontSize: 18);
  TextStyle keyWordStyle = TextStyle(color: Colors.orange, fontSize: 18);
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.only(
          top: Utils.navHeight,
        ),
        child: Column(children: [
          SearchBar(
              opacity: 1,
              resCallback: _resCallback,
              backIcon: widget.backIcon,
              keyWord: widget.keyWord),
          Expanded(
              child: MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: _searchList(context)))
        ]),
      )),
    );
  }

  _resCallback(Map res) {
    setState(() {
      listData = res['data'];
      keyWord = res['reqKeyword'];
    });
  }

  Widget _searchList(context) {
    return ScrollConfiguration(
      behavior: CusBehavior(), // 自定义的 behavior
      child: SizeCacheWidget(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: listData?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return FrameSeparateWidget(
                index: index,
                placeHolder: Container(
                  color: Colors.white,
                  height: 60,
                ),
                child: _item(index));
          },
        ),
      ),
    );

    ;
  }

  _item(index) {
    if (listData == null || listData.length == 0) return null;
    return GestureDetector(
        onTap: () {
          NavigatorUtil.push(
              context,
              WebView(
                  title: '详情', url: listData[index]['url'], hideAppBar: false));
        },
        child: Container(
          padding: EdgeInsets.all(10),
          // margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Color(0xffcccccc),
                      width: 0.5,
                      style: BorderStyle.solid))),
          child: Row(children: [
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(right: 10),
              child: Image.asset(
                _typeImaage(listData[index]['type']),
                width: 30,
                height: 30,
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_title(listData[index]), _subTitle(listData[index])],
            ))
          ]),
        ));
  }

  _typeImaage(String type) {
    if (type == null) return 'images/type_travelgroup.png';
    String path = 'travelgroup';
    for (var item in TYPES) {
      if (type.contains(item)) {
        path = item;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _title(item) {
    List word = item['word'].split('$keyWord');
    List<InlineSpan> wordL = [];

    for (int i = 0; i < word.length; i++) {
      if (word[i] == null || word[i].length == 0) {
        wordL.add(TextSpan(text: keyWord, style: keyWordStyle));
      } else {
        wordL.add(TextSpan(text: word[i], style: normalStyle));
      }
    }
    // 富文本需要写文字颜色不然不显示啊
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          children: wordL,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        TextSpan(
            style: TextStyle(color: Color(0xffcccccc), fontSize: 18),
            text: '  ${item['districtname'] ?? ''}'),
      ]),
    );
  }

  _subTitle(item) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: (item['price'] != null && item['price'] != '')
                ? item['price'] == '实时计价'
                    ? item['price']
                    : ('￥${item['price']}')
                : '',
            style: keyWordStyle),
        TextSpan(
            text: ' ' + (item['star'] ?? ''),
            style: TextStyle(color: Color(0xffcccccc), fontSize: 14)),
      ]),
    );
  }
}
