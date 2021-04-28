//注册自定义插件
package com.example.app

import com.example.plugin.asr.AsrPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


import android.os.Build
import android.view.ViewTreeObserver
import android.view.WindowManager
class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // pubget引入插件不动
       GeneratedPluginRegistrant.registerWith(flutterEngine)
        //flutter sdk >= v1.17.0 时使用下面方法注册自定义plugin
        AsrPlugin.registerWith(this, flutterEngine.dartExecutor.binaryMessenger)
    }

}