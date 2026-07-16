package com.example.my_flutter_demo

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "my_flutter_demo/local_data",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "appFilesDirectory" -> result.success(filesDir.absolutePath)
                else -> result.notImplemented()
            }
        }
    }
}
