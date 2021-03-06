import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../store/public.dart';

class TripPage extends StatefulWidget {
  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  final Controller c = Get.put(Controller());
  List arr = [
    {'check': true, 'id': 1, 'count': 10},
    {'check': false, 'id': 2, 'count': 3},
    {'check': false, 'id': 3, 'count': 6},
    {'check': false, 'id': 4, 'count': 4},
  ].obs;
  num sum;
  Widget _hander(type, item) {
    return GestureDetector(
      onTap: () {
        item['count'] += type ? 1 : -1;
        if (item['count'] < 0) {
          item['count'] = 0;
        }
        _getSum();
        setState(() {
          arr = arr;
        });
      },
      child: type ? Icon(Icons.add) : Icon(Icons.remove),
    );
  }

  List<Widget> _row() {
    List<Widget> listelement = [
      Row(
        children: [
          Text('合计：$sum'),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('删除选中'),
            ),
            onTap: () {
              setState(() {
                arr.removeWhere((element) => element['check']);
                _getSum();
              });
            },
          ),
          GestureDetector(
            onTap: c.increment,
            child: Obx(() => Text('===测试getx:${c.count}')),
          )
        ],
      )
    ];
    arr.forEach((element) {
      listelement.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Checkbox(
            value: element['check'],
            onChanged: (value) {
              setState(() {
                element['check'] = value;
              });
            },
          ),
          Text('id:${element['id']}'),
          _hander(false, element),
          Text('count:${element['count']}'),
          _hander(true, element),
          GestureDetector(
            onTap: () {
              arr.remove(element);
              setState(() {
                sum -= element['count'];
              });
            },
            child: Text('删除'),
          )
        ],
      ));
    });
    return listelement;
  }

  @override
  void initState() {
    _getSum();
    // TODO: implement initState
    super.initState();
  }

  _getSum() {
    num init = 0;
    arr.forEach((element) {
      init += element['count'];
    });
    sum = init;
    // setState(() {
    //   sum = init;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: _row(),
        ),
      ),
    );
  }
}
