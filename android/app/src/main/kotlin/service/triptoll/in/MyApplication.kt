package service.triptoll.`in`

import android.app.Application
import android.content.Intent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MyApplication : Application() {

    companion object {
        lateinit var overlayEngine: FlutterEngine
    }

    override fun onCreate() {
        super.onCreate()

        // FlutterEngine initialize
        overlayEngine = FlutterEngine(this)
        overlayEngine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        )
        GeneratedPluginRegistrant.registerWith(overlayEngine)

        MethodChannel(
            overlayEngine.dartExecutor.binaryMessenger,
            "service.triptoll.in/overlay"
        ).setMethodCallHandler { call, result ->
            if (call.method == "bringToFront") {
                val intent = Intent(this, MainActivity::class.java)
                intent.addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
                startActivity(intent)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }
}
