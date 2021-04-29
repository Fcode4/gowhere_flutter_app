//注册自定义插件
package com.example.app

import com.example.plugin.asr.AsrPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant


import android.os.Build
import android.os.Bundle
import android.view.ViewTreeObserver
import android.view.WindowManager
class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // pubget引入插件不动
       GeneratedPluginRegistrant.registerWith(flutterEngine)
        //flutter sdk >= v1.17.0 时使用下面方法注册自定义plugin
        AsrPlugin.registerWith(this, flutterEngine.dartExecutor.binaryMessenger)
    }

    //设置状态栏沉浸式透明（修改flutter状态栏黑色半透明为全透明）
    // override fun onCreate(savedInstanceState: Bundle?) {
    //     super.onCreate(savedInstanceState);
    //     if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
    //         window.statusBarColor = 0
            
    //     }
    // }

}