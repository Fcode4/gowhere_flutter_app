import 'dart:async';
import 'package:app/dao/search_dao.dart';
import 'package:app/page/city_select.dart';
import 'package:app/page/search_page.dart';
import 'package:app/page/speack_page.dart';
import 'package:app/store/public.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum SearchType { home, searchPage, homeLight }

class SearchBar extends StatefulWidget {
  bool isHome;
  bool backIcon;
  String defauleText;
  String keyWord;
  int searchBgcolor = 0xffcccccc;
  double opacity;

  final Function resCallback;
  SearchBar(
      {this.isHome = false,
      this.backIcon = false,
      this.defauleText,
      this.opacity = 0,
      this.resCallback,
      this.keyWord});
  @override
  _SearchBarState createState() => _SearchBarState();
}

Color lableColor;

class _SearchBarState extends State<SearchBar> {
  bool iscontent = false;
  Timer _timer;
//设置节流周期为390毫秒
  Duration durationTime = Duration(milliseconds: 390);
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    if (widget.keyWord != null) {
      setState(() {
        // 回填输入框文字
        textController.text = widget.keyWord;
        _onChanged(widget.keyWord);
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color lableColor =
        Color(widget.opacity == 1 ? 0xff000000 : widget.searchBgcolor);

    return Container(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        children: [
          Container(
            child: widget.isHome
                ? GestureDetector(
                    onTap: () {
                      NavigatorUtil.push(context, CitySelectRoute());
                    },
                    child: Row(children: [
                      LimitedBox(
                          maxWidth: 60,
                          child: Text(
                            '${Provider.of<PublicState>(context).cityCh}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: lableColor),
                          )),
                      Icon(
                        Icons.location_on,
                        color: lableColor,
                        size: 18,
                      )
                    ]),
                  )
                : widget.backIcon
                    ? GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 30,
                        ))
                    : Text(''),
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
          ),
          Expanded(
              child: Container(
            height: 40,
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            decoration: BoxDecoration(
                color: Color(
                    widget.opacity == 1 ? widget.searchBgcolor : 0xffffffff),
                borderRadius: BorderRadius.circular(widget.isHome ? 20 : 5)),
            child: Row(
              children: [
                Icon(Icons.search),
                Expanded(
                  child: GestureDetector(
                      onTap: () {
                        NavigatorUtil.push(context, SearchPage(backIcon: true));
                      },
                      child: TextField(
                        enabled: !widget.isHome,
                        controller: textController,
                        onChanged: _onChanged,
                        autofocus: true,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(5, 12, 5, 12),
                            border: InputBorder.none,
                            hintText: widget.defauleText ?? '',
                            hintStyle: TextStyle(fontSize: 16)),
                      )),
                ),
                _rightIcon()
              ],
            ),
          )),
          Container(
            child: widget.isHome
                ? Icon(
                    Icons.message,
                    color: lableColor,
                  )
                : Text('搜索'),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          )
        ],
      ),
    );
  }

  _onChanged(text) {
    bool flag = text != '';
    setState(() {
      iscontent = flag;
    });
    if (widget.resCallback != null) {
      _timer?.cancel();
      if (!flag) {
        widget.resCallback({'data': []});
        return;
      }
      _timer = Timer(durationTime, () async {
        Map data = await SearchData.fetch(text);
        //当服务端返回的值与输入的值一致时才渲染
        if (data['reqKeyword'] == text) {
          widget.resCallback(flag ? data : {'data': []});
        }
      });
    }
  }

  Widget _rightIcon() {
    return GestureDetector(
      onTap: () {
        if (iscontent) {
          textController.clear();
          _onChanged('');
        } else {
          NavigatorUtil.push(context, SpeackPage());
        }
      },
      child: iscontent
          ? Icon(Icons.close)
          : Icon(
              Icons.mic,
              color: widget.isHome ? Colors.blue : Colors.black,
            ),
    );
  }
}
