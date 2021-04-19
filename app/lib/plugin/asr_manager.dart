import 'package:flutter/services.dart';

class AsrManager {
  //创建插件通信实例
  static const MethodChannel _channel = MethodChannel('asr_plugin');
  //开始录音
  static Future<String> start({Map params}) async {
    //调用java中方法并传参
    return await _channel.invokeMethod('start', params ?? {});
  }

  //停止录音
  static Future<String> stop() async {
    return await _channel.invokeMethod('stop');
  }

  //取消录音
  static Future<String> cancel() async {
    return await _channel.invokeMethod('cancel');
  }
}
