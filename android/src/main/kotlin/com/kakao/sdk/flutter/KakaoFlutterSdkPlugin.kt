package com.kakao.sdk.flutter

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class KakaoFlutterSdkPlugin : MethodCallHandler, FlutterPlugin, ActivityAware {
  private var _applicationContext: Context? = null
  private val applicationContext get() = _applicationContext!!

  private var _channel: MethodChannel? = null
  private val channel get() = _channel!!

  private var _activity: Activity? = null
  private val activity get() = _activity!!

  companion object {
    var redirectUri: String? = null
    lateinit var redirectUriResult: Result
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val instance = KakaoFlutterSdkPlugin()
      instance.onAttachedToEngine(registrar.context(), registrar.messenger())
      instance.onAttachedToActivity(registrar.activity())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when {
      call.method == "getOrigin" -> result.success(Utility.getKeyHash(applicationContext))
      call.method == "getKaHeader" -> result.success(Utility.getKAHeader(applicationContext))
      call.method == "launchBrowserTab" -> {
        @Suppress("UNCHECKED_CAST") val args = call.arguments as Map<String, String?>
        val uri = args["url"] as String
        redirectUri = args["redirect_uri"]
        redirectUriResult = result
        AuthCodeCustomTabsActivity.startWithUrl(activity, uri)
      }
      call.method == "authorizeWithTalk" -> {
        try {
          @Suppress("UNCHECKED_CAST") val args = call.arguments as Map<String, String>
          val clientId = args["client_id"] ?: throw IllegalArgumentException("Client id is required.")
          val redirectUri = args["redirect_uri"] ?: throw IllegalArgumentException("Redirect uri is required.")
          redirectUriResult = result
          TalkAuthCodeActivity.start(activity, clientId, redirectUri)
        } catch (e: Exception) {
          result.error(e.javaClass.simpleName, e.localizedMessage, e)
        }
      }
      call.method == "isKakaoTalkInstalled" -> {
        result.success(Utility.isKakaoTalkInstalled(applicationContext))
      }
      call.method == "isKakaoNaviInstalled" -> {
        result.success(Utility.isKakaoNaviInstalled(applicationContext))
      }
      call.method == "launchKakaoTalk" -> {
        if (!Utility.isKakaoTalkInstalled(applicationContext)) {
          result.success(false)
          return
        }
        @Suppress("UNCHECKED_CAST") val args = call.arguments as Map<String, String>
        val uri = args["uri"] ?: throw IllegalArgumentException("KakaoTalk uri scheme is required.")
        val intent = Intent(Intent.ACTION_SEND, Uri.parse(uri))
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        applicationContext.startActivity(intent)
        result.success(true)
      }
      call.method == "isKakaoLinkAvailable" -> {
        val uriBuilder = Uri.Builder().scheme("kakaolink").authority("send")
        val linkIntentClient = IntentResolveClient.instance
        val isKakaoLinkAvailable = linkIntentClient.resolveTalkIntent(applicationContext, Intent(Intent.ACTION_VIEW, uriBuilder.build())) != null
        result.success(isKakaoLinkAvailable)
      }
      else -> result.notImplemented()
    }
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    onAttachedToEngine(binding.applicationContext, binding.binaryMessenger)
  }

  private fun onAttachedToEngine(applicationContext: Context, messenger: BinaryMessenger) {
    _applicationContext = applicationContext
    _channel = MethodChannel(messenger, "kakao_flutter_sdk")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    _applicationContext = null
    channel.setMethodCallHandler(null)
    _channel = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    _activity = binding.activity
  }

  private fun onAttachedToActivity(activity: Activity) {
    _activity = activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    _activity = binding.activity
  }

  override fun onDetachedFromActivity() {
    _activity = null
  }
}
