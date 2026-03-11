package com.kakao.sdk.flutter.auth

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class KakaoFlutterSdkAuthPlugin : FlutterPlugin, ActivityAware {
    private var apiImpl: AuthHostApiImpl? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        apiImpl = AuthHostApiImpl()

        AuthHostApi.setUp(binding.binaryMessenger, apiImpl)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        AuthHostApi.setUp(binding.binaryMessenger, null)
        apiImpl = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        apiImpl?.setActivity(binding.activity)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        apiImpl?.setActivity(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        apiImpl?.setActivity(binding.activity)
    }

    override fun onDetachedFromActivity() {
        apiImpl?.setActivity(null)
    }
}
