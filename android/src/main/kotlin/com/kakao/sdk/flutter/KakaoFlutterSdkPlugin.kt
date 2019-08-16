package com.kakao.sdk.flutter

import android.content.Intent
import android.net.Uri
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
      call.method == "getOrigin" -> result.success(Utility.getKeyHash(registrar.activeContext()))
      call.method == "getKaHeader" -> result.success(Utility.getKAHeader(registrar.activeContext()))
      call.method == "launchBrowserTab" -> {
        @Suppress("UNCHECKED_CAST") val args = call.arguments as Map<String, String?>
        val uri = args["url"] as String
        redirectUri = args["redirect_uri"]
        redirectUriResult = result
        AuthCodeCustomTabsActivity.startWithUrl(registrar.activity(), uri)
      }
      call.method == "authorizeWithTalk" -> {
        try {
          @Suppress("UNCHECKED_CAST") val args = call.arguments as Map<String, String>
          val clientId = args["client_id"] ?: throw IllegalArgumentException("Client id is required.")
          val redirectUri = args["redirect_uri"] ?: throw IllegalArgumentException("Redirect uri is required.")
          redirectUriResult = result
          TalkAuthCodeActivity.start(registrar.activity(), clientId, redirectUri)
        } catch (e: Exception) {
          result.error(e.javaClass.simpleName, e.localizedMessage, e)
        }
      }
      call.method == "isKakaoTalkInstalled" -> {
        result.success(Utility.isKakaoTalkInstalled(registrar.context()))
      }
      call.method == "launchKakaoTalk" -> {
        if (!Utility.isKakaoTalkInstalled(registrar.context())) {
          result.success(false)
          return
        }
        @Suppress("UNCHECKED_CAST") val args = call.arguments as Map<String, String>
        val uri = args["uri"] ?: throw IllegalArgumentException("KakaoTalk uri scheme is required.")
        val intent = Intent(Intent.ACTION_SEND, Uri.parse(uri))
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        registrar.activity().startActivity(intent)
        result.success(true)
      }
      else -> result.notImplemented()
    }
  }
}
