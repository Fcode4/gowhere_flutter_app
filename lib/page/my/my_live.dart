import 'package:chewie/chewie.dart'; //导入chewie依赖
import 'package:flutter/cupertino.dart'; //导入iOS风格依赖
import 'package:flutter/material.dart'; //flutter默认的一套UI
import 'package:video_player/video_player.dart'; //一个video播放器

class MyLive extends StatefulWidget {
  MyLive({this.title = '电视直播'});
  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<MyLive> {
  VideoPlayerController _videoPlayerController1;
  VideoPlayerController _videoPlayerController2;
  VideoPlayerController _videoPlayerController3;
  VideoPlayerController _videoPlayerController4;
  VideoPlayerController _videoPlayerController5;
  VideoPlayerController _videoPlayerController6;
  VideoPlayerController _videoPlayerController7;
  ChewieController _chewieController;
  List<Map> Tvlist;

  List switchTv() {
    return Tvlist != null
        ? Tvlist.map((e) {
            return FlatButton(
              onPressed: () {
                //状态
                _chewieController.dispose();
                Tvlist.forEach((element) {
                  if (element['origin'] != e['origin']) {
                    element['origin'].pause(); //第2个播放功能暂停
                    // element['origin'].seekTo(Duration(seconds: 0));
                  }
                });
                setState(() {
                  _chewieController = ChewieController(
                    videoPlayerController: e['origin'], //控制当前播放控制
                    aspectRatio: 3 / 2,
                    autoPlay: true,
                    looping: true,
                  );
                });
              },
              child: Text(e['label']),
            );
          }).toList()
        : [];
  }

  @override
  void initState() {
    super.initState(); //下面network就是直播源的地址。
    _videoPlayerController1 = VideoPlayerController.network(
        'http://ivi.bupt.edu.cn/hls/cctv1hd.m3u8'); //CCTV1
    _videoPlayerController2 = VideoPlayerController.network(
        'http://ivi.bupt.edu.cn/hls/cctv3hd.m3u8'); //CCTV3
    _videoPlayerController3 = VideoPlayerController.network(
        'http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8'); //CCTV5+
    _videoPlayerController4 = VideoPlayerController.network(
        'http://ivi.bupt.edu.cn/hls/cctv6hd.m3u8'); //CCTV6
    _videoPlayerController5 = VideoPlayerController.network(
        'http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8'); //CCTV5+http://ivi.bupt.edu.cn/hls/cctv5phd.m3u8
    _videoPlayerController6 = VideoPlayerController.network(
        'http://223.110.243.171/PLTV/3/224/3221227204/index.m3u8'); //CCTV8,
    _videoPlayerController7 = VideoPlayerController.network(
        'https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4'); //演示
    setState(() {
      Tvlist = [
        // {'label': 'CCTV1', 'origin': _videoPlayerController1},
        // {'label': 'CCTV3', 'origin': _videoPlayerController2},
        // {'label': 'CCTV5', 'origin': _videoPlayerController5},
        // {'label': 'CCTV5+高清', 'origin': _videoPlayerController3},
        // {'label': 'CCTV6', 'origin': _videoPlayerController4},
        {'label': 'CCTV8', 'origin': _videoPlayerController6},
        {'label': '演示', 'origin': _videoPlayerController7},
      ];
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController6,
        aspectRatio: 3 / 2, //横宽比
        autoPlay: true, //自动播放
        looping: true, //循环 如果播放完
      );
    });
  }

  @override //下面是播放功能的控制
  void dispose() {
    Tvlist.forEach((e) {
      e['origin'].dispose();
    });
    _chewieController.dispose();
    super.dispose();
  }

  @override //渲染
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Chewie(
                controller: _chewieController,
              ),
            ),
          ),
          FlatButton(
            //这是个flat按钮
            onPressed: () {
              _chewieController.enterFullScreen();
            },
            child: Text('全屏'),
          ),
          Wrap(
              spacing: 2, //主轴上子控件的间距
              runSpacing: 5, //交叉轴上子控件之间的间距
              children: switchTv())
        ],
      ),
    );
  }
}
