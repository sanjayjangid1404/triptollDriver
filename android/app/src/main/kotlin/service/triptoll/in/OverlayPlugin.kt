package service.triptoll.`in`

import android.content.Context
import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodChannel

class OverlayPlugin : FlutterPlugin {

    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext

        // ✅ Use a unique and consistent channel name
        channel = MethodChannel(binding.binaryMessenger, "service.triptoll.in/main_overlay")

        channel.setMethodCallHandler { call, result ->
            when (call.method) {

                "bringToFront" -> bringToFrontActivity(result)

                "bringToFrontCustom" -> bringToFrontActivity(result)

                else -> result.notImplemented()
            }
        }
    }

    private fun bringToFrontActivity(result: MethodChannel.Result) {
        try {
            val intent = Intent(context, MainActivity::class.java).apply {
                addFlags(
                    Intent.FLAG_ACTIVITY_NEW_TASK or
                            Intent.FLAG_ACTIVITY_CLEAR_TOP or
                            Intent.FLAG_ACTIVITY_SINGLE_TOP
                )
            }
            context.startActivity(intent)
            result.success(true)
        } catch (e: Exception) {
            result.error("ACTIVITY_ERROR", "Failed to bring activity to front: ${e.message}", null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
