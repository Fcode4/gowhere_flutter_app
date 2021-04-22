import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

const navbar_url = 'https://www.devio.org/io/flutter_app/json/travel_page.json';

const tab_url =
    'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';

Map<String, dynamic> fixedParams = {
  "districtId": -1,
  "groupChannelCode": "tourphoto_global1",
  "type": 1,
  "lat": -180,
  "lon": -180,
  "locatedDistrictId": 0,
  "pagePara": {
    "pageIndex": 1,
    "pageSize": 10,
    "sortType": 9,
    "sortDirection": 0
  },
  "imageCutType": 1,
  "head": {
    "cid": "09031123413109956058",
    "ctok": "",
    "cver": "1.0",
    "lang": "01",
    "sid": "8888",
    "syscode": "09",
    "auth": null,
    "extension": [
      {"name": "tecode", "value": "h5"},
      {"name": "protocal", "value": "https"}
    ]
  },
  "contentType": "json"
};

class TraveData {
  static Future<Map> fetch() async {
    final res = await http.get(navbar_url);
    if (res.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      Map<String, dynamic> data =
          json.decode(utf8decoder.convert(res.bodyBytes));
      // 必须rutrun,这里类似promise的resolve
      return data;
    } else {
      throw Exception('failed to load trave_dao.json');
    }
  }

  static Future<Map> fetchViewList(type, pageSize, pageIndex) async {
    print('请求类型$type');
    fixedParams['groupChannelCode'] = type;
    fixedParams['pagePara']['pageIndex'] = pageIndex;
    // post请求参数需要用jsonEncode转Map传送，有点类似仿前端formdata传送
    fixedParams['pagePara']['pageSize'] = pageSize;
    final res = await http.post(tab_url, body: jsonEncode(fixedParams));
    if (res.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      Map<String, dynamic> data =
          json.decode(utf8decoder.convert(res.bodyBytes));
      return data;
    } else {
      throw Exception('failed to load trave_dao.json');
    }
  }
}
