import 'package:app/components/loading_container.dart';
import 'package:app/components/web_view.dart';
import 'package:app/dao/trave_dao.dart';
import 'package:app/utils/cusBehavior.dart';
import 'package:app/utils/navigator_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

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
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
    });
  }

  _item(item) {
    return GestureDetector(
      onTap: () {
        if (item['article']['urls'] != null &&
            item['article']['urls'].length > 0) {
          NavigatorUtil.push(
              context,
              WebView(
                  title: '详情',
                  url: item['article']['urls'][0]['h5Url'],
                  hideAppBar: false));
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
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                '${item['article']['articleTitle']}',
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
              Padding(
                padding: EdgeInsets.all(5),
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
          children: [
            Container(
              padding: EdgeInsets.only(right: 4),
              height: 24,
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    item['article']['author']['coverImage']['originalUrl']),
              ),
            ),
            LimitedBox(
                maxWidth: 50,
                child: Text(
                  '${item['article']['author']['nickName']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ))
          ],
        ),
        Row(children: [
          Container(
            margin: EdgeInsets.only(right: 4),
            child: Icon(
              Icons.thumb_up,
              size: 14,
              color: Colors.black45,
            ),
          ),
          Text('${item['article']['likeCount']}'),
        ])
      ],
    );
  }

  _itemImage(item) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
            //设置最小初始高度，防止动态图片高度时的抖动
            constraints: BoxConstraints(minHeight: size.width / 2 - 10),
            child: new FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _imageUrl(item),
                fit: BoxFit.cover)),
        Positioned(
            left: 4,
            bottom: 8,
            child: RawChip(
              labelStyle: TextStyle(
                color: Colors.white,
              ),
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
                  maxWidth: 100,
                  child: Text(
                    _labelText(item),
                    style: TextStyle(fontSize: 12),
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
              child: ScrollConfiguration(
                behavior: CusBehavior(),
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
              ),
            )),
      ),
    );
  }

// 实现页面不重绘
  @override
  bool get wantKeepAlive => true;
}
