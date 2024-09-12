package com.example.get_android_guid
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.provider.Settings

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.get_android_guid/guid"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
                if (call.method == "getDeviceGUID") {
                    val guid = getDeviceGUID()
                    result.success(guid)
                }
                else {
                    result.notImplemented()
            }
        }
    }

    private fun getDeviceGUID(): String? {
        return Settings.Secure.getString(contentResolver, Settings.Secure.ANDROID_ID)
    }
}
