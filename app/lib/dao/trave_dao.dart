import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

const navbar_url = 'https://www.devio.org/io/flutter_app/json/travel_page.json';

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
}
