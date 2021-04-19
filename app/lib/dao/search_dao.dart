import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

// https://www.devio.org/io/flutter_app/json/home_page.json
const _url =
    'https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=';

class SearchData {
  static Future<Map<String, dynamic>> fetch(String keyword) async {
    final res = await http.get(_url + keyword);
    if (res.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      Map<String, dynamic> data =
          json.decode(utf8decoder.convert(res.bodyBytes));
      // 必须rutrun,这里类似promise的resolve
      data['reqKeyword'] = keyword;
      return data;
    } else {
      // 错误处理
      throw Exception('failed to load home_dao.json');
    }
  }
}
