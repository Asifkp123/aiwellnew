package com.qurig.aiwel

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity()
//package com.example.aiwel

//import android.content.BroadcastReceiver
//import android.content.Context
//import android.content.Intent
//import io.flutter.embedding.engine.FlutterEngine
//import io.flutter.embedding.engine.dart.DartExecutor
//import io.flutter.plugin.common.MethodChannel
//
//class BootReceiver : BroadcastReceiver() {
//    override fun onReceive(context: Context, intent: Intent) {
//        if (intent.action == "android.intent.action.BOOT_COMPLETED") {
//            val flutterEngine = FlutterEngine(context)
//            flutterEngine.dartExecutor.executeDartEntrypoint(
//                    DartExecutor.DartEntrypoint.createDefault()
//            )
//            val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "aiwel/notifications")
//            channel.invokeMethod("rescheduleNotifications", null)
//        }
//    }
//}