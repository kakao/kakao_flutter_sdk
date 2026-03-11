package com.kakao.sdk.flutter.common

import android.content.Intent
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry.NewIntentListener

class KakaoFlutterSdkCommonPlugin : FlutterPlugin, ActivityAware, NewIntentListener {
    private var activityBinding: ActivityPluginBinding? = null // for intent handling
    private var flutterApi: CommonFlutterApi? = null
    private var commonApiImpl: CommonHostApiImpl? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        commonApiImpl = CommonHostApiImpl(binding.applicationContext)
        CommonHostApi.setUp(binding.binaryMessenger, commonApiImpl)

        flutterApi = CommonFlutterApi(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        CommonHostApi.setUp(binding.binaryMessenger, null)

        commonApiImpl = null
        flutterApi = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        commonApiImpl?.setActivity(binding.activity)
        activityBinding = binding

        binding.addOnNewIntentListener(this)
        handleIntent(binding.activity.intent)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        commonApiImpl?.setActivity(null)
        activityBinding?.removeOnNewIntentListener(this)

        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        commonApiImpl?.setActivity(binding.activity)
        activityBinding = binding

        binding.addOnNewIntentListener(this)
    }

    override fun onDetachedFromActivity() {
        commonApiImpl?.setActivity(null)
        activityBinding?.removeOnNewIntentListener(this)

        activityBinding = null
    }

    override fun onNewIntent(intent: Intent): Boolean {
        return handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?): Boolean {
        if (intent == null || intent.data?.scheme?.startsWith("kakao") == false) return false

        val action = intent.action
        val data = intent.data ?: return false

        if ((Intent.ACTION_VIEW == action) && data.host == "kakaolink") {
            val url = data.toString()

            flutterApi?.onDeepLinkReceived(url) { /* result callback */ }
            return true
        }
        return false
    }
}
