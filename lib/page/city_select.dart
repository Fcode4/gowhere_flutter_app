import 'dart:convert';
import 'dart:ui';
import 'package:app/store/public.dart';
import 'package:app/utils/models.dart';
import 'package:app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:azlistview/azlistview.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:provider/provider.dart';

class CitySelectRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CitySelectRouteState();
  }
}

class _CitySelectRouteState extends State<CitySelectRoute> {
  List<CityModel> cityList = List();
  List<CityModel> _hotCityList = List();

  @override
  void initState() {
    super.initState();
    _hotCityList.add(CityModel(name: '北京市', tagIndex: '★'));
    _hotCityList.add(CityModel(name: '广州市', tagIndex: '★'));
    _hotCityList.add(CityModel(name: '成都市', tagIndex: '★'));
    _hotCityList.add(CityModel(name: '深圳市', tagIndex: '★'));
    _hotCityList.add(CityModel(name: '杭州市', tagIndex: '★'));
    _hotCityList.add(CityModel(name: '武汉市', tagIndex: '★'));
    cityList.addAll(_hotCityList);
    SuspensionUtil.setShowSuspensionStatus(cityList);

    Future.delayed(Duration(milliseconds: 500), () {
      loadData();
    });
  }

  void loadData() async {
    //加载城市列表
    rootBundle.loadString('assets/data/china.json').then((value) {
      cityList.clear();
      Map countyMap = json.decode(value);
      List list = countyMap['china'];
      list.forEach((v) {
        cityList.add(CityModel.fromJson(v));
      });
      _handleList(cityList);
    });
  }

  void _handleList(List<CityModel> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      list[i].namePinyin = pinyin;
      if (RegExp('[A-Z]').hasMatch(tag)) {
        list[i].tagIndex = tag;
      } else {
        list[i].tagIndex = '#';
      }
    }
    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(list);

    // add hotCityList.
    cityList.insertAll(0, _hotCityList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(cityList);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(
                  top: Utils.navHeight,
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 15),
                height: 50.0,
                child: Consumer<PublicState>(
                  builder: (context, _optModel, _) {
                    return Text(
                        '当前城市：${Provider.of<PublicState>(context).cityCh}');
                  },
                )),
            Expanded(
                flex: 1,
                child: AzListView(
                  data: cityList,
                  itemCount: cityList.length,
                  itemBuilder: (BuildContext context, int index) {
                    CityModel model = cityList[index];
                    // 将单例传入方法中
                    final target = context.read<PublicState>();
                    return Utils.getListItem(context, model, target);
                  },
                  padding: EdgeInsets.zero,
                  susItemBuilder: (BuildContext context, int index) {
                    CityModel model = cityList[index];
                    String tag = model.getSuspensionTag();
                    return Utils.getSusItem(context, tag);
                  },
                  indexBarData: ['★', ...kIndexBarData],
                )),
          ],
        ),
      ),
    );
  }
}
