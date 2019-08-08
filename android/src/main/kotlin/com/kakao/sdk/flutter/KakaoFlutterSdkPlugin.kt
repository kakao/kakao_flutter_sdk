package com.kakao.sdk.flutter

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class KakaoFlutterSdkPlugin(private val registrar: Registrar) : MethodCallHandler {
  companion object {
    var redirectUri: String? = null
    lateinit var redirectUriResult: Result
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "kakao_flutter_sdk")
      channel.setMethodCallHandler(KakaoFlutterSdkPlugin(registrar))
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when {
      call.method == "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
      call.method == "getOrigin" -> result.success(Utility.getKeyHash(registrar.activeContext()))
      call.method == "getKaHeader" -> result.success(Utility.getKAHeader(registrar.activeContext()))
      call.method == "launchWithBrowserTab" -> {
        @Suppress("UNCHECKED_CAST") val args = call.arguments as Map<String, String?>
        val uri = args["url"] as String
        redirectUri = args["redirect_uri"]
        redirectUriResult = result
        AuthCodeCustomTabsActivity.startWithUrl(registrar.activity(), uri)
      }
      call.method == "authorizeWithTalk" -> {
        try {
          @Suppress("UNCHECKED_CAST") val args = call.arguments as Map<String, String>
          val clientId = args["client_id"] ?: throw IllegalArgumentException()
          val redirectUri = args["redirect_uri"] ?: throw IllegalArgumentException()
          redirectUriResult = result
          TalkAuthCodeActivity.start(registrar.activity(), clientId, redirectUri)
        } catch (e: Exception) {
          result.error(e.toString(), e.toString(), e)
        }

      }
      else -> result.notImplemented()
    }
  }
}
