import 'dart:ui';
import 'package:app/page/search_page.dart';
import 'package:app/plugin/asr_manager.dart';
import 'package:flutter/material.dart';

double _boxheight = 100;

class SpeackPage extends StatefulWidget {
  @override
  _SpeackPageState createState() => _SpeackPageState();
}

class _SpeackPageState extends State<SpeackPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  String speakTips = '长按说话';
  String speakResult = '';
  @override
  void initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn)
      ..addStatusListener((status) {
        //如果动画结束了反转继续执行
        if (status == AnimationStatus.completed) {
          controller.reverse();
          // 动画如果被关闭了重新开始动画
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // 不传e会报错
  _speackStart(e) {
    print('按下');
    setState(() {
      speakTips = '-识别中-';
    });
    controller.forward();
    AsrManager.start()
        .then((text) => {
              if (text != null && text.length > 0)
                {
                  setState(() {
                    speakResult = text;
                  }),
                  // Navigator.pop(context),
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchPage(keyWord: text, backIcon: true)))
                }
            })
        .catchError((e) => {print('错误=====${e.toString()}')});
  }

  _speackStop(e) {
    setState(() {
      speakTips = '长按说话';
    });
    controller.reset();
    controller.stop();
    AsrManager.stop();
  }

  _speackCancel() {
    setState(() {
      speakTips = '长按说话';
    });
    controller.reset();
    controller.stop();
    AsrManager.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        margin:
            EdgeInsets.only(top: MediaQueryData.fromWindow(window).padding.top),
        decoration: BoxDecoration(color: Color(0xffffffff)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_tips(), _downSpeack()],
        ),
      ),
    );
  }

  Widget _tips() {
    return Container(
        child: Column(
      children: [
        Text(
          '你可以这样说',
          style: TextStyle(fontSize: 18),
        ),
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Column(children: [
            _text('故宫门票'),
            _text('北京一日游'),
            _text('迪士尼乐园'),
          ]),
        )
      ],
    ));
  }

  Widget _text(text) {
    return Text(
      text,
      style: TextStyle(color: Color(0xff888888), fontSize: 18),
    );
  }

  Widget _downSpeack() {
    return Stack(
      children: [
        Container(
          child: Center(
              child: Column(
            children: [
              Text(
                speakTips,
                style: TextStyle(color: Colors.blue, height: 3, fontSize: 18),
              ),
              Stack(
                children: [
                  Container(
                    height: _boxheight,
                    width: _boxheight,
                  ),
                  Center(
                      child: GestureDetector(
                    onTapDown: _speackStart,
                    onTapUp: _speackStop,
                    onTapCancel: _speackCancel,
                    child: AnimatedMic(animation: animation),
                  ))
                ],
              )
            ],
          )),
        ),
        Positioned(
            top: 80,
            right: 60,
            child: GestureDetector(
                onTap: () => {Navigator.pop(context)},
                child: Icon(Icons.close)))
      ],
    );
  }
}

// 录音按钮
class AnimatedMic extends AnimatedWidget {
  static final _opacityTween = Tween<double>(begin: 1, end: 0.5);
  static final _sizeTween =
      Tween<double>(begin: _boxheight, end: _boxheight - 20);
  AnimatedMic({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Opacity(
      opacity: _opacityTween.evaluate(animation),
      // opacity: 1,
      child: Container(
        margin: EdgeInsets.only(
            // 线性动画，在一个区间数值内线性变换.evaluate方法会返回一个具体的值
            top: Tween<double>(begin: 0, end: 10).evaluate(animation)),
        height: _sizeTween.evaluate(animation),
        width: _sizeTween.evaluate(animation),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(_boxheight / 2)),
        child: Icon(Icons.mic,
            color: Colors.white, size: _sizeTween.evaluate(animation) / 3),
      ),
    );
  }
}
