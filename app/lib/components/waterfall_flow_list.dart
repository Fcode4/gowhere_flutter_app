import 'package:app/components/loading_container.dart';
import 'package:app/components/web_view.dart';
import 'package:app/dao/trave_dao.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

const int pageSize = 10;

// 瀑布流布局组件
class WaterfallFlowList extends StatefulWidget {
  String groupChannelCode;
  WaterfallFlowList({this.groupChannelCode = 'tourphoto_global1'});
  @override
  _Waterfall_flow_listState createState() => _Waterfall_flow_listState();
}

//实现页面不重绘 with AutomaticKeepAliveClientMixin
//会缓存占用内存影响性能
class _Waterfall_flow_listState extends State<WaterfallFlowList>
    with AutomaticKeepAliveClientMixin {
  int pageIndex = 1;
  List cardList = [];
  bool _loading = false;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _fetchData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchData(fetchMore: true);
        print('到底了');
      }
    });
    super.initState();
  }

  _fetchData({fetchMore = false}) {
    if (fetchMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }
    _loading = true;
    TraveData.fetchViewList(widget.groupChannelCode, pageSize, pageIndex)
        .then((Map data) {
      List resultList = data['resultList'].map((v) {
        if (v['article'] != null) {
          return v;
        }
      }).toList();
      setState(() {
        _loading = false;
        cardList.addAll(resultList);
      });
    }).catchError((e) {
      setState(() {
        _loading = false;
      });
      print("$e");
    });
  }

  _item(item) {
    return GestureDetector(
      onTap: () {
        if (item['article']['urls'] != null &&
            item['article']['urls'].length > 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebView(
                      title: '详情',
                      url: item['article']['urls'][0]['h5Url'],
                      hideAppBar: false)));
        }
      },
      child: PhysicalModel(
        // 无锯齿裁切
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: Column(children: [
          _itemImage(item),
          Container(
            color: Colors.white,
            child: Column(children: [
              Text(
                '${item['article']['articleTitle']}',
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: _articleInfo(item),
              )
            ]),
          )
        ]),
      ),
    );
  }

  _articleInfo(item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(right: 4),
              height: 30,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    item['article']['author']['coverImage']['originalUrl']),
              ),
            ),
            LimitedBox(
                maxWidth: 100,
                child: Text(
                  '${item['article']['author']['nickName']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
        Row(children: [
          Icon(
            Icons.thumb_up,
            size: 14,
            color: Colors.black45,
          ),
          Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text('${item['article']['likeCount']}'),
          )
        ])
      ],
    );
  }

  _itemImage(item) {
    return Stack(
      children: [
        Image.network(_imageUrl(item)),
        Positioned(
            left: 4,
            bottom: 8,
            child: RawChip(
              labelStyle: TextStyle(color: Colors.white),
              labelPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              backgroundColor: Colors.black87,
              avatar: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.location_on,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              label: LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    _labelText(item),
                    style: TextStyle(fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
            ))
      ],
    );
  }

  _imageUrl(item) {
    if (item['article']['images'] != null &&
        item['article']['images'].length > 0) {
      return item['article']['images'][0]['originalUrl'];
    }
  }

  _labelText(item) {
    if (item['article']['pois'] != null && item['article']['pois'].length > 0) {
      return item['article']['pois'][0]['poiName'];
    } else {
      return '未知';
    }
  }

  Future<Null> _refresh() async {
    _fetchData();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
      isLoading: _loading,
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Container(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              color: Color(0xfff5f5f5),
              child: StaggeredGridView.countBuilder(
                controller: _scrollController,
                crossAxisCount: 4,
                itemCount: cardList?.length ?? 0,
                itemBuilder: (BuildContext context, int index) =>
                    _item(cardList[index]),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
              ),
            )),
      ),
    );
  }

// 实现页面不重绘
  @override
  bool get wantKeepAlive => true;
}
